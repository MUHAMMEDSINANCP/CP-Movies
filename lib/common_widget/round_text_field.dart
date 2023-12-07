import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String title;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? left;
  final Widget? right;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const RoundTextField({
    super.key,
    required this.title,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.left,
    this.right,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: TColor.text, fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
            color: TColor.card,
            borderRadius: BorderRadius.circular(9),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))
            ],
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  left ?? const SizedBox(),
                  Expanded(
                    child: TextFormField(
                      validator: validator,
                      style: TextStyle(
                          color: TColor.tModeDark
                              ? TColor.primary1
                              : TColor.primary2),
                      controller: controller,
                      autocorrect: false,
                      obscureText: obscureText,
                      cursorColor:
                          TColor.tModeDark ? TColor.primary1 : TColor.primary2,
                      obscuringCharacter: "*",
                      keyboardType: keyboardType,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(
                            color: TColor.subtext,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  right ?? const SizedBox()
                ],
              ),
              if (suffixIcon != null)
                Positioned(
                  right: 78, // Adjust this value as needed
                  child: suffixIcon!,
                ),
            ],
          ),
        )
      ],
    );
  }
}
