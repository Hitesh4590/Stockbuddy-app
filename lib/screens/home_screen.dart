import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/widget/gridview_tile.dart';
import 'package:stockbuddy_flutter_app/common/widget/radio_item_widget.dart';
import 'package:stockbuddy_flutter_app/providers/home_screen_provider.dart';
import 'package:stockbuddy_flutter_app/screens/database_service.dart';
import 'package:stockbuddy_flutter_app/screens/sign_in_screen.dart';
import '../common/theme/color_constants.dart';
import '../common/theme/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color selected = Color(0xffff9501);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeScreenProvider>().fetchChartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var home = context.watch<HomeScreenProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Dashboard',
          style: TextStyles.regularBlack(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            24.vs,
            Text(
              'Hello, Good Morning!',
              style: TextStyles.bold(fontSize: 14),
            ),
            Text(
              'Your dashboard details',
              style: TextStyles.regular(fontSize: 12),
            ),
            20.vs,
            SizedBox(
              height: 169,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 2.32,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: <Widget>[
                  GridviewTileWidget(
                    iconPath: ImageConstants.salesIcon,
                    value: '452',
                    labelText: 'Today Sales',
                    color1: Color(0xffCEE3F6),
                    color2: Color(0xffFBFCFF),
                    borderColor: Color(0xffB9DCFB),
                  ),
                  GridviewTileWidget(
                    iconPath: ImageConstants.salesIcon,
                    value: '452',
                    labelText: 'Today Profit',
                    color1: Color(0xffE2D3FF),
                    color2: Color(0xffFBFCFF),
                    borderColor: Color(0xffCEB4FF),
                  ),
                  GridviewTileWidget(
                    iconPath: ImageConstants.salesIcon,
                    value: '452',
                    labelText: 'Today Due',
                    color1: Color(0xffFFE9E3),
                    color2: Color(0xffFBFCFF),
                    borderColor: Color(0xffFFD5C9),
                  ),
                  GridviewTileWidget(
                    iconPath: ImageConstants.salesIcon,
                    value: '452',
                    labelText: 'Today Expense',
                    color1: Color(0xffDFF8B5),
                    color2: Color(0xffFBFCFF),
                    borderColor: Color(0xffDEFFA6),
                  ),
                ],
              ),
            ),
            20.vs,
            Container(
              height: 365,
              width: 343,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.black)),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: ColorConstants.darkGrey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.black)),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          height: 36,
                          width: 36,
                          child: SvgPicture.asset(ImageConstants.grossRevenue)
                              .allp(5),
                        ),
                        10.hs,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today Gross Revenue',
                              style: TextStyles.regular(
                                  fontSize: 10, color: Colors.white),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '₹ 59,571',
                                  style: TextStyles.bold(
                                      color: Colors.white, fontSize: 22),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '34%',
                                    style: TextStyles.regular(),
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: '\ncompared to previous month',
                                          style: TextStyle(fontSize: 8)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xffEEEEEE).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: SvgPicture.asset(
                            ImageConstants.externalLink,
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ).allp(10),
                  ),
                  12.vs,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Revenue Comparison',
                        style: TextStyles.regular(color: Colors.black),
                      ),
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius:
                              BorderRadius.circular(20), // circular border
                        ),
                        child: DropdownButton<String>(
                          value: home.dropdownValue,
                          icon: const Icon(Icons.arrow_drop_down),
                          style: const TextStyle(color: Colors.black),
                          underline: Container(),
                          onChanged: (String? value) {
                            home.handleDropDownValueChange(value!);
                            home.fetchChartData();
                          },
                          items: <String>['Weekly', 'Monthly', 'Yearly']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ).allp(5),
                      )
                    ],
                  ).hp(2),
                  11.vs,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.hs,
                      GestureDetector(
                          child: RadioItemWidget(
                              id: 0,
                              selectedValue: home.selectedRadioValue,
                              text: 'Orders'),
                          onTap: () {
                            home.handleRadioValueChange(0);
                            home.fetchChartData();
                          }),
                      15.hs,
                      GestureDetector(
                          child: RadioItemWidget(
                              id: 1,
                              selectedValue: home.selectedRadioValue,
                              text: 'Revenue'),
                          onTap: () {
                            home.handleRadioValueChange(1);
                            home.fetchChartData();
                          }),
                      15.hs,
                      GestureDetector(
                          child: RadioItemWidget(
                              id: 2,
                              selectedValue: home.selectedRadioValue,
                              text: 'Channel'),
                          onTap: () {
                            home.handleRadioValueChange(2);
                            home.fetchChartData();
                          }),
                    ],
                  ),
                  12.vs,
                  Expanded(
                    child: BarChart(
                      swapAnimationDuration: Duration.zero,
                      BarChartData(
                        gridData: const FlGridData(
                            drawHorizontalLine: true, drawVerticalLine: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(
                                            home.bottomTitles[value.toInt()],
                                            style: TextStyles.regular(
                                                fontSize: 10),
                                          ));
                                    }))),
                        barGroups: home.chartData,
                      ),
                    ),
                  ),
                ],
              ).allp(6),
            ),
            20.vs,
            Container(
                height: 48,
                width: 343,
                decoration: BoxDecoration(
                    color: Color(0xFFFF9501).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImageConstants.profitExpense,
                    ),
                    10.hs,
                    Text(
                      'Profit & Expenses summary',
                      style: TextStyles.regular(color: Colors.black),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                    )
                  ],
                ).allp(15)),
            20.vs,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorConstants.darkGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'This Month',
                    style:
                        TextStyles.regular(color: Colors.white, fontSize: 14),
                  ),
                  12.vs,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            '2145',
                            style: TextStyles.bold(
                                color: Colors.white, fontSize: 22),
                          ),
                          Text(
                            'Gross Revenue',
                            style: TextStyles.regular(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 45,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            '2145',
                            style: TextStyles.bold(
                                color: Colors.white, fontSize: 22),
                          ),
                          Text(
                            'Units Sold',
                            style: TextStyles.regular(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 45,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            '2145',
                            style: TextStyles.bold(
                                color: Colors.white, fontSize: 22),
                          ),
                          Text(
                            'Orders',
                            style: TextStyles.regular(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ).allp(10),
            ),
            ElevatedButton(
                onPressed: () async {
                  await DatabaseService().logout();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => SignInScreen()));
                },
                child: const Text("Logout"))
          ],
        ).allp(16),
      ),
    );
  }
}
