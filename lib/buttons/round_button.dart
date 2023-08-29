import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const RoundButton({Key? key, required this.title, required this.onTap,this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13), color: Colors.blue),
          child: Center(
            child: loading ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,):Text(
              title,
            ),
          ),
        ));
  }
}
