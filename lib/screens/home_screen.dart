import 'package:flutter/material.dart';
import 'package:movies_app_flutter/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie listings'),
        elevation: 0,
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: const Column(
        children: [
          CardSwiper(),
        ],
      ),
    );
  }
}
