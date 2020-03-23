import 'package:cparking/loader/color_loader_3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../provider/report_provider.dart';
import '../loader/color_loader_3.dart';
import '../widgets/simpleLine.dart';
import '../provider/parkingLot.dart';
import '../provider/parkingLotProvider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

math.Random random = new math.Random();
List<double> _generateRandomData(int count) {
  List<double> result = <double>[];
  for (int i = 0; i < count; i++) {
    result.add(random.nextDouble() * 100);
  }
  return result;
}

class ViewHistoryScreen extends StatefulWidget {
  static const routeName = '/view-history';

  @override
  _ViewHistoryScreenState createState() => _ViewHistoryScreenState();
}

class _ViewHistoryScreenState extends State<ViewHistoryScreen> {
  double rating = 2.5;
  bool _isLoading = true;
  bool _isInit = true;
  double percentage;
  int now;

  var data = _generateRandomData(11);

  Widget _buildCoverImage(Size screenSize, ParkLot loc) {
    return Container(
      height: screenSize.height / 2.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(loc.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildReportName(ParkLot loc) {
    return Container(
      // color: Theme.of(context).accentColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 3,
        left: 28,
      ),
      child: Text(
        loc.title,
        style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStarAndCount(int reportCount) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 28,
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              right: 10,
            ),
            // width: 100,
            child: SmoothStarRating(
              allowHalfRating: false,
              onRatingChanged: (v) {
                rating = v;
              },
              starCount: 5,
              rating: rating,
              size: 20.0,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              color: Colors.yellow,
              borderColor: Colors.grey,
              spacing: 0.0,
            ),
          ),
          Text(
            '${reportCount.toString()} reviews',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 24,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryDetails(ParkLot loc) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
      ),
      // width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 4,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width / 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.place),
                    Text('คณะวิศวกรรมศาสตร์ มหาวิทยาลัยเชียงใหม่'),
                  ],
                ),
              ),
              color: Colors.black12,
            ),
          ),
          Container(
            // width: MediaQuery.of(context).size.width / 0.8,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Card(
                    elevation: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 8,
                      // width: MediaQuery.of(context).size.width / 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(Icons.directions_car),
                          Text('$now / ${loc.max.round()}'),
                        ],
                      ),
                    ),
                    color: Colors.black12,
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 8,
                      // width: MediaQuery.of(context).size.width / 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(Icons.multiline_chart),
                          Text('${percentage.round()} %'),
                        ],
                      ),
                    ),
                    color: Colors.black12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final name = ModalRoute.of(context).settings.arguments as String;
    final loc = Provider.of<ParkingLotProvider>(context).findById(name);

    getPercentage(name, loc);
    super.didChangeDependencies();
  }

  Future<void> getPercentage(String name, ParkLot lot) async {
    setState(() {
      _isLoading = true;
    });
    String url;
    // final time = DateTime.now();

    // String hour = (time.hour).toString();
    // String minute = setMinute(time.minute);
    url = 'https://cparking-ecee0.firebaseio.com/avai/$name/1/14/0.json';
    print(url);
    final response = await http.get(url);
    // print(lot.color);
    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    now = int.parse(decodeData['mean']);
    print(now);
    percentage = (int.parse(decodeData['mean']) / lot.max) * 100;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context).settings.arguments as String;
    final historyData = Provider.of<ReportsProvider>(context);
    final loc = Provider.of<ParkingLotProvider>(context).findById(name);
    // Provider.of<ReportsProvider>(context).fetchReportFromLocation(name);
    int currentReportCount = historyData.locReportsCount;

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            _buildCoverImage(screenSize, loc),
            SizedBox(
              height: 50,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            color: Colors.white70,
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                    ),
                    _buildReportName(loc),
                    _isLoading
                        ? Center(
                            child: ColorLoader3(),
                          )
                        : Column(
                            children: <Widget>[
                              _buildStarAndCount(currentReportCount),
                              _buildHistoryDetails(loc),
                            ],
                          ),
                    // Container(
                    //   height: 200,
                    //   child: PointsLineChart.withSampleData(),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
