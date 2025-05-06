import 'dart:math';
import 'package:flutter/material.dart';

typedef OnTapResult = void Function(String content, String source, num hits);

class OfflineResultTile extends StatelessWidget {
  final String content;
  final String rawSource;
  final num hits;
  final OnTapResult onTap;
  final int snippetLen;

  const OfflineResultTile({
    super.key,
    required this.content,
    required this.rawSource,
    required this.hits,
    required this.onTap,
    this.snippetLen = 80,
  });

  String _cleanSource(String raw) {
    final noPrefix = raw.replaceAll(RegExp(r'^data[\\/]raw_docs[\\/]+'), '');
    return noPrefix.replaceAll(RegExp(r'\.txt$', caseSensitive: false), '');
  }

  @override
  Widget build(BuildContext context) {
    final source = _cleanSource(rawSource);
    final cutIndex = min(snippetLen, content.length);
    final snippet = content.substring(0, cutIndex).trim();

    return ListTile(
      title: Text(
        snippet,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text("Coincidencias: $hits  •  Fuente: ${source.isNotEmpty ? source : 'desconocido'}"),
      onTap: () => onTap(content, source, hits),
    );
  }
}
