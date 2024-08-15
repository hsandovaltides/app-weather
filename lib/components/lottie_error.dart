import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class LottieError extends HookConsumerWidget {
  const LottieError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [Lottie.asset('assets/lottie/error_dog.json', repeat: true, width: double.infinity), Text(message)],
          ),
        )
      ],
    );
  }
}
