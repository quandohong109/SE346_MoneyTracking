
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
  final DateTime? beginDate;
  final DateTime? endDate;
  StatScreen({Key? key,  this.endDate,  this.beginDate})
      : super(key: key);

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

  // Khởi tạo mốc thời gian cần thống kê.
  late DateTime beginDate;
  late DateTime endDate;
  String dateDescription = 'This month';
  @override
  void initState() {
    // Lấy ngày đầu tiên của tháng và năm hiện tại.
    beginDate = widget.beginDate ??
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    // Lấy ngày cuối cùng của tháng và năm hiện tại.
    endDate = widget.endDate ??
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
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
          backgroundColor: AppColors.backgroundColor,
          //extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            centerTitle: true,
            elevation: 0,
            leadingWidth: 70,
            title: GestureDetector(
              onTap: _showMonthPicker,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          body: Builder(
              builder: (context) {
                // Lấy danh sách transaction từ stream.
                List<TransactionModel> transactionList = Database().transactionList;

                // Khởi tạo danh sách để các danh mục income, expense.
                List<CategoryModel> incomeCategoryList = [];
                List<CategoryModel> expenseCategoryList = [];

                // Các biến tính toán số tiền.
                double openingBalance = 0;
                double closingBalance = 0;
                double income = 0;
                double expense = 0;

                // Duyệt danh sách transactions để thực hiện các tác vụ lọc danh sách danh mục và tính toán các khoản tiền.
                transactionList.forEach((element) {
                  if (element.date.isBefore(beginDate)) {
                    // Tính toán opening balance.
                    if (element.category.isIncome == false)
                      openingBalance -= element.amount.toDouble();
                    else if (element.category.isIncome)
                      openingBalance += element.amount.toDouble();
                  }
                  if (element.date.compareTo(endDate) <= 0) {
                    // Tính toán closing balance.
                    if (!element.category.isIncome) {
                      closingBalance -= element.amount.toDouble();
                      if (element.date.compareTo(beginDate) >= 0) {
                        // Tính toán khoản tiền chi.
                        expense += element.amount.toDouble();
                        // Lọc những danh mục expense từ danh sách transaction hiện có và thêm vào danh sách danh mục expense.
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
                      closingBalance += element.amount.toDouble();
                      if (element.date.compareTo(beginDate) >= 0) {
                        // Tính toán khoản tiền thu.
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
                    element.date.compareTo(endDate) <= 0 &&
                    element.category.isIncome != 'debt & loan')
                    .toList();
                return Container(
                  color: AppColors.backgroundColor,
                  child: ListView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.foregroundColor.withOpacity(0.24),
                                width: 0.5,
                              ),
                            )),
                        child:Container(
                              color: AppColors
                                  .backgroundColor, // để lúc export ra không bị transparent.
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Opening balance',
                                              style: TextStyle(
                                                color: AppColors.foregroundColor
                                                    .withOpacity(0.7),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            TotalMoney(
                                              checkOverflow: true,
                                              text: openingBalance,
                                              currencyId: 'VND',
                                              textStyle: TextStyle(
                                                color: AppColors.foregroundColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                                height: 1.5,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Closing balance',
                                              style: TextStyle(
                                                color: AppColors.foregroundColor
                                                    .withOpacity(0.7),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            TotalMoney(
                                              checkOverflow: true,
                                              text: closingBalance,
                                              currencyId: 'VND',
                                              textStyle: TextStyle(
                                                color: AppColors.foregroundColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                                height: 1.5,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color:
                                    AppColors.foregroundColor.withOpacity(0.12),
                                    thickness: 2,
                                    height: 40,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Hero(
                                    tag: 'netIncomeChart',
                                    child: Material(
                                      color: AppColors.backgroundColor,
                                      child: Column(
                                        children: [
                                          Text('Net Income',
                                              style: TextStyle(
                                                color: AppColors.foregroundColor
                                                    .withOpacity(0.7),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              )),
                                          TotalMoney(
                                              text: closingBalance -
                                                  openingBalance,
                                              currencyId: 'VND',
                                              textStyle: TextStyle(
                                                color: (closingBalance -
                                                    openingBalance) >
                                                    0
                                                    ? AppColors.incomeColor
                                                    : (closingBalance -
                                                    openingBalance) ==
                                                    0
                                                    ? AppColors.foregroundColor
                                                    :AppColors.expenseColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 22,
                                                height: 1.5,
                                              )),
                                          SizedBox(
                                              width: 450,
                                              height: 350,
                                              child: BarChartScreen(
                                                  currentList: transactionList,
                                                  beginDate: beginDate,
                                                  endDate: endDate),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                      color: AppColors
                                          .backgroundColor, // để lúc export ra không bị transparent.
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
                                            Container(
                                              color: Colors.transparent,
                                              child: PieChartScreen(
                                                  isShowPercent: false,
                                                  currentList: transactionList,
                                                  categoryList:
                                                  incomeCategoryList,
                                                  total: BigInt.from(income)
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                              ),
                              Expanded(
                                child: Container(
                                      color: AppColors
                                          .backgroundColor, // để lúc export ra không bị transparent.
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
                                          Container(
                                            color: Colors.transparent,
                                            child: PieChartScreen(
                                                isShowPercent: false,
                                                currentList: transactionList,
                                                categoryList:
                                                expenseCategoryList,
                                                total: BigInt.from(expense)
                                            ),
                                          ),
                                      ]),
                                    )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })),
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
