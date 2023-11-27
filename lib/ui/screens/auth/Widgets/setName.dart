// ignore_for_file: file_names, must_be_immutable

import 'package:adsparo_test/ui/styles/colors.dart';
import 'package:flutter/material.dart';

import '../../../../utils/uiUtils.dart';
import '../../../../utils/validators.dart';
import 'fieldFocusChange.dart';


class SetName extends StatelessWidget {
  final FocusNode currFocus;
  final FocusNode nextFocus;
  final TextEditingController nameC;
  late String name;

  SetName({
    Key? key,
    required this.currFocus,
    required this.nextFocus,
    required this.nameC,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: TextFormField(
        focusNode: currFocus,
        textInputAction: TextInputAction.next,
        controller: nameC,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
        validator: (val) => Validators.nameValidation(val!, context),
       
        onFieldSubmitted: (v) {
          fieldFocusChange(context, currFocus, nextFocus);
        },
        decoration: InputDecoration(
          hintText: UiUtils.getTranslatedLabel(context, 'nameLbl'),
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
