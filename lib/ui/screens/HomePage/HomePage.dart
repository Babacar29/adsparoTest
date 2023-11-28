// ignore_for_file: file_names
import 'package:adsparo_test/data/models/UserModel.dart';
import 'package:adsparo_test/ui/screens/EditUser/editUser.dart';
import 'package:adsparo_test/ui/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cubits/Auth/authCubit.dart';
import '../../../cubits/getAllUsersDataCubit.dart';
import '../../widgets/SnackBarWidget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.userModel, required this.users}) : super(key: key);
  final UserModel userModel;
  final List<UserModel> users;

  @override
  HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {
/*void getUserData() {
    Future.delayed(Duration.zero, () {
      context.read<GetAllUsersCubit>().getUserById(context: context, userId: context.read<AuthCubit>().getUserId());
    });
  }
*/

  @override
  void initState() {
    if (context.read<AuthCubit>().getUserId() != "0") {
     // getUserData();
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, _) => SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Home", style: TextStyle(color: adsBlueColor, fontSize: 20.sp),),
              backgroundColor: Colors.white,
              elevation: 2,
              iconTheme: const IconThemeData(color: adsBlueColor),
            ),
            drawer: Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${widget.userModel.name}", style: TextStyle(fontSize: 30.sp, color: adsBlueColor),),
                    ],
                  ),
                  SizedBox(height: 50.h,),
                  Divider(color: adsBlueColor, indent: 20.w, height: 15.h,),
                   Padding(
                     padding: EdgeInsets.only(left: 20.w),
                     child: Align(
                       alignment: Alignment.centerLeft,
                       child: GestureDetector(
                         onTap: (){
                           Navigator.of(context).push(
                               MaterialPageRoute(builder: (context) => EditUserScreen(user: widget.userModel))
                           );
                         },
                         child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, color: adsBlueColor,),
                            SizedBox(width: 20.w,),
                            Text("Edit profile", style: TextStyle(color: adsBlueColor),),
                          ],
                  ),
                       ),
                     ),
                   ),
                   Divider(color: adsBlueColor, indent: 20.w, height: 20.h,),
                   Align(
                     alignment: Alignment.centerLeft,
                     child: Padding(
                       padding: EdgeInsets.only(left: 20.w),
                       child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.login_outlined, color: adsBlueColor,),
                          SizedBox(width: 20.w,),
                          Text("Logout", style: TextStyle(color: adsBlueColor),),
                        ],
                  ),
                     ),
                   ),
                  Divider(color: adsBlueColor, indent: 20.w, height: 20.h,),
                ],
              ),
            ),
            body: BlocListener<GetAllUsersCubit, GetAllUsersState>(
              bloc: context.read<GetAllUsersCubit>(),
              listener: (context, state) {
                if (state is GetAllUsersFetchFailure) {
                  showSnackBar(state.errorMessage, context);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: widget.users.toSet().length,
                    itemBuilder: (context, index){
                      UserModel user = widget.users[index];
                      return displayUser(
                          "${user.name}",
                          "${user.address}, ${user.zipCode} ${user.country}",
                          () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => EditUserScreen(user: user))
                            );
                          }
                      );
                    }
                ),
              )
            )),
      ),
    );
  }

  Widget displayUser(String displayName, address, Function navigate){
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: adsBlueColor)
        ),
        color: Colors.white,
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('\u{1f468}', style: TextStyle(fontSize: 25.sp),),
              VerticalDivider(color: adsBlueColor, thickness: 1.w,)
            ],
          ),
          title: Text(displayName, style: TextStyle(color: adsBlueColor),),
          subtitle: Text(address, style: TextStyle(color: adsBlueColor),),
          trailing: IconButton(
              onPressed: () {
                navigate();
              },
              icon: Icon(Icons.edit, color: adsBlueColor, size: 18.sp,)
          ),
        ),
      ),
    );
  }
}
