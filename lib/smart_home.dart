import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot/providers/roomprovider.dart';
import 'package:iot/widgets/roomoverview.dart';
import 'package:provider/provider.dart';
import 'package:iot/providers/security.dart';
import 'dart:async';
import 'monitor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iot/model/rooms.dart';
import 'constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:slider_button/slider_button.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';
class SmartHome extends StatefulWidget {
  @override
  _SmartHomeState createState() => _SmartHomeState();
}

class _SmartHomeState extends State<SmartHome>
    with SingleTickerProviderStateMixin {


  String securityStatusText = kSecurityArmedStatusText;
  Color securityStatusColor = kPrimaryColor;
  double securityStatusBorderRadius = 3.0;
  Color securityStatusShadowColor = kDisarmedShadowColor;
  IconData securityIcon = Icons.lock_open;
  double deviceStatusHeight = 0;

  AnimationController controller;
  Animation<Offset> offset;

  Timer _timer;
  int _securityCountdown;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    offset = Tween<Offset>(begin: Offset(-5.0, 0.0), end: Offset(0.0, 0.0))
        .animate(controller);

    _securityCountdown = kSecurityTimeout;
  }

  void triggerSecurityTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_securityCountdown == 1) {
            timer.cancel();
            toggleAnimation('hide');
            enableSecurity();
            _securityCountdown = kSecurityTimeout;
          } else {
            _securityCountdown = _securityCountdown - 1;
          }
        },
      ),
    );
  }

  void enableSecurity() {
    setState(() {
      securityIcon = Icons.lock_outline;
      securityStatusColor = kAlertColor;
      securityStatusText = kSecurityArmedStatusText;
      securityStatusBorderRadius = 15.0;
      securityStatusShadowColor = kArmedShadowColor;
    });
    Provider.of<Security>(context).updateStatus(true);
    Provider.of<RoomProvider>(context).lockRooms();
  }

  void disableSecurity() {
    setState(() {
      securityIcon = Icons.lock_open;
      securityStatusText = kSecurityDisarmedStatusText;
      securityStatusColor = kPrimaryColor;
      securityStatusBorderRadius = 3.0;
      securityStatusShadowColor = kDisarmedShadowColor;
    });
    Provider.of<Security>(context).updateStatus(false);
    Provider.of<RoomProvider>(context).unlockRooms();
  }

  bool toggleAnimation(type) {
    var sec = Provider.of<Security>(context);
    if (type == 'show') {
      if (sec.getStatus() == true) {
        disableSecurity();
        return false;
      }
      if (controller.status == AnimationStatus.dismissed &&
          sec.getStatus() == false) {
        controller.forward();
        triggerSecurityTimer();
      }
    }

    if (controller.status == AnimationStatus.completed && type == 'hide') {
      disableSecurity();
      _timer.cancel();
      _securityCountdown = kSecurityTimeout;
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {

    final security = Provider.of<Security>(context);
    final roomProvider = Provider.of<RoomProvider>(context);
    List roomList = roomProvider.getRooms();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.forward();

          },
          child: Icon(FontAwesomeIcons.upload , color: Colors.white,),
          backgroundColor: Colors.redAccent,
        ),
      appBar: AppBar(
        centerTitle: true,
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: kMedTextSize,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Icon(Icons.menu),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Covid  ",
                  style: kAppBarStyle.copyWith(color: Colors.yellow),
                ),
                TextSpan(
                    text: "Slayer",
                    style: kAppBarStyle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal))
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Text("3"),
              SizedBox(
                width: 5.0,
              ),
              Icon(Icons.notifications),
            ],
          ),
          SizedBox(
            width: 15.0,
          )
        ],
      ),
      body: SingleChildScrollView(
      child:  Container(


        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Stack(

            children: <Widget>[
              Column(
                children: <Widget>[
                  Stack(

                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Container(
                              margin: EdgeInsets.only(left: 120.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Thanon Aphithanawat", style: Theme.of(context).textTheme.title,),
                                  Column( crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                                    Text("Robot Driver",style: TextStyle(fontSize: 16)),
                                    Text("Pilot Leader",style: TextStyle(fontSize: 13)),
                                  ],)

                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider('https://scontent.fbkk5-3.fna.fbcdn.net/v/t31.0-8/p960x960/892918_528340657204018_1234677692_o.jpg?_nc_cat=111&_nc_sid=7aed08&_nc_ohc=ybb0PH_XWuYAX_R6D1D&_nc_ht=scontent.fbkk5-3.fna&_nc_tp=6&oh=47854e5f6987353088a1ea18465b8fda&oe=5EAF7FAC'),
                                fit: BoxFit.cover
                            )
                        ),
                        margin: EdgeInsets.only(left: 16.0),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: AnimatedContainer(
                      padding: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                      ),
                      duration: Duration(milliseconds: 800),
                      curve: Curves.fastOutSlowIn,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: securityStatusShadowColor,
                            offset: Offset(
                              0.0,
                              2.5,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          )
                        ],
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.circular(securityStatusBorderRadius),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.idCard,
                            color: Colors.white,
                            size: kBigTextSize,
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          Text(
                            'Pilot  Information',
                            style: kNotificationBarTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(top: 16.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        Row(

          children: <Widget>[ Icon(FontAwesomeIcons.carBattery ,size: 25,) , SizedBox(width: 20,),Text('Battery',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)]),
                  SizedBox(height: 5.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 4.0,
                        percent: 0.10,
                        center: Text("10%"),
                        progressColor: Colors.red,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 4.0,
                        percent: 0.30,
                        center: Text("30%"),
                        progressColor: Colors.orange,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 4.0,
                        animation: true,
                        animationDuration: 200,
                        percent: 0.30,
                        center: Text("60%"),
                        progressColor: Colors.yellow,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 4.0,
                        percent: 0.90,
                        center: Text("90%"),
                        progressColor: Colors.green,
                      )
                    ],
                  ), Row( mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Text('  Engine 1'),SizedBox(width: 20,),Text('  Ozone 1'),SizedBox(width: 22,),Text('Engine 2'),SizedBox(width: 22,),Text('Ozone 2 ')],),
          ])),

                  SizedBox(height: 5.0,),
        ListView.builder(
                    itemCount: roomList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return Column(
                        children: <Widget>[

                        RoomOverview(
                          temperature: roomList[i]['temperature'],
                          power: roomList[i]['power'],
                          humidity: roomList[i]['humidity'],
                          roomName: roomList[i]['roomName'],
                          roomImg: roomList[i]['roomImg'],
                          lastActivity: roomList[i]['lastActivity'],
                          locked: roomList[i]['locked'],
                          opacity: roomList[i]['opacity'],
                          devices: roomList[i]['devices'],
                          roomIndex: i,
                        ),
                        i < rooms.length - 1 ? Divider() : SizedBox(),
                        ],
                      );
                    },
                  ),
                ],
              ),
              // Lockdown Timer
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1 - 15.0,
                ),
                child: SlideTransition(
                  position: offset,
                  child: Container(
                    margin: EdgeInsets.only(top: 30.0),
                    padding: EdgeInsets.only(
                      top: 35.0,
                      bottom: 35.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(
                            0.0,
                            2.5,
                          ),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'images/protection.svg',
                          color: kAlertColor,
                          width: 48.0,
                        ),
                        SizedBox(height: 15.0),
                        Text("Robot Control", style: kAlertTextStyle),
                        SizedBox(height: 15.0),
                        Text(
                          "Slide to Start ",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.grey,
                          ),
                        ),

                        SizedBox(height: 15.0),
                        Center(child: SliderButton(
                          width: 270,
                          action: () {
                            AutoOrientation.landscapeAutoMode();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Monitor_mode()),
                            );
                          },
                          vibrationFlag: false ,
                          label: Text(
                            "START OPERATION",
                            style: TextStyle(
                                color: Color(0xff4a4a4a), fontWeight: FontWeight.w500, fontSize: 17),
                          ),
                          icon: Text(
                            "x",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 44,
                            ),
                          ),


                        )),
                        SizedBox(height: 15.0),
                        OutlineButton(
                          onPressed: () {
                           controller.reverse();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text("Cancel"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ));
  }
}
