import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    required this.image,
    required this.title,
    required this.text,
    Key? key,
  }) : super(key: key);

  final String image;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 20.0,
      ),
      content: SizedBox(
        height: 500,
        width: 1200,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                image,
              ),
              Column(
                children: [
                  Text(title),
                  Text(text),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
