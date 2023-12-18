import 'package:flutter/material.dart';

import '../utils/colors.dart';
class ShowLinearIndicator extends StatelessWidget {
  const ShowLinearIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(child: const LinearProgressIndicator(color: blueColor,backgroundColor: secondaryColor,)),
    );
  }
}
