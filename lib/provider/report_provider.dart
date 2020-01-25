import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './report.dart';
import 'dart:convert';
import 'dart:collection';

class ReportsProvider with ChangeNotifier {
  List<Report> _reports = [];

  List<Report> _userReports = [];

  List<Report> _reportsLoc = [];

  String authToken;
  String userId;
  Map<String, String> headers = new HashMap();

  // var _showFavourtiesOnly = false;

  ReportsProvider(
    this.authToken,
    this.userId,
    // this._reports,
  );
  //////
  List<Report> get reports {
    return [..._reports];
  }

  int get reportCount {
    return _reports.length;
  }

//////
  List<Report> get userReports {
    return [..._userReports];
  }

  int get userReportCount {
    return _userReports.length;
  }

/////
  List<Report> get locReports {
    return [..._reportsLoc];
  }

  int get locReportsCount {
    return _reportsLoc.length;
  }

  bool isOwnedby(Report report) {
    return report.userName == userId ? true : false;
  }

  // effect all pages scenarios
  // void showFavouritesOnly() {
  //   _showFavourtiesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavourtiesOnly = false;
  //   notifyListeners();
  // }
  // Product findById(String id) {
  //   return _items.firstWhere((prod) => prod.id == id);
  // }

  ///update products
  ///

  void updateProduct(String id, Report newProduct) {
    final prodIndex = _reports.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _reports[prodIndex] = newProduct;
      notifyListeners();
    }
    // print('...');
  }

  void removeReport(String id) {
    // final prodIndex = _items.indexWhere((prod) => prod.id == id);
    _reports.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  Report findById(String id) {
    return _reports.firstWhere((rep) => rep.id == id);
  }

  // Future<void> fetchAndGetProducts() async {
  //   const url = 'https://myshop-c8a90.firebaseio.com/products.json';
  //   try {
  //     final response = await http.get(url);
  //     final decodeData = json.decode(response.body) as Map<String, dynamic>;
  //     final List<Report> loadedProducts = [];
  //     decodeData.forEach((prodId, prodData) {
  //       loadedProducts.add(Report(
  //         id: prodId,
  //         title: prodData['title'],
  //         description: prodData['description'],
  //         price: prodData['price'],
  //         isFavorite: prodData['isFavourite'],
  //         imageUrl: prodData['imageUrl'],
  //       ));
  //     });
  //     _items = loadedProducts;
  //     notifyListeners();
  //     print(json.decode(response.body));
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  Future<void> fetchReport() async {
    final url =
        'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';

    final favUrl =
        'https://cparking-ecee0.firebaseio.com/userPromoted/$userId.json?auth=$authToken';
    //fetch and decode data

    try {
      final response = await http.get(url);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      if (decodeData == null) {
        return;
      }
      final favResponse = await http.get(favUrl);
      final favData = json.decode(favResponse.body);
      // print(favData);

      final List<Report> loadedProducts = [];
      decodeData.forEach((reportId, reportData) {
        loadedProducts.add(
          Report(
            id: reportId,
            userName: reportData['userName'],
            imageUrl: reportData['imageUrl'],
            lifeTime: reportData['lifeTime'],
            isPromoted: favData == null ? false : favData[reportId] ?? false,
            score: reportData['score'],
            dateTime: reportData['dateTime'].toString(),
            availability: reportData['availability'],
            loc: reportData['loc'],
          ),
        );
      });
      _reports = loadedProducts;
      notifyListeners();
      // print(_reports);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchReportFromLocation(String loc) async {
    final url =
        'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';

    final favUrl =
        'https://cparking-ecee0.firebaseio.com/userPromoted/$userId.json?auth=$authToken';
    //fetch and decode data

    try {
      final response = await http.get(url);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      if (decodeData == null) {
        return;
      }
      final favResponse = await http.get(favUrl);
      final favData = json.decode(favResponse.body);
      // print(favData);

      final List<Report> loadedProducts = [];
      decodeData.forEach((reportId, reportData) {
        if (reportData['loc'] == loc)
          loadedProducts.add(
            Report(
              id: reportId,
              userName: reportData['userName'],
              imageUrl: reportData['imageUrl'],
              lifeTime: reportData['lifeTime'],
              isPromoted: favData == null ? false : favData[reportId] ?? false,
              score: reportData['score'],
              dateTime: reportData['dateTime'].toString(),
              availability: reportData['availability'],
              loc: reportData['loc'],
            ),
          );
      });
      _reportsLoc = loadedProducts;
      notifyListeners();
      // print(loadedProducts);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchReportFromUserId(List<String> userReports) async {
    final url =
        'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';

    final favUrl =
        'https://cparking-ecee0.firebaseio.com/userPromoted/$userId.json?auth=$authToken';
    //fetch and decode data

    try {
      final response = await http.get(url);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      if (decodeData == null) {
        return;
      }
      final favResponse = await http.get(favUrl);
      final favData = json.decode(favResponse.body);
      // print(favData);
      final List<Report> loadedProducts = [];
      // print(userReports);
      decodeData.forEach((reportId, reportData) {
        // print(reportId);
        if ((userReports.contains(reportId)))
          loadedProducts.add(
            Report(
              id: reportId,
              userName: reportData['userName'],
              imageUrl: reportData['imageUrl'],
              lifeTime: reportData['lifeTime'],
              isPromoted: favData == null ? false : favData[reportId] ?? false,
              score: reportData['score'],
              dateTime: reportData['dateTime'].toString(),
              availability: reportData['availability'],
              loc: reportData['loc'],
            ),
          );
      });
      _userReports = loadedProducts;
      notifyListeners();
      // print(loadedProducts);
    } catch (error) {
      // print(error);
      throw error;
    }
  }

  Future<void> deleteReport(Report report) async {
    String keyName;

    final url1 =
        'https://cparking-ecee0.firebaseio.com/reports/${report.id}.json?auth=$authToken';
    try {
      await http.delete(url1, headers: headers).then((_) {
        print('deletion report from user success');
        _reports.removeWhere((rep) => rep.id == report.id);
        _userReports.removeWhere((rep) => rep.id == report.id);
        _reportsLoc.removeWhere((rep) => rep.id == report.id);
        notifyListeners();
      }).then((_) async {
        final url2 =
            'https://cparking-ecee0.firebaseio.com/users/$userId/reportsId.json';

        final response = await http.get(url2);
        final decodeData = json.decode(response.body) as Map<String, dynamic>;
        decodeData.forEach((reportId, reportData) {
          if (reportData == report.id) {
            keyName = reportId;
          }
        });
      }).then((_) async {
        final url3 =
            'https://cparking-ecee0.firebaseio.com/users/$userId/reportsId/$keyName.json';

        await http.delete(url3, headers: headers).then((_) {
          print("delete from reportFolder complete");
        });
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> addReport(Report report) async {
    final url1 =
        'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';

    // final add_date =
    //     DateFormat('yyyy-MM-dd').add_Hms().format(DateTime.now()).toString();
    final add_date = DateTime.now().toString();
    // print(add_date);
    // create products collection in firebase
    try {
      final response = await http.post(
        url1,
        body: json.encode({
          'userName': report.userName,
          'imageUrl': report.imageUrl,
          'lifeTime': report.lifeTime,
          'dateTime': add_date,
          'userName': userId,
          'loc': report.loc,
          // 'isPromote': report.isPromoted,
          'score': 0,
          'availability': report.availability,
        }),
      );

      final url2 =
          'https://cparking-ecee0.firebaseio.com/users/$userId/reportsId.json';

      await http.post(
        url2,
        body: json.encode(
          json.decode(response.body)['name'],
        ),
      );

      // print(json.decode(response.body));
      final rep = Report(
        id: json.decode(response.body)['name'],
        userName: report.userName,
        lifeTime: report.lifeTime,
        imageUrl: report.imageUrl,
        dateTime: add_date,
        score: report.score,
        loc: report.loc,
        // isPromoted: report.isPromoted,
        availability: report.availability,
      );
      _reports.add(rep);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
