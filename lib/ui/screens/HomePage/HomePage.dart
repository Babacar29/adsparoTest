// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/Auth/authCubit.dart';
import '../../../cubits/getUserDataByIdCubit.dart';
import '../../../data/models/AuthModel.dart';
import '../../../utils/strings.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/SnackBarWidget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const HomeScreen(),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  void getUserData() {
    Future.delayed(Duration.zero, () {
      context.read<GetUserByIdCubit>().getUserById(context: context, userId: context.read<AuthCubit>().getUserId());
    });
  }


  @override
  void initState() {
    if (context.read<AuthCubit>().getUserId() != "0") {
      getUserData();
    }
    super.initState();
  }

  //refresh function to refresh page
  Future<void> _refresh() async {
    if (context.read<AuthCubit>().getUserId() != "0") {
      getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () => _refresh(),
              child: BlocListener<GetUserByIdCubit, GetUserByIdState>(
                bloc: context.read<GetUserByIdCubit>(),
                listener: (context, state) {
                  if (state is GetUserByIdFetchSuccess) {
                    var data = (state).result;
                    //check if user is Active or not?!
                    if (data[0][STATUS] == "0") {
                      //show snackbar,logout and redirect to login screen
                      showSnackBar(UiUtils.getTranslatedLabel(context, 'deactiveMsg'), context);
                      Future.delayed(const Duration(seconds: 2), () {
                        UiUtils.userLogOut(contxt: context);
                      });
                    } else {
                      context.read<AuthCubit>().updateDetails(
                          authModel: AuthModel(
                              id: data[0][ID],
                              name: data[0][NAME],
                              status: data[0][STATUS],
                              mobile: data[0][MOBILE],
                              email: data[0][EMAIL],
                              type: data[0][TYPE],
                              profile: data[0][PROFILE],
                              role: data[0][ROLE]));
                    }
                  }
                },
                child: ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsetsDirectional.only(start: 15.0, end: 15.0, bottom: 10.0),
                    children: const [
                      //getSectionList()
                    ]
                ),
              ))),
    );
  }
}
