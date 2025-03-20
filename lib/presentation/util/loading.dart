import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Widget child;
  final ValueNotifier<bool> loading;
  final Color color;

  const Loading({
    required this.child,
    required this.loading,
    super.key,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: loading,
      builder: (context, loading, _) => Stack(
        children: [
          child,
          if (loading)
            Container(
              color: Colors.black.withAlpha(0xCC),
              child: Center(
                child: StyledProgressBar(color: color),
              ),
            ),
        ],
      ),
    );
  }
}

class StyledProgressBar extends StatelessWidget {
  final Color color;

  const StyledProgressBar({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}
