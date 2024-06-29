import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking/objects/models/transaction_model.dart';
import 'package:money_tracking/objects/models/category_model.dart';
import 'package:money_tracking/presentation/resources/app_colors.dart';

class PieChartScreen extends StatefulWidget {
  final List<TransactionModel> currentList;
  final List<CategoryModel> categoryList;
  final bool isShowPercent;
  final BigInt total;
  final DateTime beginDay;
  final DateTime endDay;
  PieChartScreen({
    Key? key,
    required this.currentList,
    required this.isShowPercent,
    required this.categoryList,
    required this.total,
    required this.beginDay,
    required this.endDay,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => PieChartScreenState();
}

class PieChartScreenState extends State<PieChartScreen> {
  // Lấy danh sách các màu cho các thể loại để hiển thị lên pie chart.
  List<Color> colors = AppColors.pieChartCategoryColors;

  // Tổng số tiền.
  late BigInt total;

  // Biến để lấy vị trí đã chạm vào pie chart.
  int touchedIndex = -1;

  // Biến để hiển thị phần trăm pie chart.
  late bool isShowPercent;

  // Danh sách transactions.
  late List<TransactionModel> transactionList;

  // Danh sách các danh mục của các transaction.
  late List<CategoryModel> categoryList;

  //Ngày bắt đầu
  late DateTime beginDay;

  //Ngày kết thúc
  late DateTime endDay;

  // Danh sách tổng số tiền của từng danh mục.
  List<BigInt> info = [];


  @override
  void initState() {
    super.initState();

    // Lấy các giá trị từ tham số đầu vào.
    transactionList = widget.currentList;
    categoryList = widget.categoryList;
    total = widget.total;
    isShowPercent = widget.isShowPercent;
    beginDay=widget.beginDay;
    endDay=widget.endDay;
    // Hàm lấy thông tin tổng số tiền của từng danh mục.
    generateData(categoryList, transactionList);
  }
  @override
  void didUpdateWidget(PieChartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Kiểm tra xem beginDay và endDay có thay đổi không
    if (widget.beginDay != oldWidget.beginDay || widget.endDay != oldWidget.endDay) {
      setState(() {
        transactionList = widget.currentList;
        categoryList = widget.categoryList;
        total = widget.total;
        isShowPercent = widget.isShowPercent;
        beginDay=widget.beginDay;
        endDay=widget.endDay;
        info.clear();
        // Hàm lấy thông tin tổng số tiền của từng danh mục.
        generateData(categoryList, transactionList);
      });
    }
  }
  // Hàm lấy thông tin tổng số tiền của từng danh mục.
  void generateData(
      List<CategoryModel> categoryList, List<TransactionModel> transactionList) {
    // Đảm bảo danh sách thông tin được làm trống.
    info.clear();

    // Thực thi tính toán các thông tin trên tất cả danh mục hiện có.
    categoryList.forEach((element) {
      info.add(calculateByCategory(element, transactionList));
    });
  }

  // Hàm tính toán tổng số tiền của từng danh mục trong danh sách transactions.
  BigInt calculateByCategory(
      CategoryModel category, List<TransactionModel> transactionList) {
    BigInt sum = BigInt.zero;
    transactionList.forEach((element) {
      if(element.date.compareTo(beginDay)>=0 && element.date.compareTo(endDay)<=0)
      {
        if (element.category.name == category.name)
          sum += element.amount;
      }
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.scale(
          scale: isShowPercent ? 1.6 : 1,
          child: Stack(children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      borderData: FlBorderData(
                        show: false,
                      ),
                      startDegreeOffset: 270,
                      sectionsSpace: 0,
                      centerSpaceRadius: 17,
                      sections: showingSubSections()),
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 1.3,
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      borderData: FlBorderData(
                        show: false,
                      ),
                      startDegreeOffset: 270,
                      sectionsSpace: 0,
                      centerSpaceRadius: 25,
                      sections: showingSections()),
                ),
              ),
            ),
          ]),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: isShowPercent ? 50 : 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    categoryList.length,
                        (index) =>
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: index < colors.length ? colors[index] : AppColors.pieChartExtendedCategoryColor,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                categoryList[index].name,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: index < colors.length ? colors[index] : AppColors.pieChartExtendedCategoryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                  )
              ),
              if (isShowPercent)
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      categoryList.length,
                          (index) =>
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              ((info[index] / total) * 100).toStringAsFixed(2) + '%',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: index < colors.length ? colors[index] : AppColors.pieChartExtendedCategoryColor,
                              ),
                            ),
                          ),
                    )),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return (categoryList.isNotEmpty)
        ? List.generate(categoryList.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 28.0 : 18.0;
      final widgetSize = isTouched ? 40.0 : 20.0;
      final double fontTitleSize = isTouched ? 17 : 8.5;

      if (total == 0)
        total = BigInt.from(1);
      var value = ((info[i] / total) * 100);

      return PieChartSectionData(
        color: i < colors.length ? colors[i] : AppColors.pieChartExtendedCategoryColor,
        value: value == 0 ? 1 : value,
        showTitle: isShowPercent,
        title: value.toStringAsFixed(2) + '%',
        titlePositionPercentageOffset: isTouched ? 2.3 : 2.20,
        radius: radius,
        titleStyle: TextStyle(
            color: i < colors.length ? colors[i] : AppColors.pieChartExtendedCategoryColor,
            fontSize: fontTitleSize,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat'),
        badgeWidget: Badge(
          categoryList[i].getIcon(), // category icon.
          size: widgetSize,
          borderColor: i < colors.length ? colors[i] : AppColors.pieChartExtendedCategoryColor,
        ),
        badgePositionPercentageOffset: .98,
      );
    })
        : List.generate(1, (i) {
      return PieChartSectionData(
        color: AppColors.boxBackgroundColor,
        value: 100,
        showTitle: false,
        radius: 15.0,
      );
    });
  }

  List<PieChartSectionData> showingSubSections() {
    return (categoryList.length != 0)
        ? List.generate(categoryList.length, (i) {
      final radius = 8.0;

      if (total == 0)
        total = BigInt.from(1);
      var value = ((info[i] / total) * 100);

      return PieChartSectionData(
        color: i < colors.length
            ? colors[i].withOpacity(0.4)
            : AppColors.pieChartExtendedCategoryColor.withOpacity(0.4),
        value: value == 0 ? 1 : value,
        showTitle: false,
        radius: radius,
      );
    })
        : List.generate(1, (i) {
      return PieChartSectionData(
        color: AppColors.boxBackgroundColor,
        value: 100,
        showTitle: false,
        radius: 15.0,
      );
    });
  }
}

class Badge extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color borderColor;

   Badge(this.icon, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            offset:  Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      //padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Icon(icon,size: 15,),
      ),
    );
  }
}