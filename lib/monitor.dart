import 'package:flutter/material.dart';
import 'joystick_view.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:speedometer/speedometer.dart';
import 'dart:async';
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_dialog/easy_dialog.dart';

import 'constants.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'activate.dart';

class Monitor_mode extends StatefulWidget{

  @override
  Monitor_state createState() => Monitor_state();
}


class Monitor_state extends State<Monitor_mode>    with TickerProviderStateMixin {
  String securityStatusText = kSecurityArmedStatusText;
  Color securityStatusColor = kPrimaryColor;
  double securityStatusBorderRadius = 3.0;
  Color securityStatusShadowColor = kDisarmedShadowColor;
  IconData securityIcon = Icons.lock_open;
  double deviceStatusHeight = 0;
  int _securityCountdown;
  AnimationController controller;
  Animation<Offset> offset;
  AnimationController controller2;
  Animation<Offset> offset2;
  static StreamController<double> controller1 = StreamController<double>();
  double _lowerValue = 20.0;
  double _upperValue = 40.0;
  int start = 0;
  int end = 60;
  Color color1 ;
  Color color2 ;
  Color color3 ;
  Color color4 ;
  Color color5 ;
  Color color6 ;
  Color color7 ;
  Color color8 ;
 static PublishSubject<double> eventObservable = new PublishSubject();
  int counter = 0;
  static int data_speed ;
  var speed_now ;
  Timer timer;
  static bool stoping = false;

  @override

  void initState() {super.initState();
  setState(() {
    color1 = Colors.blue;
    color2 = Colors.blue;
    color3 = Colors.grey;
    color4 = Colors.grey;
    color5 = Colors.white;
    color6 = Colors.grey;
    color7 = Colors.white;
    color8 = Colors.grey;
  });

  controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  offset = Tween<Offset>(begin: Offset(-5.0, 0.0), end: Offset(0.0, 0.0))
      .animate(controller);
  controller2 =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  offset2 = Tween<Offset>(begin: Offset(-5.0, 0.0), end: Offset(0.0, 0.0))
      .animate(controller2);
  _securityCountdown = kSecurityTimeout;

  }
  void dispose() {

    controller1.close();
    super.dispose();
  }

  static  void speed_update(data) {
    print('new     load');
   if(data == true){
    var rng = new Random();
    eventObservable.add(30+rng.nextDouble());
    Timer(Duration(seconds: 1), () {
      eventObservable.add(45+rng.nextDouble());
    });
    Timer(Duration(seconds: 2), () {
      eventObservable.add(60+rng.nextDouble());
    });

   } else{
     var rng = new Random();
     eventObservable.add(30+rng.nextDouble());
     Timer(Duration(seconds: 1), () {
       eventObservable.add(15+rng.nextDouble());
     });
     Timer(Duration(seconds: 2), () {
       eventObservable.add(0+rng.nextDouble());
     });

   }
  }
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  void triggerSecurityTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_securityCountdown == 1) {
            timer.cancel();

            _securityCountdown = kSecurityTimeout;

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CountDownTimer()),
              );
          } else {
            _securityCountdown = _securityCountdown - 1;
          }
        },
      ),
    );
  }
  Widget build(BuildContext context){
    final primaryColor = Theme.of(context).primaryColor;
    final ThemeData somTheme = new ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.black,
        backgroundColor: Colors.grey
    );
    return Scaffold(
        floatingActionButton: Builder(
          builder: (context) => FabCircularMenu(
            key: fabKey,
            // Cannot be `Alignment.center`
            alignment: Alignment.topLeft,
            ringColor: Colors.white.withAlpha(25),
            ringDiameter: 500.0,
            ringWidth: 150.0,
            fabSize: 64.0,
            fabElevation: 8.0,

            // Also can use specific color based on wether
            // the menu is open or not:
            // fabOpenColor: Colors.white
            // fabCloseColor: Colors.white
            // These properties take precedence over fabColor
            fabColor: Colors.white,
            fabOpenIcon: Icon(FontAwesomeIcons.tools, color: primaryColor),
            fabCloseIcon: Icon(Icons.close, color: primaryColor),
            fabMargin: const EdgeInsets.all(16.0),
            animationDuration: const Duration(milliseconds: 800),
            animationCurve: Curves.easeInOutCirc,

            children: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  confirm_clean('Activate Ozone Cleaning?', 'Are you sure to start ozone air cleaning?',
                      DialogType.INFO , 'cloud'  );
                  fabKey.currentState.close();
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Icon(FontAwesomeIcons.cloudversify, color: Colors.white),
              ),
              RawMaterialButton(
                onPressed: () {
                  confirm_clean('Start Washing?', 'Are you sure to start Washing?',
                      DialogType.INFO , 'wash'  );
                  fabKey.currentState.close();
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Icon(FontAwesomeIcons.recycle, color: Colors.white),
              ),
              RawMaterialButton(
                onPressed: () {
                  showdone();
                  fabKey.currentState.close();
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Icon(FontAwesomeIcons.mapMarkedAlt, color: Colors.white),
              ),
              RawMaterialButton(
                onPressed: () {
                  controller2.forward();
                  fabKey.currentState.close();
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Icon(FontAwesomeIcons.carBattery, color: Colors.white),
              ),
              RawMaterialButton(
                onPressed: () {
                  confirm_clean('Save Waypoint?', 'Are you sure to reccord this waypoint?',
                    DialogType.INFO , 'waypoint'  );
                  fabKey.currentState.close();
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Icon(FontAwesomeIcons.shareSquare, color: Colors.white),
              )
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/interface.jpg"), fit: BoxFit.cover),
          ),
          child: Stack(

            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top:30 , left: 90),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[


                      Icon(FontAwesomeIcons.signal,  size: 20,  color: Colors.white),
SizedBox(height: 5,),
                      Text("Good" , style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.white,),),

                           ],
                  )),
          Container(
          margin: const EdgeInsets.only(top:20 , left: 570),
          child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Ozone1" , style: TextStyle(fontWeight: FontWeight.bold,  color: color5,),),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(FontAwesomeIcons.batteryThreeQuarters, color: color5),
                  SizedBox(
                    width: 10,
                  ),

                  Text("74%" , style: TextStyle(fontWeight: FontWeight.bold,  color: color5,),)
                ],
              )),
              Container(
                  margin: const EdgeInsets.only(top:65 , left: 570),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Ozone2" , style: TextStyle(fontWeight: FontWeight.bold,  color: color6,),),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(FontAwesomeIcons.batteryFull, color: color6),
                      SizedBox(
                        width: 10,
                      ),

                      Text("100%" , style: TextStyle(fontWeight: FontWeight.bold,  color: color6,),)
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top:24 , left: 270),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Distance : " , style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.white,),),
                      SizedBox(
                        width: 5,
                      ),


                      Text("84.5 m." , style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.white,),)
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top:85 , left: 570),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Engine2" , style: TextStyle(fontWeight: FontWeight.bold,  color: color8,),),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(FontAwesomeIcons.batteryFull, color: color8),
                      SizedBox(
                        width: 10,
                      ),

                      Text("100%" , style: TextStyle(fontWeight: FontWeight.bold,  color: color8,),)
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top:42 , left: 570),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Engine1" , style: TextStyle(fontWeight: FontWeight.bold,  color: color7,),),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(FontAwesomeIcons.batteryHalf, color: color7),
                      SizedBox(
                        width: 10,
                      ),

                      Text("52%" , style: TextStyle(fontWeight: FontWeight.bold,  color: color7,),)
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top:270 , left: 540),
          child:   Row( children: <Widget>[
            JoystickView()
          ])),
              Container(
                  margin: const EdgeInsets.only(top:290 , left: 35),    width: 120,
      child:
      SpeedOMeter(start:0, end:60, highlightStart:(_lowerValue/end), highlightEnd:(_upperValue/end), themeData:somTheme, eventObservable: eventObservable)),

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
                        Icon(FontAwesomeIcons.biohazard,size: 60, color: Colors.red),
                        SizedBox(height: 10.0),
                        Text("Ozone Generation Starting", style: kAlertTextStyle),
                        SizedBox(height: 10.0),
                        Text(
                          "Danger !! Leave from processing area ",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "System Activating in...",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          _securityCountdown.toString(),
                          style: kBigTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 42.0,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        Text(
                          "Seconds",
                          style: kActivityInfoTextStyle,
                        ),
                        SizedBox(height: 15.0),
                        OutlineButton(
                          onPressed: () {
                            timer.cancel();
                            _securityCountdown = kSecurityTimeout;
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

              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.3 - 15.0,
                ),
                child: SlideTransition(
                  position: offset2,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Battery Swaping', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,  color: Colors.green,)) ,
                        SizedBox(height: 10,),
                        Text('Ozone ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,  color: Colors.black,)) ,
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[ RaisedButton(child: Text('Battery 1') ,onPressed: () {
                          setState(() {
                            color1 = Colors.blue;
                            color3 = Colors.grey;
                            color5 = Colors.white;
                            color6 = Colors.grey;
                          });
                        }, color: color1,),SizedBox(width: 30,),RaisedButton(child: Text('Battery 2') ,onPressed: () {
                          setState(() {
                            color1 = Colors.grey;
                            color3 = Colors.blue;
                            color5 = Colors.grey;
                            color6 = Colors.white;
                          });
                        }, color: color3,)],),
                        Text('Engine', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,  color: Colors.black,)) ,
                        Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[RaisedButton(child: Text('Battery 1') ,onPressed: () {
                          setState(() {
                            color2 = Colors.blue;
                            color4 = Colors.grey;
                            color7 = Colors.white;
                            color8 = Colors.grey;
                          });
                        }, color: color2,),SizedBox(width: 30,),RaisedButton(child: Text('Battery 2') ,onPressed: () {
                          setState(() {
                            color2 = Colors.grey;
                            color4 = Colors.blue;
                            color7 = Colors.grey;
                            color8 = Colors.white;
                          });
                        }, color: color4,)],),
                        SizedBox(height: 30,),
                        OutlineButton(
                          onPressed: () {

                            controller2.reverse();
                          },

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text("Close"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],)
        )
    );
  }
  void confirm_clean(String title, String msg,
      DialogType dialogType , type) {
    AwesomeDialog(
        context: context,
        animType: AnimType.TOPSLIDE,
        dialogType: dialogType,
        tittle: title,
        desc: msg,
        btnOkText: 'Confirm',
        btnCancelOnPress: () {},
        btnOkColor: Colors.blueAccent,
        btnOkOnPress: () {
          if(type == 'cloud'){
            controller.forward();
            triggerSecurityTimer();
          }else{
          completed(type);}
         }).show();

  }
  void completed( type) {
    String title;
    String msg;
    var dialog;
    if(type == 'waypoint'){
      title =  'Success Update';
      msg =  'New waypiont has been record.';
      dialog = DialogType.SUCCES;
    }else if(type == 'wash'){
      title =  'Washing system starting';
      msg =  'The Washing system will finish in 10 minute';
      dialog = DialogType.INFO;
    }else if(type == 'cloud'){
      title =  'Ozone cleaning has activate';
      msg =  'Danger, Please leave this area ozone air cleaning will finish in 30 minute.';
      dialog = DialogType.WARNING;
    }
    AwesomeDialog(
        context: context,
        animType: AnimType.TOPSLIDE,
        dialogType: dialog,
        tittle: title,
        desc: msg,
        btnOkText: 'Close',
        btnOkIcon: Icons.check_circle,
        btnOkColor: Colors.green.shade900,
        btnOkOnPress: () {

        }).show();
  }

  void showdone()  async{

    slideDialog.showSlideDialog(
        pillColor: Colors.black,
        context: context,

        child: Flexible(
            child:    Center(child: SingleChildScrollView(
                child:

                Column(    children: <Widget>[
                       Text('Automatic Driving', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,  color: Colors.blue,)) ,
                  Text('Select waypoint location', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,  color: Colors.black,)) ,
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(color: Colors.greenAccent,child: Text('Home Point') , onPressed: () {}, ),SizedBox(width: 25,) ,Icon(FontAwesomeIcons.home, color: Colors.black),],),

                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 1') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('8 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 2') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('14 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 3') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('32 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 4') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('51 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 5') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('60 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 6') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('78 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 7') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('89 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 8') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('122 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 9') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('154 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 10') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('193 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 11') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('242 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 12') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('278 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),
                    Row(children: <Widget>[ SizedBox(width: 250,) ,RaisedButton(child: Text('Waypoing 13') ,onPressed: () {}, color: Colors.lightBlueAccent,),SizedBox(width: 30,), Text('411 M.', style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black,))],),

                  ],)
            ))));
  }

  void showSimpleCustomDialog(BuildContext context) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Battery Swaping', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,  color: Colors.green,)) ,
            SizedBox(height: 10,),
            Text('Ozone ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,  color: Colors.black,)) ,
            Row(children: <Widget>[ RaisedButton(child: Text('Battery 1') ,onPressed: () {
              setState(() {
                color1 = Colors.blue;
                color3 = Colors.grey;
              });
            }, color: color1,),SizedBox(width: 30,),RaisedButton(child: Text('Battery 2') ,onPressed: () {
              setState(() {
                color1 = Colors.grey;
                color3 = Colors.blue;
              });
            }, color: color3,)],),
            Text('Engine', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,  color: Colors.black,)) ,
            Row(children: <Widget>[ RaisedButton(child: Text('Battery 1') ,onPressed: () {}, color: color2,),SizedBox(width: 30,),RaisedButton(child: Text('Battery 2') ,onPressed: () {}, color: color4,)],),

          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }
}
