import 'package:flutter/material.dart';
import 'package:save_phone/utils/extensions/build_context_ext.dart';

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
    bool isButtonOn = LiquidButtonNotifier.isOn.value;
    LiquidButtonNotifier.isOn.value = !isButtonOn;
    _handleAnimation(!isButtonOn);
  }

  void _handleAnimation(bool isOn) async {
    if (!isOn) {
      await _animationController.animateTo(0);
      _animationController.stop();
    } else {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
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
      child: ValueListenableBuilder(
        valueListenable: LiquidButtonNotifier.isOn,
        builder: (context, isButtonOn, child) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return Ink(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isButtonOn
                      ? context.colorScheme.primary
                          .withOpacity(1 - _animationController.value / 2)
                      : context.colorScheme.background,
                  boxShadow: [
                    for (int i = 1; i <= 2; i++)
                      BoxShadow(
                        color: context.colorScheme.primary
                            .withOpacity(_animationController.value / 2),
                        spreadRadius: _animation.value * i,
                      )
                  ],
                ),
                child: _PowerIcon(isTapped: isButtonOn),
              );
            },
          );
        },
      ),
    );
  }
}

class _PowerIcon extends StatelessWidget {
  final bool isTapped;

  const _PowerIcon({required this.isTapped});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.power_settings_new,
      color: isTapped
          ? context.colorScheme.onPrimary
          : context.colorScheme.onBackground,
      size: 132,
    );
  }
}

class LiquidButtonNotifier {
  LiquidButtonNotifier._();

  static ValueNotifier<bool> isOn = ValueNotifier(false);
}
