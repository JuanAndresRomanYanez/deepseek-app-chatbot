// audio_record_view.dart
import 'package:flutter/material.dart';

class AudioRecordView extends StatelessWidget {
  const AudioRecordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grabación de Audio')),
      body: const Center(child: Text('Controles de grabación de audio')),
    );
  }
}
