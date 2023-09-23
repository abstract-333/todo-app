import 'package:flutter/material.dart';

class WidgetConstants {
  static const radiusOfShapes = BorderRadius.all(Radius.circular(10));
  static const shapeOfWidgets =
      RoundedRectangleBorder(borderRadius: radiusOfShapes);
  static const deleteIcon = Icon(Icons.delete, color: colorOfText);
  static const textStyleNavigationBar =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: colorOfText);
  static const colorMain = Colors.cyan;
  static const colorSecond = Colors.grey;
  static const mainTextStyle =
      TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: colorOfText);
  static const appBarTextStyle = TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: colorOfText);
  static const colorOfText = Colors.black;
}
