// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../utils/uiUtils.dart';
import '../styles/colors.dart';
import '../widgets/customTextBtn.dart';
import '../widgets/customTextLabel.dart';

//slide class
class Slide {
  final String? imageUrl;
  final String? title;
  final String? description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  GettingStartedScreenState createState() => GettingStartedScreenState();
}

class GettingStartedScreenState extends State<IntroSliderScreen> with TickerProviderStateMixin {
  PageController pageController = PageController();

  double count = 0.00;
  int currentIndex = 0;

  late List<Slide> slideList = [
    Slide(imageUrl: UiUtils.getImagePath('man-laptop-awareness.png'), title: UiUtils.getTranslatedLabel(context, 'welTitle1'), description: UiUtils.getTranslatedLabel(context, 'welDes1'), ),
    Slide(imageUrl: UiUtils.getImagePath('engagement-man.png'), title: UiUtils.getTranslatedLabel(context, 'welTitle2'), description: UiUtils.getTranslatedLabel(context, 'welDes2')),
    Slide(imageUrl: UiUtils.getImagePath('conversion-woman.png'), title: UiUtils.getTranslatedLabel(context, 'welTitle3'), description: UiUtils.getTranslatedLabel(context, 'welDes3')),
    Slide(imageUrl: UiUtils.getImagePath('woman-conversion.png'), title: UiUtils.getTranslatedLabel(context, 'welTitle4'), description: UiUtils.getTranslatedLabel(context, 'welDes4')),
    Slide(imageUrl: UiUtils.getImagePath('lead-gen.png'), title: UiUtils.getTranslatedLabel(context, 'welTitle5'), description: UiUtils.getTranslatedLabel(context, 'welDes5')),
  ];

  @override
  void initState() {
    super.initState();
    onPageChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(), body: Padding(padding: const EdgeInsets.only(top: 5.0), child: _buildIntroSlider()));
  }

  gotoNext() {
    Navigator.of(context).pushReplacementNamed(Routes.login);
  }

  void onPageChanged(int index) {
    setState(() {
      switch (index) {
        case 0:
          count = 0.2;
          break;
        case 1:
          count = 0.4;
          break;
        case 2:
          count = 0.6;
        case 3:
          count = 0.8;
        case 4:
          count = 1.0;
          break;
        default:
          count = 0.0;
          break;
      }
    });
  }

  Widget _buildIntroSlider() {
    Color gradientStart = Colors.transparent;
    Color gradientEnd = adsBlueColor.withOpacity(0.85);
    return PageView.builder(
        onPageChanged: onPageChanged,
        controller: pageController,
        itemBuilder: (context, index) {
          currentIndex = index;
          return Stack(children: [
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
              elevation: 5,
              margin: const EdgeInsets.all(15),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [gradientStart, gradientEnd],
                  ).createShader(Rect.fromLTRB(0, -140, rect.width, rect.height - 20));
                },
                blendMode: BlendMode.darken,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(image: AssetImage(slideList[index].imageUrl!), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  //blank container
                  flex: 1,
                  //blank container
                  child: Container(
                      // blank container along with flex:1 to make space from top / before content
                      ),
                ),
                Expanded(flex: 0, child: titleText(index)),
                Expanded(flex: 0, child: subtitleText(index)),
                Expanded(flex: 0, child: progressIndicator()),
                const SizedBox(height: 20),
                Expanded(
                    flex: 0,
                    child: Container(
                        //Next / Login button
                        margin: const EdgeInsets.only(bottom: 40.0),
                        child: ButtonTheme(child: nextButton(index))))
              ],
            ),
          ]);
        },
        itemCount: slideList.length);
  }

  appbar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 80),
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: MediaQuery.of(context).padding.top, start: 20, end: 16),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [SizedBox(height: 48, width: 100, child: Image.asset(UiUtils.getImagePath("adsparolab_logo.png"), fit: BoxFit.contain)), setSkipButton()]),
      ),
    );
  }

  Widget setSkipButton() {
    return (currentIndex != slideList.length - 1)
        ? CustomTextButton(
            onTap: () {
              gotoNext();
            },
            color: adsBlueColor.withOpacity(0.7),
            text: UiUtils.getTranslatedLabel(context, 'skip'))
        : const SizedBox.shrink();
  }

  Widget titleText(int index) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 10),
      margin: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
      alignment: Alignment.centerLeft,
      child: Text(slideList[index].title!, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: backgroundColor, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    );
  }

  Widget subtitleText(int index) {
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 10),
        margin: const EdgeInsets.only(bottom: 55.0, left: 10, right: 10),
        child: Text(slideList[index].description!,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: adsRoseColor, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis));
  }

  Widget progressIndicator() {
    return SizedBox(height: 3, width: 118, child: LinearProgressIndicator(backgroundColor: backgroundColor, value: count, valueColor: const AlwaysStoppedAnimation<Color>(adsBlueColor)));
  }

  Widget nextButton(int index) {
    return MaterialButton(
        onPressed: () {
          if (index == slideList.length - 1 && index != 0) {
            gotoNext();
          } else {
            //GoTo Next Slide
            index += 1;
            pageController.animateToPage(index, duration: const Duration(seconds: 1), curve: Curves.fastLinearToSlowEaseIn);
          }
        },
        child: Container(
            height: 50,
            width: 162,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: adsBlueColor, borderRadius: BorderRadius.circular(10)),
            child: CustomTextLabel(
                text: (index == (slideList.length - 1)) ? 'loginBtn' : 'nxt',
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: secondaryColor, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center)));
  }
}
