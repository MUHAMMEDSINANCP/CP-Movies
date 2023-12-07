import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double height;
  final bool isLoading;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.height = 50.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: TColor.primaryG,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(9),
            boxShadow: TColor.tModeDark
                ? null
                : [
                    BoxShadow(
                        color: TColor.primary1.withOpacity(0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 4))
                  ]),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                height: 26,
                width: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.white,
                  backgroundColor: Colors.black,
                ),
              )
            : Text(
                title,
                style: TextStyle(
                    color: TColor.btnText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}
