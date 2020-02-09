import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ParkLot with ChangeNotifier {
  @required
  final String id;
  @required
  final String title;
  @required
  final double max;
  @required
  final String imageUrl;
  @required
  final String lat;
  @required
  final String lon;
  @required
  List poly;
  @required
  List<int> lifeTime;
  Color color;

  ParkLot({
    this.id,
    this.title,
    this.max,
    this.imageUrl,
    this.lat,
    this.lon,
    this.poly,
    this.lifeTime,
    this.color,
  });
}
