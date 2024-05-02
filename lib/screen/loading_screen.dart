import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Created by Chandan Jana on 14-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Stack(
            children: [
              // Your main content
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  // Semi-transparent black background
                  child: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.blueAccent,
                      size: 70,
                    ), // Loading indicator
                  ),
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
