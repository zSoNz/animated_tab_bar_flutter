import "package:flutter/material.dart";

class AnimatedTabBar extends StatefulWidget {
  final List<Icon> icons;
  final List<String> labels;
  final Function(int) onItemTapped;
  final Color? bottomBarColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  const AnimatedTabBar(
      {required this.icons,
      required this.labels,
      required this.onItemTapped,
      this.bottomBarColor,
      this.selectedColor,
      this.unselectedColor,
      super.key})
      : assert(icons.length == labels.length,
            "Icons and labels must have the same length");

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<GlobalKey> _buttonKeys;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _buttonKeys = List.generate(widget.icons.length, (_) => GlobalKey());

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _controller.forward(from: 0);
    widget.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;

      return Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: TabBarPainter(
                    selectedIndex: _selectedIndex,
                    animationValue: _animation.value,
                    buttonKeys: _buttonKeys,
                    screenWidth: screenWidth,
                  ),
                );
              },
            ),
          ),
          BottomAppBar(
            color: widget.bottomBarColor ?? Colors.deepPurple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(widget.icons.length, (index) {
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  key: _buttonKeys[index],
                  onTap: () => _onItemTapped(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          final scale =
                              isSelected ? 1 + 0.5 * _animation.value : 1.0;
                          return Transform.scale(
                            scale: scale,
                            child: Icon(
                              widget.icons[index].icon,
                              color: isSelected
                                  ? widget.selectedColor ?? Colors.orange
                                  : widget.unselectedColor ?? Colors.grey,
                              size: 30,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.labels[index],
                        style: TextStyle(
                          color: isSelected
                              ? widget.selectedColor ?? Colors.orange
                              : widget.unselectedColor ?? Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class TabBarPainter extends CustomPainter {
  final int selectedIndex;
  final double animationValue;
  final List<GlobalKey> buttonKeys;
  final double screenWidth;
  final Color? bottomBarColor;

  TabBarPainter({
    required this.selectedIndex,
    required this.animationValue,
    required this.buttonKeys,
    required this.screenWidth,
    this.bottomBarColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = bottomBarColor ?? Colors.deepPurple
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;

    final selectedButtonKey = buttonKeys[selectedIndex];
    final renderBox =
        selectedButtonKey.currentContext?.findRenderObject() as RenderBox?;
    final centerX = renderBox != null
        ? renderBox.localToGlobal(Offset.zero).dx + renderBox.size.width / 2
        : screenWidth / 2;
    final waveHeight = 16 * animationValue;
    final waveWidth = width / buttonKeys.length;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(centerX - waveWidth / 2, 0)
      ..cubicTo(
        centerX - waveWidth / 2 + waveWidth / 4,
        0,
        centerX - waveWidth / 4,
        -waveHeight,
        centerX,
        -waveHeight,
      )
      ..cubicTo(
        centerX + waveWidth / 4,
        -waveHeight,
        centerX + waveWidth / 2 - waveWidth / 4,
        0,
        centerX + waveWidth / 2,
        0,
      )
      ..lineTo(width, 0)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
