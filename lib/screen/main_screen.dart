// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'arcore_screen.dart';
import 'track_screen.dart';
import 'imu_screen.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentIndex = useState(0);

    const _childPageList = [
      IMUScreen(),
      ARCoreScreen(),
      TrackScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: null,
        toolbarHeight: 0,
      ),
      body: IndexedStack(
        index: _currentIndex.value,
        children: _childPageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex.value,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "IMU",
            icon: Icon(
              Icons.smartphone,
            ),
          ),
          BottomNavigationBarItem(
            label: "ARCore",
            icon: Icon(
              Icons.photo_camera,
            ),
          ),
          BottomNavigationBarItem(
            label: "Trajectory",
            icon: Icon(
              Icons.directions_walk,
            ),
          )
        ],
        onTap: (int index) {
          _currentIndex.value = index;
        },
      ),
    );
  }
}
