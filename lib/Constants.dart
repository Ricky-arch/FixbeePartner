import 'dart:ui';
import 'package:flutter/material.dart';

class Constants {
  static const String HOST_IP = "fixbee.in";
  static const updateLocationTimeOut = 30;
  static const rupeeSign = "₹";
  static const String PROTOCOL = "https";
  static const WS_PROTOCOL = 'ws';
  static const googleApiKey = 'AIzaSyBOtIGTYgsxiCKVDAXWy9ZPU0rUPr2P8sI';
  static const googleSessionToken = '12345';
  static const fields = 'name,formatted_address,geometry';
  static const PING_TIMEOUT = 5;
  static const RAZORPAY_KEY = 'rzp_live_T9wLKrbt1yS0q2';
  static const double padding = 20;
  static const double avatarRadius = 45;
  static const FIXBEE_ADDRESS =
      'Shib Nagar, College Road, Agartala, West Tripura-799001';
  static const DISPLAY_PICTURE_TAG = 'displayPicture';
  static const DOCUMENTS_TAG = 'document';
  static const IDENTITY_PROOF_TAG = 'identity';
  static const AGE_PROOF_TAG = 'age';
  static const ADDRESS_PROOF_TAG = 'address';
  static const ADDITIONAL_TAG = 'additional';
  static const PLAYSTORE_APP_LINK =
      'https://play.google.com/store/apps/details?id=in.fixbee.fixbee_partner';
  static const MAP_STYLES = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]''';
}

class EndPoints {
  static const LOGIN = "${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/login";
  static const REQUEST_OTP =
      "${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/request";
  static const REGISTER =
      "${Constants.PROTOCOL}://${Constants.HOST_IP}/bee/register";
  static const GRAPHQL =
      "${Constants.PROTOCOL}://${Constants.HOST_IP}/graphql/b";
  static const GRAPHQL_WS =
      "${Constants.WS_PROTOCOL}://${Constants.HOST_IP}/graphql";
  static const DOCUMENT =
      "${Constants.PROTOCOL}://${Constants.HOST_IP}/graphql/view/b/";
  static const INFO = "${Constants.PROTOCOL}://${Constants.HOST_IP}/info";
  static const TNC = "${Constants.PROTOCOL}://${Constants.HOST_IP}/tnc";
  static const PRIVACY_POLICY =
      "${Constants.PROTOCOL}://${Constants.HOST_IP}/privacy";
}

class SharedPrefKeys {
  static const TOKEN = 'token@bee';
  static const ORDER = 'ORDER';
  static const ORDER_PREF = 'ORDER_PREF';
  static const METADATA = 'metadata';
}

class PrimaryColors {
  //static Color backgroundColor = Color.fromRGBO(0, 7, 17, 9);
  static Color backgroundColor = Color(0xff121212);
  static Color imageBackground = Color(0xff2f2f2f).withOpacity(0.5);
  static Color yellowColor = Colors.amber;
  static Color whiteColor = Colors.white;
  static Color backgroundcolorlight = Color(0xfff5f5f5);
}

class Rules {
  static const DOCUMENT_RULES = [
    "Uploaded the mentioned documents only.",
    "Document should be .jpg or .png format.",
    "Each Document should be below 100kb.",
    "Document should be readable.",
    "Once verified, documents can not  be re-uploaded."
  ];
  static const DISPLAY_PICTURE_RULES = [
    "Photo Upload is mandatory for verification ( Solid Clothing ).",
    "Picture should be latest.",
    "Photo should be .jpg or .png format.",
    "Photo should be below 200kb."
  ];
}
