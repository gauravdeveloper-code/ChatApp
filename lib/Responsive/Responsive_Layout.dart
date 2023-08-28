import 'package:flutter/cupertino.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreen;
  final Widget webScreen;

  const ResponsiveLayout(
      {Key? key, required this.mobileScreen, required this.webScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 900) {
        return mobileScreen;
      }
      return webScreen;
    });
  }
}
