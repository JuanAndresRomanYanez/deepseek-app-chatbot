import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalSearchService {
  static Database? _db;

  /// Inicializar la base de datos local (llamar una sola vez desde main)
  static Future<void> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, 'chroma.sqlite3');

    if (!File(dbPath).existsSync()) {
      final data = await rootBundle.load('assets/data/chroma.sqlite3');
      await File(dbPath).writeAsBytes(
        data.buffer.asUint8List(),
        flush: true,
      );
    }

    _db = await openDatabase(dbPath, readOnly: true);
  }

  /// Normalize
  static String _normExpr(String field) {
    return '''
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                REPLACE(
                  LOWER($field),
                'á','a'),
              'é','e'),
            'í','i'),
          'ó','o'),
        'ú','u'),
      'ñ','n')
    ''';
  }

  /// Busca en embedding_metadata y devuelve lista de { content, source, hits }
  static Future<List<Map<String, dynamic>>> search(String query, {int limit = 30,}) async {
    if (_db == null) {
      throw Exception('LocalSearchService not initialized');
    }

    // Expresiones normalizadas
    final normDoc = _normExpr('doc.string_value');
    final normQ   = _normExpr('?');

    final sql = '''
    SELECT
      doc.id                               AS docid,
      doc.string_value                     AS content,
      src.string_value                     AS source,
      (
        LENGTH($normDoc)
        - LENGTH(REPLACE($normDoc, $normQ, ''))
      ) / LENGTH($normQ)                   AS hits
    FROM embedding_metadata AS doc
    JOIN embedding_metadata AS src
      ON src.id = doc.id
     AND src.key = 'source'
    WHERE doc.key = 'chroma:document'
      AND $normDoc LIKE '%' || $normQ || '%'
    ORDER BY hits DESC
    LIMIT ?
    ''';

    return await _db!.rawQuery(sql, [query, query, query, limit]);
  }
}
