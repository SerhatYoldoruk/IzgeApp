import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final IconData? prefixIcon;
  final String? errorText;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.prefixIcon,
    this.errorText,
    this.autofillHints,
    this.keyboardType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    
    Color borderColor = Colors.black;
    if (hasError) {
      borderColor = const Color(0xFFE57373); // Colors.red.shade400
    } else if (_isFocused) {
      borderColor = AppColors.accent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: _isFocused || hasError ? 2 : 1),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.fieldBackground,
          ),
          width: double.infinity,
          child: TextField(
            focusNode: _focusNode,
            obscureText: _obscureText,
            autofillHints: widget.autofillHints,
            keyboardType: widget.keyboardType,
            style: TextStyle(
              color: AppColors.fieldText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: AppColors.fieldHint,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: AppColors.fieldHint) : null,
              suffixIcon: widget.obscureText 
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.fieldHint,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.all(17),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Color(0xFFE57373), fontSize: 12),
            ),
          ),
      ],
    );
  }
}
