import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:travell_app/router/app_routes.dart';
import 'package:travell_app/theme/app_colors.dart';

class RedirectTextButton extends StatelessWidget {
  final String text;
  final String textLink;
  final bool isReturn;

  const RedirectTextButton({
    super.key,
    required this.text,
    required this.textLink,
    this.isReturn = false,
  });

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.tertiary)
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => isReturn ? context.pop() : context.push(AppRoutes.register),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(textLink,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary)
            ),
          ),
        ),
      ],
    );
  }
}