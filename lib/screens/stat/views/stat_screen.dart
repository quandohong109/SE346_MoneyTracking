import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracking/objects/models/transaction_model.dart';
import 'package:money_tracking/screens/main/month_picker.dart';
import 'package:money_tracking/screens/stat/views/widgets/bar_chart.dart';
import 'package:money_tracking/screens/stat/views/widgets/pie_chart.dart';
import 'package:money_tracking/presentation/resources/app_colors.dart';

import 'package:money_tracking/screens/stat/views/widgets/total_money.dart';

import 'cubits/stat_screen_cubit.dart';
import 'cubits/stat_screen_state.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  static Widget newInstance() =>
      BlocProvider(
        create: (context) => StatScreenCubit(),
        child: const StatScreen(),
      );

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  StatScreenCubit get cubit => context.read<StatScreenCubit>();

  @override
  void initState() {
    super.initState();
    cubit.updateTransactionListStream();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .background,
          body: BlocBuilder<StatScreenCubit, StatScreenState>(
              builder: (context, state) {
                return Column(
                  children: [
                    MonthPicker(
                      selectedDate: state.selectedDate,
                      updateSelectedDate: (DateTime newDate) {
                        cubit.updateSelectedDate(newDate);
                      },
                    ),
                    Expanded(
                      child: StreamBuilder<List<TransactionModel>>(
                        stream: cubit.state.transactionListStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            cubit.calculateIncomeAndExpense(snapshot.data!);
                            final transactionList = cubit.state.transactionList;
                            if (transactionList.isEmpty) {
                              return const Center(child: Text('No categories found'));
                            } else {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    BarChartScreen(
                                      currentList: transactionList,
                                      beginDate: cubit.state.beginDate,
                                      endDate: cubit.state.endDate,
                                    ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      'Income',
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .foregroundColor
                                                            .withOpacity(0.7),
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    TotalMoney(
                                                      checkOverflow: true,
                                                      text: cubit.state.income,
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
                                                      categoryList: cubit.state.incomeCategoryList,
                                                      total: BigInt.from(cubit.state.income),
                                                      beginDay: cubit.state.beginDate,
                                                      endDay: cubit.state.endDate,
                                                    ),
                                                  ],
                                                )
                                            ),
                                            Expanded(
                                                child: Column(children: <Widget>[
                                                      Text(
                                                        'Expense',
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .foregroundColor
                                                              .withOpacity(0.7),
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      TotalMoney(
                                                        checkOverflow: true,
                                                        text: cubit.state.expense,
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
                                                        categoryList: cubit.state
                                                            .expenseCategoryList,
                                                        total: BigInt.from(
                                                            cubit.state.expense),
                                                        beginDay: cubit
                                                            .getStartDate(),
                                                        endDay: cubit
                                                            .getEndDate(),
                                                      ),
                                                    ])
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ],
                );
              })
      ),
    );
  }
}
