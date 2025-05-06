// recycle_bin_view.dart
import 'package:flutter/material.dart';

class RecycleBinView extends StatelessWidget {
  const RecycleBinView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Papelera')),
      body: const Center(child: Text('Elementos eliminados')),
    );
  }
}
