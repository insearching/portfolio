import 'package:flutter/material.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:portfolio/utils/measure_size.dart';

class SkillProgressBar extends StatefulWidget {
  const SkillProgressBar({
    required this.title,
    required this.progress,
    required this.startColor,
    required this.endColor,
    super.key,
  });

  final String title;
  final int progress;
  final Color startColor;
  final Color endColor;

  @override
  State<SkillProgressBar> createState() => _SkillProgressBarState();
}

class _SkillProgressBarState extends State<SkillProgressBar> {
  OverlayEntry? sticky;
  GlobalKey stickyKey = GlobalKey();

  Size progressBarSize = const Size(0, 0);

  @override
  Widget build(BuildContext context) {
    final percentString = '${widget.progress.toStringAsFixed(0)}%';

    const height = 8.0;
    const radius = 3.0;
    return MeasureSize(
      onChange: (Size size) {
        setState(() {
          progressBarSize = size;
        });
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              Text(
                percentString,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [UIColors.black, UIColors.backgroundColorLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: progressBarSize.width / 100 * widget.progress,
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [widget.startColor, widget.endColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0)
        ],
      ),
    );
  }
}
