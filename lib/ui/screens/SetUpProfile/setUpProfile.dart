import 'package:adsparo_test/ui/screens/auth/Widgets/setAddress.dart';
import 'package:adsparo_test/ui/screens/auth/Widgets/setEthnicity.dart';
import 'package:adsparo_test/ui/screens/auth/Widgets/setUpCountry.dart';
import 'package:adsparo_test/ui/screens/auth/Widgets/setZipCode.dart';
import 'package:adsparo_test/ui/widgets/button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:im_stepper/stepper.dart';

import '../../../utils/uiUtils.dart';
import '../../../utils/validators.dart';
import '../../styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/customTextLabel.dart';
import '../auth/Widgets/setAge.dart';
import '../auth/Widgets/setLoginAndSignUpBtn.dart';

class SetUpProfile extends StatefulWidget {
  const SetUpProfile({Key? key}) : super(key: key);

  @override
  SetUpProfileState createState() => SetUpProfileState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const SetUpProfile(),
    );
  }
}

class SetUpProfileState extends State<SetUpProfile> {
  int activeStep = 0; // Initial step set to 5.
  TextEditingController? phoneC, addressC, zipC, ethnicityC, countryC, ageC;
  FocusNode phoneFocus = FocusNode();
  FocusNode emailSFocus = FocusNode();
  FocusNode addressSFocus = FocusNode();
  FocusNode ethnicitySFocus = FocusNode();
  FocusNode ageSFocus = FocusNode();
  FocusNode zipSFocus = FocusNode();
  FocusNode countrySFocus = FocusNode();
  String countryDefault = "SN";
  String indicator = "+221";
  String num = "";
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget hintTxt() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 40.0, start: 10.0),
          child: CustomTextLabel(
            text: 'profileSetUpDescr',
            textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(color: adsBlueColor, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            textAlign: TextAlign.left,
          ),
        ));
  }

  assignAllTextController() {
    phoneC = TextEditingController();
    addressC = TextEditingController();
    zipC = TextEditingController();
    ethnicityC = TextEditingController();
    countryC = TextEditingController();
    ageC = TextEditingController();
  }

  Widget showContent(){
    return  stepper();
  }

  Widget stepper(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 30.h,),
          Row(
            children: [
              IconButton(
                  onPressed: null,
                  icon: Icon(Icons.arrow_back_ios, color: adsBlueColor, size: 20.sp,)
              ),
            ],
          ),
          hintTxt(),
          SizedBox(height: 40.h,),
          Center(
            child: NumberStepper(
              numbers: const [
                1, 2
              ],
              activeStepBorderColor: adsBlueColor,
              lineColor: adsBlueColor,
              lineLength: ScreenUtil().screenWidth/1.7,
              // activeStep property set to activeStep variable defined above.
              activeStep: activeStep,
              activeStepColor: adsIntermColor,
              activeStepBorderPadding: 3,
              steppingEnabled: false,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              numberStyle: const TextStyle(
                color: Colors.white
              ),
              // This ensures step-tapping updates the activeStep.
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
          ),
          //SetEmail(currFocus: emailSFocus, emailC: sEmailC!, email: sEmailC!.text, topPad: 20),

          Center(
            child: activeStep == 0 ? showFirstStep() : showSecondStep(),
          ),
        ],
      ),
    );
  }

  //check validation of form data
  bool validateAndSave() {
    final form = _formkey.currentState;
    form!.save();
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  Widget showFirstStep(){
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            SizedBox(height: 10.h,),
            TextFormField(
              focusNode: phoneFocus,
              textInputAction: TextInputAction.next,
              controller: phoneC,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
              validator: (val) => Validators.phoneValidation(val!, context),
              onFieldSubmitted: (v) {
                //if (phoneFocus != null || nextFocus != null) fieldFocusChange(context, phoneFocus!, nextFocus!);
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: UiUtils.getTranslatedLabel(context, 'phoneLbl'),
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
                prefixIcon: CountryCodePicker(
                  showCountryOnly: false,
                  initialSelection: countryDefault,
                  favorite: const ["+221", "SN"],
                  showOnlyCountryWhenClosed: false,
                  showDropDownButton: true,
                  showFlagMain: true,
                  padding: const EdgeInsets.all(0),
                  flagWidth: 30,
                  textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black
                  ),
                  onChanged: (country) {
                    setState(() {
                      indicator = country.dialCode!;
                      num = "$indicator${phoneC?.text}";
                      //print(_num);
                    });
                  },
                ),
              ),
            ),
            SetAddress(currFocus: addressSFocus, nextFocus: zipSFocus, addC: addressC!, address: addressC!.text, topPad: 30),
            SetZipCode(currFocus: zipSFocus, nextFocus: null, zipC: zipC!, zipCode: zipC!.text, topPad: 30),
            SetLoginAndSignUpBtn(
                onTap: () async {
                  FocusScope.of(context).unfocus(); //dismiss keyboard
                  if (validateAndSave()) {
                    setState(() {
                      activeStep++;
                    });
                  }
                },
                text: 'nxt',
                topPad: 20
            ),
          ],
        ),
      ),
    );
  }

  Widget showSecondStep(){
    return Padding(
      padding: EdgeInsets.all(3.h),
      child: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              SetEthnicity(currFocus: ethnicitySFocus, ethnicityC: ethnicityC!, ethnicity: ethnicityC!.text, topPad: 10),
              SetCountry(currFocus: countrySFocus, countryC: countryC!, country: countryC!.text, topPad: 30),
              SetAge(currFocus: ageSFocus, ageC: ageC!, age: ageC!.text, topPad: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Btn(
                      onTap: (){
                        setState(() {
                          activeStep--;
                        });
                      },
                      text: "previous",
                      topPad: 20,
                      width: ScreenUtil().screenWidth/2.6
                  ),
                  Btn(
                      onTap: (){
                        if (validateAndSave()) {

                        }
                      },
                      text: "submitBtn",
                      topPad: 20,
                      width: ScreenUtil().screenWidth/2.6
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    assignAllTextController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, _){
        return Scaffold(
          body: showContent(),
        );
      },
    );
  }
}
