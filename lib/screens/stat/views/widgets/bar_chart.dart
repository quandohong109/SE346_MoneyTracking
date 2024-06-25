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

    // Lấy số lượng của khoảng thời gian chia nhỏ
    // Nếu khoảng thời gian ban đầu lớn hơn hoặc bằng 6 ngày thì số lượngsẽ bằng 6.
    // Nếu khoảng thời gian ban đầu nhỏ hơn 6 ngày và lớn hơn 0 thì số lượng sẽ bằng đúng khoảng thời gian ban đầu đó.
    // Nếu khoảng thời gian ban đầu bằng 0 thì số lượng sẽ bằng 1.
    int dayRange = (value.duration >= const Duration(days: 6))
        ? 6
        : (value.duration.inDays == 0)
        ? 1
        : value.duration.inDays;

    // Biến lưu giá trị tính toán cho khoảng thời gian.
    List<dynamic> calculationList = [];

    // Giá trị thực của một khoảng thời gian (tức là một khoảng thời gian sau khi chia nhỏ có bao nhiêu ngày) được tính bằng khoảng thời gian ban đầu chia cho số lượng khoảng thời gian được tính ở trên.
    var x = (value.duration.inDays / dayRange).round();

    // Subtract ở chỗ này là để khi vào hàm for bên dưới, firstDate quay về đúng với giá trị ban đầu của beginDate.
    // Vì việc add 1 ngày ở dòng đầu trong hàm for là cần thiết, không thể bỏ.
    var firstDate = beginDate.subtract(const Duration(days: 1));

    for (int i = 0; i < dayRange; i++) {
      // Khoảng thời gian thì phải có ngày bắt đầu và ngày kết thúc. Ở đây biến firstDate và secondDate được dùng để tượng trưng cho điều đó, ngày bắt đầu và ngày kết thúc của khoảng thời gian được chia tách.
      firstDate = firstDate.add(const Duration(days: 1));
      var secondDate =
      (i != dayRange - 1) ? firstDate.add(Duration(days: x)) : endDate;

      // Lưu kết quả tính toán thu nhập và chi tiêu theo khoảng thời gian xác định.
      // Có một danh sách để lưu khoảng thời gian đã được chia nhỏ và một danh sách để lưu số tiền thu, chi trong khoảng thời gian đó, đối chiếu với nhau theo thứ tự.
      // Ví dụ: Khoảng thời gian có thứ tự là 1 trong danh sách khoảng thời gian sẽ có thông tin thu chi có thứ tự là 1 tranh danh sách lưu số tiền thu chi.
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

      // Phần dưới này sẽ là tính toán giá trị lớn nhất trong tất cả các giao dịch.
      // Bước này là để lấy giá trị lớn nhất, hỗ trợ cho việc hiển thị cột trong chart.
      // calculation.first là số tiền thu nhập, calculation.last là số tiền chi tiêu
      double temp = (calculation.first > calculation.last
          ? calculation.first
          : calculation.last);
      if (temp > maximumAmount) maximumAmount = temp;

      // Tăng lên một chu kỳ.
      // Nghĩa là sẽ tiếp tục tính toán khoảng thời gian được chia nhỏ tiếp theo cho đến khi vòng lặp kết thúc.
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
    generateData(
        beginDate, endDate, timeRangeList, transactionList, rawBarGroups);

    // Gán giá trị cho danh sách dữ liệu hiển thị.
    // Việc này dùng để chạy hiệu ứng chia trung bình khi chạm vào cột.
    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: AppColors.backgroundColor,
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
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor:
                            AppColors.foregroundColor.withOpacity(0.54),
                            getTooltipItem: (_a, _b, _c, _d) => null,
                          ),
                          touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
                            // Xử lý chạm trong bar chart.
                            if (response?.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex =
                                response!.spot!.touchedBarGroupIndex;

                            setState(() {
                              if (event is PointerExitEvent ||
                                  event is PointerUpEvent) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              } else {
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  double sum = 0;
                                  for (BarChartRodData rod
                                  in showingBarGroups[touchedGroupIndex]
                                      .barRods) {
                                    sum += rod.y;
                                  }
                                  final avg = sum /
                                      showingBarGroups[touchedGroupIndex]
                                          .barRods
                                          .length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex]
                                          .copyWith(
                                        barRods: showingBarGroups[touchedGroupIndex]
                                            .barRods
                                            .map((rod) {
                                          return rod.copyWith(y: avg);
                                        }).toList(),
                                      );
                                }
                              }
                            });
                          }),
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