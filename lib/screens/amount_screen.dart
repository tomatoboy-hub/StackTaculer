import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import '../common/Footer.dart';

class AmountScreen extends StatefulWidget {
  @override
  _AmountScreenState createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  late Future<double> _totalAmount;
  late Future<List<Map<String, dynamic>>> _monthlyAmounts;

  @override
  void initState() {
    super.initState();
    _totalAmount = DatabaseHelper.instance.getTotalAmount();
    _monthlyAmounts = DatabaseHelper.instance.getMonthlyAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amount Overview'),
      ),
      body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                FutureBuilder<double>(
                  future: _totalAmount,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      double? aaa = snapshot.data;
                      int? totalyen = aaa?.toInt();
                      return Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide()
                                )
                            ),
                            child: Text('Total Amount', style: TextStyle(fontSize: 15),),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text('${totalyen}円', style:  TextStyle(fontSize: 25),),
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _monthlyAmounts,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data![index];
                          return  Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide()
                                )
                            ),
                            child: ListTile(
                              title: Text('${item['month']}'),
                              trailing: Text('${item['monthlyTotal']}',style: TextStyle(fontSize: 15),),
                            ),
                          );
                          /*
                        return ListTile(
                          title: Text('${item['month']}'),
                          trailing: Text('${item['monthlyTotal']}'),
                        );
                        */
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _monthlyAmounts,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<BarChartGroupData> barGroups = [];
                      // snapshot.dataから棒グラフのデータを生成
                      for (var i = 0; i < snapshot.data!.length; i++) {
                        final monthData = snapshot.data![i];
                        final month = monthData['month']; // 月（表示用）
                        final total = monthData['monthlyTotal']; // その月の合計金額

                        final barGroup = BarChartGroupData(
                          x: i,

                          barRods: [
                            BarChartRodData(
                              y: total.toDouble(),
                              colors: [Colors.lightBlueAccent, Colors.greenAccent],
                            ),

                          ],
                          //showingTooltipIndicators: [0],
                        );

                        barGroups.add(barGroup);
                      }

                      final barChartData = BarChartData(
                        barGroups: barGroups,
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (context, value) => const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            margin: 16,
                            getTitles: (double value) {
                              // 月の名前を返すロジック
                              return snapshot.data![value.toInt()]['month'];
                            },
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                      );

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200.0, // 明確な高さを指定
                          child: BarChart(barChartData),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // ロード中はインジケーターを表示
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          )

      ),
      bottomNavigationBar: Footer(),
    );
  }
}