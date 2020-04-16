import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
List rooms = [
  {
    "temperature": 24,
    "power": 60,
    "humidity": 73,
    "roomName": 'Robot Status',
    "roomImg": 'giphy.gif',
    "lastActivity": '15 min',
    "locked": false,
    "opacity": 0.9,
    "devices": [
      {
        "icon": 'light-bulb.svg',
        "label": 'Turn On Power',
        "color": Color(0xFFA4A4A4),
        "status": false,
        "rotationValue": 2,
      },
      {
        "icon": 'sensor.svg',
        "label": 'Connect Wifi',
        "color": Color(0xFFA4A4A4),
        "status": false,
      },
      {
        "icon": 'webcam.svg',
        "label": 'Record Camera',
        "color": Color(0xFFA4A4A4),
        "status": false,
      },

    ]
  },


];
