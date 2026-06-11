import 'package:flutter/material.dart';

/// Paleta neo-brutalista: fundo claro, cores chapadas vibrantes,
/// contornos pretos grossos e sombras duras (sem blur).
class BrutalColors {
  BrutalColors._();

  static const bg = Color(0xFFF2EDE4);
  static const ink = Color(0xFF111111);
  static const white = Color(0xFFFFFFFF);
  static const purple = Color(0xFF8B5CF6);
  static const lilac = Color(0xFFD8CCF5);
  static const yellow = Color(0xFFFFC700);
  static const green = Color(0xFF4ADE80);
  static const lightGreen = Color(0xFFC8F169);
  static const gray = Color(0xFFD6D3CD);
  static const orange = Color(0xFFFFA94D);
  static const red = Color(0xFFFF6B6B);
}

/// Caixa brutalista: cor chapada, borda preta grossa e sombra dura.
class BrutalBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final double shadowOffset;
  final double borderWidth;

  const BrutalBox({
    super.key,
    required this.child,
    this.color = BrutalColors.white,
    this.padding,
    this.shadowOffset = 5,
    this.borderWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: BrutalColors.ink, width: borderWidth),
        boxShadow: [
          if (shadowOffset > 0)
            BoxShadow(
              color: BrutalColors.ink,
              offset: Offset(shadowOffset, shadowOffset),
            ),
        ],
      ),
      child: child,
    );
  }
}

/// Etiqueta pequena (chip) brutalista.
class BrutalTag extends StatelessWidget {
  final String text;
  final Color color;

  const BrutalTag({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return BrutalBox(
      color: color,
      shadowOffset: 3,
      borderWidth: 2,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: BrutalColors.ink,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Botão brutalista: ao pressionar, desloca para a posição da sombra.
class BrutalButton extends StatefulWidget {
  final Widget child;
  final Color color;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final double shadowOffset;

  const BrutalButton({
    super.key,
    required this.child,
    required this.color,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.shadowOffset = 5,
  });

  @override
  State<BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<BrutalButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final offset = _pressed ? widget.shadowOffset : 0.0;
    return GestureDetector(
      onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        transform: Matrix4.translationValues(offset, offset, 0),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _enabled ? widget.color : BrutalColors.gray,
          border: Border.all(color: BrutalColors.ink, width: 3),
          boxShadow: [
            if (!_pressed)
              BoxShadow(
                color: BrutalColors.ink,
                offset: Offset(widget.shadowOffset, widget.shadowOffset),
              ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

/// Barra de progresso brutalista (preenchimento chapado com borda).
class BrutalProgressBar extends StatelessWidget {
  final double value;

  const BrutalProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      decoration: BoxDecoration(
        color: BrutalColors.white,
        border: Border.all(color: BrutalColors.ink, width: 3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(color: BrutalColors.purple),
      ),
    );
  }
}
