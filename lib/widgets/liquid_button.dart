import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/liquid_button_provider.dart';

class LiquidButton extends StatefulWidget {
  const LiquidButton({super.key});

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton>
    with TickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationController;

  void _handleTap() {
    final buttonState = context.read<LiquidButtonProvider>();
    buttonState.toggle();
    _handleAnimation(buttonState.isOn);
  }

  void _handleAnimation(bool isOn) {
    if (!isOn) {
      _animationController
          .animateTo(0)
          .then((_) => _animationController.stop());
    } else {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: _handleTap,
      child: Consumer(
        builder: (context, LiquidButtonProvider buttonState, _) {
          ColorScheme colorScheme = Theme.of(context).colorScheme;

          return AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return Ink(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonState.isOn
                      ? colorScheme.primary
                          .withOpacity(1 - _animationController.value / 2)
                      : colorScheme.background,
                  boxShadow: [
                    for (int i = 1; i <= 2; i++)
                      BoxShadow(
                        color: colorScheme.primary
                            .withOpacity(_animationController.value / 2),
                        spreadRadius: _animation.value * i,
                      )
                  ],
                ),
                child: _TheIcon(isTapped: buttonState.isOn),
              );
            },
          );
        },
      ),
    );
  }
}

class _TheIcon extends StatelessWidget {
  final bool isTapped;

  const _TheIcon({required this.isTapped});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.power_settings_new,
      color: isTapped
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onBackground,
      size: 132,
    );
  }
}
