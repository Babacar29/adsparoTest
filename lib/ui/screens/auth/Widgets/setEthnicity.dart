// ignore_for_file: file_names, must_be_immutable

import 'package:adsparo_test/ui/styles/colors.dart';
import 'package:adsparo_test/utils/uiUtils.dart';
import 'package:adsparo_test/utils/validators.dart';
import 'package:flutter/material.dart';

import 'fieldFocusChange.dart';

class SetEthnicity extends StatelessWidget {
  final FocusNode? currFocus;
  final FocusNode? nextFocus;
  final TextEditingController ethnicityC;
  late String ethnicity;
  final double topPad;

  SetEthnicity({
    Key? key,
    this.currFocus,
    this.nextFocus,
    required this.ethnicityC,
    required this.ethnicity,
    required this.topPad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPad),
      child: TextFormField(
        focusNode: currFocus,
        textInputAction: TextInputAction.next,
        controller: ethnicityC,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
        ),
        validator: (val) => Validators.ethnicityValidation(val!, context),
        onFieldSubmitted: (v) {
          if (currFocus != null || nextFocus != null) fieldFocusChange(context, currFocus!, nextFocus!);
        },
        decoration: InputDecoration(
          hintText: UiUtils.getTranslatedLabel(context, 'ethnicityLbl'),
          hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
          filled: true,
          fillColor: adsBlueColor.withOpacity(0.6),
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: UiUtils.getColorScheme(context).outline.withOpacity(0.7)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
