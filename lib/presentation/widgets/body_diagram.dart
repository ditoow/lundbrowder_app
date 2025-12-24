import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Simple body diagram widget for burn area visualization
class BodyDiagram extends StatelessWidget {
  final bool isFrontView;
  final List<String> selectedAreas;

  const BodyDiagram({
    super.key,
    required this.isFrontView,
    required this.selectedAreas,
  });

  bool _isAreaSelected(String area) {
    return selectedAreas.contains(area);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            isFrontView ? 'Tampak Depan' : 'Tampak Belakang',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: CustomPaint(
              size: const Size(150, 280),
              painter: _BodyPainter(
                isFrontView: isFrontView,
                isHeadSelected: _isAreaSelected('head_neck'),
                isLeftArmSelected: _isAreaSelected('left_arm'),
                isRightArmSelected: _isAreaSelected('right_arm'),
                isTorsoSelected: isFrontView
                    ? _isAreaSelected('front_torso')
                    : _isAreaSelected('back_torso'),
                isLeftLegSelected: _isAreaSelected('left_leg'),
                isRightLegSelected: _isAreaSelected('right_leg'),
                isGenitalSelected: _isAreaSelected('genital') && isFrontView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  final bool isFrontView;
  final bool isHeadSelected;
  final bool isLeftArmSelected;
  final bool isRightArmSelected;
  final bool isTorsoSelected;
  final bool isLeftLegSelected;
  final bool isRightLegSelected;
  final bool isGenitalSelected;

  _BodyPainter({
    required this.isFrontView,
    required this.isHeadSelected,
    required this.isLeftArmSelected,
    required this.isRightArmSelected,
    required this.isTorsoSelected,
    required this.isLeftLegSelected,
    required this.isRightLegSelected,
    required this.isGenitalSelected,
  });

  Paint _getPaint(bool isSelected) {
    return Paint()
      ..color = isSelected
          ? AppColors.severityBerat.withAlpha((0.7 * 255).round())
          : Colors.grey.shade300
      ..style = PaintingStyle.fill;
  }

  Paint get _borderPaint => Paint()
    ..color = Colors.grey.shade600
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Head
    final headRect = Rect.fromCenter(
      center: Offset(centerX, 25),
      width: 40,
      height: 45,
    );
    canvas.drawOval(headRect, _getPaint(isHeadSelected));
    canvas.drawOval(headRect, _borderPaint);

    // Neck
    final neckRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(centerX, 55), width: 20, height: 15),
      const Radius.circular(4),
    );
    canvas.drawRRect(neckRect, _getPaint(isHeadSelected));
    canvas.drawRRect(neckRect, _borderPaint);

    // Torso
    final torsoPath = Path();
    torsoPath.moveTo(centerX - 35, 62);
    torsoPath.lineTo(centerX + 35, 62);
    torsoPath.lineTo(centerX + 30, 140);
    torsoPath.lineTo(centerX - 30, 140);
    torsoPath.close();
    canvas.drawPath(torsoPath, _getPaint(isTorsoSelected));
    canvas.drawPath(torsoPath, _borderPaint);

    // Left arm (viewer's left = body's right)
    final leftArmPath = Path();
    leftArmPath.moveTo(centerX + 35, 65);
    leftArmPath.lineTo(centerX + 50, 70);
    leftArmPath.lineTo(centerX + 60, 130);
    leftArmPath.lineTo(centerX + 48, 133);
    leftArmPath.lineTo(centerX + 40, 100);
    leftArmPath.lineTo(centerX + 35, 90);
    leftArmPath.close();
    canvas.drawPath(leftArmPath, _getPaint(isRightArmSelected));
    canvas.drawPath(leftArmPath, _borderPaint);

    // Right arm
    final rightArmPath = Path();
    rightArmPath.moveTo(centerX - 35, 65);
    rightArmPath.lineTo(centerX - 50, 70);
    rightArmPath.lineTo(centerX - 60, 130);
    rightArmPath.lineTo(centerX - 48, 133);
    rightArmPath.lineTo(centerX - 40, 100);
    rightArmPath.lineTo(centerX - 35, 90);
    rightArmPath.close();
    canvas.drawPath(rightArmPath, _getPaint(isLeftArmSelected));
    canvas.drawPath(rightArmPath, _borderPaint);

    // Genital (front view only)
    if (isFrontView) {
      final genitalRect = Rect.fromCenter(
        center: Offset(centerX, 148),
        width: 15,
        height: 12,
      );
      canvas.drawOval(genitalRect, _getPaint(isGenitalSelected));
      canvas.drawOval(genitalRect, _borderPaint);
    }

    // Left leg (viewer's left = body's right)
    final leftLegPath = Path();
    leftLegPath.moveTo(centerX + 5, 140);
    leftLegPath.lineTo(centerX + 28, 140);
    leftLegPath.lineTo(centerX + 25, 250);
    leftLegPath.lineTo(centerX + 8, 250);
    leftLegPath.close();
    canvas.drawPath(leftLegPath, _getPaint(isRightLegSelected));
    canvas.drawPath(leftLegPath, _borderPaint);

    // Right leg
    final rightLegPath = Path();
    rightLegPath.moveTo(centerX - 5, 140);
    rightLegPath.lineTo(centerX - 28, 140);
    rightLegPath.lineTo(centerX - 25, 250);
    rightLegPath.lineTo(centerX - 8, 250);
    rightLegPath.close();
    canvas.drawPath(rightLegPath, _getPaint(isLeftLegSelected));
    canvas.drawPath(rightLegPath, _borderPaint);
  }

  @override
  bool shouldRepaint(covariant _BodyPainter oldDelegate) {
    return oldDelegate.isHeadSelected != isHeadSelected ||
        oldDelegate.isLeftArmSelected != isLeftArmSelected ||
        oldDelegate.isRightArmSelected != isRightArmSelected ||
        oldDelegate.isTorsoSelected != isTorsoSelected ||
        oldDelegate.isLeftLegSelected != isLeftLegSelected ||
        oldDelegate.isRightLegSelected != isRightLegSelected ||
        oldDelegate.isGenitalSelected != isGenitalSelected;
  }
}
