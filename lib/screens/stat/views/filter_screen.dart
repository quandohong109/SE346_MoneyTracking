import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracking/screens/main/add_expense/entities/temp_category_list.dart';
import 'package:money_tracking/screens/stat/views/widgets/category_list_show.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../models/category_model.dart';
import '../../main/add_expense/view/widgets/standard_button.dart';
import '../cubit/filter_screen_cubit.dart';
class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});
  static Widget newInstance() =>
      BlocProvider(
        create: (context) => FilterScreenCubit(),
        child: const FilterScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
    );
  }
  @override
  _FilterScreenState createState()=>_FilterScreenState();
}
class _FilterScreenState extends State<FilterScreen>
{
  FilterScreenCubit get cubit => context.read<FilterScreenCubit>();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
      ),
        body: Center(
            child: Column(
                children: [
                  Expanded(
                      child:SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                makeFilterIcon(),
                                const SizedBox(
                                  width: 38,
                                ),
                                const Text(
                                  'Lọc Theo Ngày Tháng',
                                  style: TextStyle(color: Color(0xff000077), fontSize: 22),
                                ),
                              ],
                            ),
                           const SizedBox(
                             height: 5,
                           ),
                           TableCalendar(
                          firstDay: DateTime(2000, 1, 1),
                          lastDay: DateTime(2030, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                              });
                            },
                          ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                makeFilterIcon(),
                                const SizedBox(
                                  width: 38,
                                ),
                                const Text(
                                  'Lọc Theo Danh Mục',
                                  style: TextStyle(color: Color(0xff000077), fontSize: 22),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                          children: [

                                CategoryListShow(
                                    categories: categoryList,
                                  onCategoryTap: (CategoryModel category) {
                                    cubit.updateCategory(category);
                                  },
                                )

                          ]
                        ),

                          const SizedBox(
                            height: 12,
                            width: 20,
                          ),
                          StandardButton(
                            height: kToolbarHeight,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            text: 'Lọc',
                          ),
                        ],

                        )
                      )
                   )
            ]
          )
        )
    );
  }
  Widget makeFilterIcon() {
    const height = 4.5;
    const space = 3.5;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(

          width: 42,
          height: height,
          color: const Color(0xff000044).withOpacity(0.4),
        ),
        const SizedBox(
          height: space,
        ),
        Container(
          width: 28,
          height: height,
          color: const Color(0xff000044).withOpacity(0.8),
        ),
        const SizedBox(
          height: space,
        ),
        Container(
          width: 10,
          height: height,
          color: const Color(0xff000044).withOpacity(1),
        ),
      ],
    );
  }
}

