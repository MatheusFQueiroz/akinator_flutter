import 'package:flutter/material.dart';

class ProfessorAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const ProfessorAvatar({
    super.key,
    required this.name,
    this.radius = 50,
  });

  static const Map<String, String> _imageMap = {
    'Guilherme Alves': 'guilherme_alves.png',
    'Jefferson Speck': 'jefferson_speck.png',
    'Marcos Guido': 'marcos_guido.png',
    'Jeferson Vorpagel': 'jeferson_vorpagel.png',
    'Vander': 'vander.png',
  };

  static const _colors = [
    Colors.purple,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.indigo,
    Colors.cyan,
    Colors.deepOrange,
    Colors.amber,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.brown,
    Colors.red,
  ];

  Color _getColor() {
    final index = name.hashCode.abs() % _colors.length;
    return _colors[index];
  }

  String _getInitials() {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  String _getImagePath() {
    if (_imageMap.containsKey(name)) {
      return 'assets/images/${_imageMap[name]}';
    }
    final normalized = name
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('ã', 'a')
        .replaceAll('í', 'i')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('ç', 'c');
    return 'assets/images/$normalized.png';
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _getImagePath();

    return CircleAvatar(
      radius: radius,
      backgroundColor: _getColor(),
      backgroundImage: AssetImage(imagePath),
      onBackgroundImageError: (_, __) {},
      child: Text(
        _getInitials(),
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
