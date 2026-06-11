import 'package:flutter/material.dart';
import '../theme/brutal.dart';

class AkinatorCharacter extends StatelessWidget {
  final double size;

  const AkinatorCharacter({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return BrutalBox(
      color: BrutalColors.purple,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          'assets/images/maxresdefault.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(),
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      color: BrutalColors.purple,
      child: Center(
        child: Text(
          '🔮',
          style: TextStyle(fontSize: size * 0.45),
        ),
      ),
    );
  }
}
