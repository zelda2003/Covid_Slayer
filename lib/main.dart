import 'package:flutter/material.dart';
import 'package:iot/providers/roomprovider.dart';
import 'smart_home.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'package:iot/providers/security.dart';

void main() => runApp(AutoOrientationDemo());
class AutoOrientationDemo extends StatefulWidget {
  AutoOrientationDemo({this.title = 'Auto Orientation Demo'});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _AutoOrientationDemoState();
  }
}

class _AutoOrientationDemoState  extends State<AutoOrientationDemo>{
  static TargetPlatform _platform;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.teal[50],
        accentColor: Color(0xFF21D99A),
        textTheme: TextTheme(
          headline: TextStyle(
              fontSize: 12.0,
              color: kDarkTextColor,
              fontFamily: 'Product Sans'),
          title: TextStyle(
              fontSize: 24.0,
              color: kDarkTextColor,
              fontFamily: 'Product Sans'),
          body1: TextStyle(
              fontSize: 12.0,
              color: kDarkTextColor,
              fontFamily: 'Product Sans'),
        ),
      ).copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<Security>(
            builder: (_) => Security(false),
          ),
          ChangeNotifierProvider<RoomProvider>(
            builder: (_) => RoomProvider(),
          ),
        ],
        child: SmartHome(),
      ),
    );
  }
}
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}