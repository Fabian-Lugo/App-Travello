import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travell_app/theme/app_colors.dart' show AppColors;

class AccountInfoStyle extends StatefulWidget {
  final String text;
  final String info;
  final String image;
  final String? image2;
  final String? image3;
  final bool? isDelicade;
  final bool secondIcon;

  const AccountInfoStyle({
    super.key,
    required this.text,
    required this.info,
    required this.image,
    this.image2,
    this.image3,
    this.isDelicade = false,
    this.secondIcon = false,
  });

  @override
  State<AccountInfoStyle> createState() => _AccountInfoStyleState();
}

class _AccountInfoStyleState extends State<AccountInfoStyle> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins(color: AppColors.black50, fontWeight: FontWeight.w500);
    final textStyleDelicade = GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w500);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.text,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.tertiary),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          decoration: widget.isDelicade == true
          ? BoxDecoration(
            color: AppColors.quaternary,
            border: Border.all(width: 0.5, color: AppColors.primary),
            borderRadius: BorderRadius.circular(15),
          )
          : BoxDecoration(
            color: AppColors.quaternary,
            border: Border.all(width: 0.5, color: AppColors.black50),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: widget.secondIcon && widget.image2 != null
                      ? Row(
                          children: [
                            Image.asset(widget.image, width: 25, color: AppColors.black50),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _obscureText ? '•' * widget.info.length : widget.info,
                                style: textStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _obscureText = !_obscureText),
                              child: Image.asset(
                                _obscureText ? widget.image2! : (widget.image3 ?? widget.image2!),
                                width: 25,
                                color: AppColors.black50,
                              ),
                            ),
                          ],
                        )
                      : Row(
                        children: [
                          Image.asset(
                            widget.image,
                            width: 25,
                            color: widget.isDelicade == true ? AppColors.primary : AppColors.black50,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.info,
                            style: widget.isDelicade == true ? textStyleDelicade : textStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}