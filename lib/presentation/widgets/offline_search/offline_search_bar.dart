import 'package:flutter/material.dart';

typedef OnSearch = Future<void> Function(String query);
typedef OnMicToggle = Future<void> Function();

class OfflineSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool listening;
  final OnMicToggle onMicToggle;
  final OnSearch onSearch;

  const OfflineSearchBar({
    super.key,
    required this.controller,
    required this.listening,
    required this.onMicToggle,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(24);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Material(
        elevation: 2,
        shadowColor: Colors.black26,
        borderRadius: radius,
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          onSubmitted: onSearch,
          decoration: InputDecoration(
            hintText: 'Buscar en el código (offline)…',
            border: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => onSearch(controller.text),
            ),
            suffixIcon: IconButton(
              icon: Icon(listening ? Icons.mic : Icons.mic_none),
              onPressed: onMicToggle,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      ),
    );
  }
}
