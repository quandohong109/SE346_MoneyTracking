import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking/screens/stat/views/filter_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_tracking/screens/stat/views/widgets/bar_chart_widgets.dart';
import 'package:money_tracking/screens/stat/views/widgets/pie_chart_widgets.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
    );
  }
  @override
  _StatScreenState createState()=>_StatScreenState();
}
class _StatScreenState extends State<StatScreen>
{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: const TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 24,
            fontWeight: FontWeight.w100
        ),
        title: const Text(
          'Báo cáo chi tiêu',
      ),
    ),
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    iconSize: 40,
                    color: const Color(0xff000139),
                    icon: const Icon(Icons.filter_alt),
                    onPressed: () {  Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => FilterScreen.newInstance(),
                        )
                    ); },),
                ]

              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  makeStatIcon(),
                  const SizedBox(
                    width: 38,
                  ),
                  const Text(
                    'Thống Kê Theo Ngày Tháng',
                    style: TextStyle(color: Color(0xff000077), fontSize: 22),
                  ),
                ],
              ),
              BarChartWidgets(),

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  makeStatIcon(),
                  const SizedBox(
                    width: 38,
                  ),
                  const Text(
                    'Thống Kê  Theo Danh Mục',
                    style: TextStyle(color: Color(0xff000077), fontSize: 22),
                  ),
                ],
              ),
              const PieChartWidgets(),
          ],
        ),
      ),
      ),
    );
  }
  Widget makeStatIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: const Color(0xff000044).withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: const Color(0xff000044).withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: const Color(0xff000044).withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: const Color(0xff000044).withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: const Color(0xff000044).withOpacity(0.4),
        ),
      ],
    );
  }
}

