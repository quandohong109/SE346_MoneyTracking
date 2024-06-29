import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_tracking/objects/models/transaction_model.dart';
import 'package:money_tracking/presentation/resources/app_colors.dart';

class BarChartScreen extends StatefulWidget {
  // Danh sách transactions.
  final List<TransactionModel> currentList;

  // Ngày bắt đầu và ngày kết thúc.
  final DateTime beginDate;
  final DateTime endDate;

  BarChartScreen({Key? key, required this.currentList, required this.beginDate, required this.endDate})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => BarChartScreenState();
}

class BarChartScreenState extends State<BarChartScreen> {
  // Format style cho cột trong biểu đồ.
  final Color leftBarColor = AppColors.incomeBarColor;
  final Color rightBarColor = AppColors.expenseBarColor;
  final double width = 7;

  // Danh sách dữ liệu cột.
  List<BarChartGroupData> rawBarGroups = [];

  // Danh sách dữ liệu cột được hiển thị.
  List<BarChartGroupData> showingBarGroups = [];

  // Danh sách transaction.
  List<TransactionModel> transactionList = [];

  // Ngày bắt đầu và ngày kết thúc.
  late DateTime beginDate;
  late DateTime endDate;

  // Giá trị lớn nhất trong biểu đồ.
  late double maximumAmount;

  // Danh sách khoảng thời gian đã được chia nhỏ và format dưới dạng String.
  List<String> timeRangeList = [];

  // Xử lý chạm cột trong chart.
  late int touchedGroupIndex;

  void generateData(
      DateTime beginDate,
      DateTime endDate,
      List<String> timeRangeList,
      List<TransactionModel> transactionList,
      List<BarChartGroupData> rawBarGroups) {
    // Đảm bảo các danh sách lưu dữ liệu được làm trống.
    rawBarGroups.clear();
    timeRangeList.clear();

    // Tạo đối tượng khoảng thời gian ban đầu dựa vào ngày bắt đầu và ngày kết thúc được truyền vào.
    DateTimeRange value = DateTimeRange(start: beginDate, end: endDate);

    int dayRange = (value.duration >= const Duration(days: 6))
        ? 6
        : (value.duration.inDays == 0)
        ? 1
        : value.duration.inDays;

    // Biến lưu giá trị tính toán cho khoảng thời gian.
    List<dynamic> calculationList = [];

    // Giá trị thực của một khoảng thời gian (tức là một khoảng thời gian sau khi chia nhỏ có bao nhiêu ngày) được tính bằng khoảng thời gian ban đầu chia cho số lượng khoảng thời gian được tính ở trên.
    var x = (value.duration.inDays / dayRange).round();

    var firstDate = beginDate.subtract(const Duration(days: 1));

    for (int i = 0; i < dayRange; i++) {
      // Khoảng thời gian thì phải có ngày bắt đầu và ngày kết thúc. Ở đây biến firstDate và secondDate được dùng để tượng trưng cho điều đó, ngày bắt đầu và ngày kết thúc của khoảng thời gian được chia tách.
      firstDate = firstDate.add(const Duration(days: 1));
      var secondDate =
      (i != dayRange - 1) ? firstDate.add(Duration(days: x)) : endDate;

      List<double> calculation =
      calculateByTimeRange(firstDate, secondDate, transactionList);
      if (firstDate.compareTo(endDate) < 0) {
        calculationList.add(calculation);
        timeRangeList
            .add("${firstDate.day}-${secondDate.day}");
      } else if (firstDate.compareTo(endDate) == 0) {
        calculationList.add(calculation);
        timeRangeList.add(firstDate.day.toString());
      }

      double temp = (calculation.first > calculation.last
          ? calculation.first
          : calculation.last);
      if (temp > maximumAmount) maximumAmount = temp;

      firstDate = firstDate.add(Duration(days: x));
    }
    if (calculationList.isNotEmpty) {
      for (int i = 0; i < calculationList.length; i++) {
        // Khởi tạo dữ liệu cho các cột trong chart.
        // Mỗi khoảng thời gian được chia nhỏ sẽ là một cột.
        var barGroup = makeGroupData(
            i,
            (calculationList[i].first * 19) / maximumAmount.round(),
            (calculationList[i].last * 19) / maximumAmount.round());
        rawBarGroups.add(barGroup);
      }
    }
  }

  // Hàm tính toán thu nhập và chi tiêu của danh sách transactions trong một khoảng thời gian xác định.
  List<double> calculateByTimeRange(DateTime beginDate, DateTime endDate,
      List<TransactionModel> transactionList) {
    double income = 0;
    double expense = 0;

    for (var element in transactionList) {
      if (element.date.compareTo(beginDate) >= 0 &&
          element.date.compareTo(endDate) <= 0) {
        if (!element.category.isIncome) {
          expense += element.amount.toDouble();
        } else {
          income += element.amount.toDouble();
        }
      }
    }
    return [income, expense];
  }

  @override
  void initState() {
    super.initState();
    transactionList = widget.currentList;
    beginDate = widget.beginDate;
    endDate = widget.endDate;
    maximumAmount = 1;

    // Hàm lấy tính toán và chia các khoảng thời gian để thống kê từ danh sách các giao dịch.
    generateData(
        beginDate, endDate, timeRangeList, transactionList, rawBarGroups);

    // Gán giá trị cho danh sách dữ liệu hiển thị.
    // Việc này dùng để chạy hiệu ứng chia trung bình khi chạm vào cột.
    showingBarGroups = rawBarGroups;
  }

  @override
  void didUpdateWidget(covariant BarChartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    transactionList = widget.currentList;
    beginDate = widget.beginDate;
    endDate = widget.endDate;
    maximumAmount = 1;

    // Hàm lấy tính toán và chia các khoảng thời gian để thống kê từ danh sách các giao dịch.
    generateData(beginDate, endDate, timeRangeList, transactionList, rawBarGroups);

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: BarChart(
                    BarChartData(
                      maxY: 20,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (BuildContext context, double value) => TextStyle(
                            color: AppColors.foregroundColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            fontFamily: 'Montserrat',
                          ),
                          margin: 10,
                          getTitles: (double value) {
                            return timeRangeList[value.toInt()];
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (BuildContext context, double value) => TextStyle(
                            color: AppColors.foregroundColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            fontFamily: 'Montserrat',
                          ),
                          margin: 10,
                          reservedSize: 50,
                          getTitles: (value) {
                            if (value == 0) {
                              return '0';
                            } else if (value == 10) {
                              return MoneyFormatter(amount: maximumAmount / 2)
                                  .output
                                  .compactNonSymbol;
                            } else if (value == 20) {
                              return MoneyFormatter(amount: maximumAmount)
                                  .output
                                  .compactNonSymbol;
                            } else {
                              return '';
                            }
                          },
                        ),
                        topTitles: SideTitles(
                          showTitles: false
                        ),
                        rightTitles: SideTitles(
                          showTitles: false
                        )
                      ),
                      gridData: FlGridData(
                        show: true,
                        checkToShowHorizontalLine: (value) => value % 2 == 0,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: AppColors.foregroundColor.withOpacity(0.24),
                          strokeWidth: 1,
                        ),
                        drawHorizontalLine: true,
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          top: BorderSide(
                            color: AppColors.foregroundColor.withOpacity(0.24),
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: AppColors.foregroundColor.withOpacity(0.24),
                            width: 1,
                          ),
                        ),
                      ),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: width * 2,
                            width: width,
                            decoration: BoxDecoration(
                              color: leftBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Income',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: AppColors.foregroundColor.withOpacity(0.54),
                              )),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: width * 2,
                            width: width,
                            decoration: BoxDecoration(
                              color: rightBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Expense',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: AppColors.foregroundColor.withOpacity(0.54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 80),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            height: 14,
                            width: 2,
                            color: AppColors.foregroundColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Amount',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: AppColors.foregroundColor.withOpacity(0.54),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 2,
                            width: 14,
                            color: AppColors.foregroundColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Time range (day)',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: AppColors.foregroundColor.withOpacity(0.54),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo dữ liệu cho cột.
  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      // Cột income.
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),

      // Cột expense.
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }
}