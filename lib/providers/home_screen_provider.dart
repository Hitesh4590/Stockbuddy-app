import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier {
  int get selectedRadioValue => _selectedRadioValue;
  int _selectedRadioValue = 0;
  String get dropdownValue => _dropdownValue;
  String _dropdownValue = 'Monthly';

  Future handleRadioValueChange(int value) async {
    _selectedRadioValue = value;
    notifyListeners();
  }

  Future handleDropDownValueChange(String value) async {
    _dropdownValue = value;
    notifyListeners();
  }

  final List<BarChartGroupData> _data = [];
  List<String> _bottomTitles = [];
  List<String> get bottomTitles => _bottomTitles;
  List<BarChartGroupData> get chartData => _data;
  late QuerySnapshot querySnapshot;
  Map<int, double> monthlySums = {};
  Map<int, double> weeklySums = {};
  Map<int, double> yearlySums = {};

  final now = DateTime.now();
  late DateTime startDate;
  late DateTime endDate;

  List<String> _allChannel = [];
  List<String> get allChannel => _allChannel;
  Future<void> fetchChannel() async {
    final DocumentReference channel = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Channel')
        .doc(FirebaseAuth.instance.currentUser?.uid);
    final QuerySnapshot querySnapshot1 =
        await channel.collection('System_Channel').get();
    final QuerySnapshot querySnapshot2 =
        await channel.collection('User_Channel').get();
    final List<String> systemChannel =
        querySnapshot1.docs.map((doc) => doc['title'] as String).toList();
    final List<String> userChannel =
        querySnapshot2.docs.map((doc) => doc['title'] as String).toList();
    _allChannel = systemChannel + userChannel;

    notifyListeners();
  }

  Future<void> fetchChartData() async {
    switch (selectedRadioValue) {
      case 0:
        switch (dropdownValue) {
          case 'Yearly':
            yearlySums.clear();
            _data.clear();
            startDate = DateTime(now.year - 4, 1, 1);
            endDate = DateTime(now.year + 1, 1, 1);
            querySnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('Orders')
                .where('date',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                .where('date', isLessThan: Timestamp.fromDate(endDate))
                .get();
            _bottomTitles.clear();
            for (int year = now.year - 4; year <= now.year; year++) {
              yearlySums[year] = 0;
              _bottomTitles.add(year.toString());
            }

            for (var doc in querySnapshot.docs) {
              final DateTime date = (doc['date'] as Timestamp).toDate();
              int year = date.year;
              yearlySums[year] =
                  yearlySums[year]! + /*doc['quantity'].toDouble()*/ 1;
            }
            print(yearlySums);
            _data.clear();
            yearlySums.forEach((year, sum) {
              _data.add(BarChartGroupData(
                x: year - (now.year - 4),
                barRods: [
                  BarChartRodData(
                    toY: sum,
                    color: const Color(0xffFF9501),
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              ));
            });

            break;
          case 'Monthly':
            monthlySums.clear();
            startDate = DateTime(now.year, 1, 1);
            endDate = DateTime(now.year + 1, 1, 1);
            querySnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('Orders')
                .where('date',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                .where('date', isLessThan: Timestamp.fromDate(endDate))
                .get();

            for (int month = 1; month <= 12; month++) {
              monthlySums[month] = 0;
            }
            _bottomTitles.clear();
            _bottomTitles = [
              '',
              'jan',
              'feb',
              'mar',
              'apr',
              'may',
              'jun',
              'july',
              'aug',
              'sept',
              'oct',
              'nov',
              'dec',
            ];

            for (var doc in querySnapshot.docs) {
              DateTime date = (doc['date'] as Timestamp).toDate();
              int month = date.month;
              monthlySums[month] =
                  monthlySums[month]! + 1 /*doc['quantity'].toDouble()*/;
            }
            _data.clear();
            monthlySums.forEach((month, sum) {
              _data.add(BarChartGroupData(
                x: month,
                barRods: [
                  BarChartRodData(
                    toY: sum,
                    color: Color(0xffFF9501),
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              ));
            });

          case 'Weekly':
            _data.clear();
            DateTime now = DateTime.now();
            // Start from the previous Sunday
            startDate = now.subtract(Duration(days: now.weekday + 1));

            // End on the next Sunday
            endDate = startDate.add(Duration(days: 8));

            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('Orders')
                .where('date',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                .where('date', isLessThan: Timestamp.fromDate(endDate))
                .get();

            // Initialize sums for each day of the week
            List<double> weeklySums = List.filled(7, 0.0);

            // Accumulate sums
            for (var doc in querySnapshot.docs) {
              DateTime date = (doc['date'] as Timestamp).toDate();
              int day = date.weekday %
                  7; // Adjust to get correct index for Sunday as 0
              weeklySums[day] += /*doc['quantity'].toDouble()*/ 1;
            }
            print(weeklySums);

            // Add data to the chart
            for (int index = 0; index < 7; index++) {
              _data.add(
                BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: weeklySums[index],
                      color: Color(0xffFF9501),
                      width: 20,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            }
            _bottomTitles.clear();
            _bottomTitles = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            break;
        }

        break;
      case 1:
        switch (dropdownValue) {
          case 'Yearly':
            yearlySums.clear();
            _data.clear();
            startDate = DateTime(now.year - 4, 1, 1);
            endDate = DateTime(now.year + 1, 1, 1);
            querySnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('Orders')
                .where('date',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                .where('date', isLessThan: Timestamp.fromDate(endDate))
                .get();
            _bottomTitles.clear();
            for (int year = now.year - 4; year <= now.year; year++) {
              yearlySums[year] = 0;
              _bottomTitles.add(year.toString());
            }

            for (var doc in querySnapshot.docs) {
              DateTime date = (doc['date'] as Timestamp).toDate();
              int year = date.year;
              yearlySums[year] =
                  yearlySums[year]! + doc['totalAmount'].toDouble();
            }
            print(yearlySums);
            _data.clear();
            yearlySums.forEach((year, sum) {
              _data.add(BarChartGroupData(
                x: year - (now.year - 4),
                barRods: [
                  BarChartRodData(
                    toY: sum,
                    color: const Color(0xffFF9501),
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              ));
            });

            break;
          case 'Monthly':
            monthlySums.clear();
            startDate = DateTime(now.year, 1, 1);
            endDate = DateTime(now.year + 1, 1, 1);
            querySnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('Orders')
                .where('date',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                .where('date', isLessThan: Timestamp.fromDate(endDate))
                .get();

            for (int month = 1; month <= 12; month++) {
              monthlySums[month] = 0;
            }
            _bottomTitles.clear();
            _bottomTitles = [
              '',
              'jan',
              'feb',
              'mar',
              'apr',
              'may',
              'jun',
              'july',
              'aug',
              'sept',
              'oct',
              'nov',
              'dec',
            ];

            for (var doc in querySnapshot.docs) {
              DateTime date = (doc['date'] as Timestamp).toDate();
              int month = date.month;
              monthlySums[month] =
                  monthlySums[month]! + doc['totalAmount'].toDouble();
            }
            _data.clear();
            monthlySums.forEach((month, sum) {
              _data.add(BarChartGroupData(
                x: month,
                barRods: [
                  BarChartRodData(
                    toY: sum,
                    color: Color(0xffFF9501),
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              ));
            });

          case 'Weekly':
            _data.clear();
            DateTime now = DateTime.now();
            // Start from the previous Sunday
            startDate = now.subtract(Duration(days: now.weekday + 1));

            // End on the next Sunday
            endDate = startDate.add(Duration(days: 8));

            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('Orders')
                .where('date',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                .where('date', isLessThan: Timestamp.fromDate(endDate))
                .get();

            // Initialize sums for each day of the week
            List<double> weeklySums = List.filled(7, 0.0);

            // Accumulate sums
            for (var doc in querySnapshot.docs) {
              DateTime date = (doc['date'] as Timestamp).toDate();
              int day = date.weekday %
                  7; // Adjust to get correct index for Sunday as 0
              weeklySums[day] += doc['totalAmount'].toDouble();
            }
            print(weeklySums);

            // Add data to the chart
            for (int index = 0; index < 7; index++) {
              _data.add(
                BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: weeklySums[index],
                      color: Color(0xffFF9501),
                      width: 20,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            }
            _bottomTitles.clear();
            _bottomTitles = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            break;
        }
    }
    notifyListeners();
  }

  int _count = 0;
  int get count => _count;
  Future<void> increment() async {
    _count += 1;
    if (_count == 6) {
      _count = 1;
    }
    notifyListeners();
  }

  double _todaySales = 0;
  double get todaySales => _todaySales;
  double _todayExpense = 0;
  double get todayExpense => _todayExpense;
  double _todayProfit = 0;
  double get todayProfit => _todayProfit;

  Future<void> fetchStats() async {
    _todayProfit = 0;
    _todaySales = 0;
    _todayExpense = 0;
    final CollectionReference order = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Orders');
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    QuerySnapshot querySnapshot =
        await order.where('date', isGreaterThan: date).get();
    for (var doc in querySnapshot.docs) {
      _todaySales += doc['totalAmount'];
    }
    //
    //
    final CollectionReference inventory = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory');
    QuerySnapshot inventorySnapshot = await inventory.get();
    for (QueryDocumentSnapshot inventoryDoc in inventorySnapshot.docs) {
      QuerySnapshot productDetailsSnapshot = await inventory
          .doc(inventoryDoc.id)
          .collection('ProductDetails')
          .get();

      for (QueryDocumentSnapshot productDetailDoc
          in productDetailsSnapshot.docs) {
        QuerySnapshot batchesSnapshot = await inventory
            .doc(inventoryDoc.id)
            .collection('ProductDetails')
            .doc(productDetailDoc.id)
            .collection('Batches')
            .where('date', isGreaterThanOrEqualTo: date)
            .get();

        for (QueryDocumentSnapshot batchDoc in batchesSnapshot.docs) {
          int quantity = batchDoc['quantity'];
          print(quantity);
          double buyPrice = batchDoc['buy_price'];
          print(buyPrice);
          _todayExpense += (quantity * buyPrice);
          /* Map<String, dynamic> batchData =
              batchDoc.data() as Map<String, dynamic>;
          double quantity = batchData['quantity'];
          double buyPrice = batchData['buy_price'];
          _todayExpense += quantity * buyPrice;*/
        }
      }
    }
    notifyListeners();
  }
}
