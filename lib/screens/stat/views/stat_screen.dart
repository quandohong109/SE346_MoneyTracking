
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracking/data/database/database.dart';
import 'package:money_tracking/objects/models/category_model.dart';
import 'package:money_tracking/objects/models/transaction_model.dart';
import 'package:money_tracking/screens/stat/views/widgets/bar_chart.dart';
import 'package:money_tracking/screens/stat/views/widgets/pie_chart.dart';
import 'package:money_tracking/presentation/resources/app_colors.dart';
import 'package:money_tracking/screens/stat/views/widgets/time_range_selection.dart';
import 'package:money_tracking/screens/stat/views/widgets/total_money.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  _StatScreenState createState()=>_StatScreenState();
}
class _StatScreenState extends State<StatScreen>
{

  // Khởi tạo mốc thời gian cần thống kê.
  late DateTime beginDate;
  late DateTime endDate;
  String dateDescription = 'This month';
  @override
  void initState() {
    // Lấy ngày đầu tiên của tháng và năm hiện tại.
    beginDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    // Lấy ngày cuối cùng của tháng và năm hiện tại.
    endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 300,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.grey.shade100,

            title: GestureDetector(
              onTap: _showMonthPicker,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,

                children: [
                  Column(
                    children: <Widget>[
                      Text(
                        dateDescription,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: AppColors.foregroundColor,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        "${DateFormat('dd/MM/yyyy').format(beginDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: AppColors.foregroundColor.withOpacity(0.7),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_drop_down, color: AppColors.foregroundColor),
                ],
              ),
            ),
          ),
          body: Builder(
              builder: (context) {
                // Lấy danh sách transaction từ stream.
                List<TransactionModel> transactionList = Database().transactionList;

                // Khởi tạo danh sách để các danh mục income, expense.
                List<CategoryModel> incomeCategoryList = [];
                List<CategoryModel> expenseCategoryList = [];

                double income = 0;
                double expense = 0;

                // Duyệt danh sách transactions để thực hiện các tác vụ lọc danh sách danh mục và tính toán các khoản tiền.
                transactionList.forEach((element) {
                  if (element.date.compareTo(endDate) <= 0) {
                    if (!element.category.isIncome) {
                      if (element.date.compareTo(beginDate) >= 0) {
                        expense += element.amount.toDouble();
                        if (!expenseCategoryList.any((categoryElement) {
                          if (categoryElement.name == element.category.name)
                            return true;
                          else
                            return false;
                        })) {
                          expenseCategoryList.add(element.category);
                        }
                      }
                    } else if (element.category.isIncome) {
                      if (element.date.compareTo(beginDate) >= 0) {
                        // Tính khoản tiền thu.
                        income += element.amount.toDouble();
                        // Lọc những danh mục income từ danh sách transaction hiện có và thêm vào danh sách danh mục income.
                        if (!incomeCategoryList.any((categoryElement) {
                          if (categoryElement.name == element.category.name)
                            return true;
                          else
                            return false;
                        })) {
                          incomeCategoryList.add(element.category);
                        }
                      }
                    }
                  }
                });
                // Lọc danh sách transactions trong khoảng thời gian đã được xác định.
                transactionList = transactionList
                    .where((element) =>
                element.date.compareTo(beginDate) >= 0 &&
                    element.date.compareTo(endDate) <= 0)
                    .toList();
                return ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                  ),
                    BarChartScreen(
                          currentList: transactionList,
                          beginDate: beginDate,
                          endDate: endDate),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                         'Income',
                                          style: TextStyle(
                                            color: AppColors.foregroundColor
                                                .withOpacity(0.7),
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        TotalMoney(
                                          checkOverflow: true,
                                          text: income,
                                          currencyId: 'VND',
                                          textStyle: TextStyle(
                                            color: AppColors.incomeColor,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20,
                                            height: 1.5,
                                          ),
                                        ),
                                        PieChartScreen(
                                          isShowPercent: false,
                                          currentList: transactionList,
                                          categoryList: incomeCategoryList,
                                          total: BigInt.from(income),
                                          beginDay: beginDate,
                                          endDay: endDate,
                                        ),
                                      ],
                                    ),
                                  )
                            ),
                            Expanded(
                              child: Column(children: <Widget>[
                                Text(
                                  'Expense',
                                  style: TextStyle(
                                    color: AppColors.foregroundColor
                                        .withOpacity(0.7),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                TotalMoney(
                                  checkOverflow: true,
                                  text: expense,
                                  currencyId: 'VND',
                                  textStyle: TextStyle(
                                    color: AppColors.expenseColor,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    height: 1.5,
                                  ),
                                ),
                                PieChartScreen(
                                  isShowPercent: false,
                                  currentList: transactionList,
                                  categoryList: expenseCategoryList,
                                  total: BigInt.from(expense),
                                  beginDay: beginDate,
                                  endDay: endDate,
                                ),
                              ])
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              })
      ),
    );
  }
  void _showMonthPicker() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) => TimeRangeSelection(),
    );

    if (result != null) {
      setState(() {
        dateDescription = result['description'];
        beginDate = result['begin'];
        endDate = result['end'];
      });
    }
  }
}
