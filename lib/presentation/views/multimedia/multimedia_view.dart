// multimedia_view.dart
import 'package:flutter/material.dart';

class MultimediaView extends StatelessWidget {
  const MultimediaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multimedia')),
      body: const Center(child: Text('Gestión de fotos, videos y otros archivos')),
    );
  }
}
