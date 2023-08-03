import 'package:flutter/material.dart';

class LiquidButton extends StatefulWidget {
  const LiquidButton({super.key});

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () {},
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(1 - _animationController.value / 2),
              shape: BoxShape.circle,
              boxShadow: [
                for (int i = 1; i <= 2; i++)
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(_animationController.value / 2),
                    spreadRadius: _animation.value * i,
                  )
              ],
            ),
            child: Icon(
              Icons.power_settings_new,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 132,
            ),
          );
        },
      ),
    );
  }
}
