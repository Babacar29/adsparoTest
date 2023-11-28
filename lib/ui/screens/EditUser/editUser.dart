import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cubits/getAllUsersDataCubit.dart';
import '../../../data/models/UserModel.dart';
import '../../../utils/uiUtils.dart';
import '../../../utils/validators.dart';
import '../../styles/colors.dart';
import '../../widgets/button.dart';
import '../auth/Widgets/setAddress.dart';
import '../auth/Widgets/setAge.dart';
import '../auth/Widgets/setEmail.dart';
import '../auth/Widgets/setEthnicity.dart';
import '../auth/Widgets/setName.dart';
import '../auth/Widgets/setUpCountry.dart';
import '../auth/Widgets/setZipCode.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController? phoneC = TextEditingController();
  TextEditingController? addressC = TextEditingController();
  TextEditingController? zipC = TextEditingController();
  TextEditingController? ethnicityC = TextEditingController();
  TextEditingController? countryC = TextEditingController();
  TextEditingController? ageC = TextEditingController();
  TextEditingController? sNameC = TextEditingController();
  TextEditingController? sEmailC = TextEditingController();
  FocusNode phoneFocus = FocusNode();
  FocusNode emailSFocus = FocusNode();
  FocusNode addressSFocus = FocusNode();
  FocusNode ethnicitySFocus = FocusNode();
  FocusNode ageSFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode zipSFocus = FocusNode();
  FocusNode countrySFocus = FocusNode();
  String countryDefault = "SN";
  String indicator = "+221";
  String num = "";

  assignAllTextController({required String name, email, country, age, phone, zip, address, ethnicity}) {
    phoneC?.text = phone;
    addressC?.text = address;
    zipC?.text = zip;
    ethnicityC?.text = ethnicity;
    countryC?.text = country;
    ageC?.text = age;
    sNameC?.text = name;
    sEmailC?.text = email;
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

  Widget showContent(){
    return Form(
      key: _formkey,
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            children: [
              SetName(currFocus: nameFocus, nextFocus: emailSFocus, nameC: sNameC!, name: sNameC!.text),
              SetEmail(currFocus: emailSFocus, nextFocus: phoneFocus, emailC: sEmailC!, email: sEmailC!.text, topPad: 20),
              const SizedBox(height: 30,),
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
              SetEthnicity(currFocus: ethnicitySFocus, ethnicityC: ethnicityC!, ethnicity: ethnicityC!.text, topPad: 10),
              SetCountry(currFocus: countrySFocus, countryC: countryC!, country: countryC!.text, topPad: 30),
              SetAge(currFocus: ageSFocus, ageC: ageC!, age: ageC!.text, topPad: 30),
              Btn(
                  onTap: ()async{
                    setState(() {
                      num = "$indicator${phoneC?.text}";
                    });
                    if (validateAndSave()) {
                      var user = {
                        'phoneNumber': num,
                        'address': addressC?.text,
                        'zipCode': zipC?.text,
                        'age': ageC?.text,
                        'ethnicity': ethnicityC?.text,
                        'country': countryC?.text,
                        "name": sNameC?.text,
                        "email": sEmailC?.text
                      };
                      updateUserInFirebase(widget.user.uid, user, context);
                    }
                  },
                  text: "submitBtn",
                  topPad: 20,
                  width: ScreenUtil().screenWidth
              ),
            ],
          ),
        )
    );
  }

  Future<void> updateUserInFirebase(String? uid, var user, BuildContext context) async{
    try {
      final db = FirebaseDatabase.instance.ref();
      db.child("users/$uid").update(user).then((_){
        context.read<GetAllUsersCubit>().getUsers(context: context);
      });
    }
    catch(e){
      debugPrint("exception =======> $e");
    }
  }

  @override
  void initState() {
    assignAllTextController(
        name: widget.user.name!,
        email: widget.user.email!,
        phone: widget.user.phoneNumber!,
        country: widget.user.country!,
        address: widget.user.address!,
        ethnicity: widget.user.ethnicity!,
        age: widget.user.age!,
        zip: widget.user.zipCode!
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text("Edit User", style: TextStyle(color: adsBlueColor, fontSize: 20.sp),),
          backgroundColor: Colors.white,
          elevation: 2,
          iconTheme: const IconThemeData(color: adsBlueColor),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: showContent(),
        ),
      ),
    );
  }
}
