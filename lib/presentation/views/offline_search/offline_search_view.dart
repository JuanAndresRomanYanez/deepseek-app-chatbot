import 'package:flutter/material.dart';

import 'package:deepseek_app/infrastructure/services/services.dart';
import 'package:deepseek_app/presentation/widgets/widgets.dart';

class OfflineSearchView extends StatefulWidget {
  const OfflineSearchView({super.key});

  @override
  State<OfflineSearchView> createState() => _OfflineSearchViewState();
}

class _OfflineSearchViewState extends State<OfflineSearchView> {
  final _ctrl = TextEditingController();
  final _speechService = SpeechService();
  bool _listening = false, _loading = false;
  List<Map<String, dynamic>> _results = [];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _doSearch(String q) async {
    if (q.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _results = [];
    });
    final rows = await LocalSearchService.search(q, limit: 30);
    setState(() {
      _results = rows;
      _loading = false;
    });
  }

  Future<void> _toggleMic() async {
    if (_listening) {
      _speechService.stopListening();
      setState(() => _listening = false);
    } else {
      final ok = await _speechService.initSpeech();
      if (!ok) return;
      setState(() => _listening = true);
      _speechService.startListening((words, isFinal) {
        setState(() => _ctrl.text = words);
        if (isFinal) {
          _speechService.stopListening();
          setState(() => _listening = false);
          _doSearch(words);
        }
      });
    }
  }

  void _showDetail(String content, String source, num hits) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => OfflineDetailSheet(
        content: content,
        source: source,
        hits: hits,
        speechService: _speechService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OfflineSearchBar(
          controller: _ctrl,
          listening: _listening,
          onMicToggle: _toggleMic,
          onSearch: _doSearch,
        ),

        if (_loading) const LinearProgressIndicator(),

        Expanded(
          child: _results.isEmpty
              ? const Center(child: Text("No hay resultados"))
              : ListView.separated(
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: _results.length,
                  itemBuilder: (_, i) {
                    final row     = _results[i];
                    final content = row['content'] as String;
                    final rawSrc  = row['source']?.toString() ?? '';
                    final hits    = row['hits'] as num;

                    return OfflineResultTile(
                      content: content,
                      rawSource: rawSrc,
                      hits: hits,
                      onTap: _showDetail,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
