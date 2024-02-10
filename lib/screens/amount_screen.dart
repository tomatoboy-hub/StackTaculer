import 'package:flutter/material.dart';
import '../database_helper.dart';

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
        child: Column(
          children: <Widget>[
            FutureBuilder<double>(
              future: _totalAmount,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    title: Text('Total Amount'),
                    trailing: Text('${snapshot.data}'),
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
                      return ListTile(
                        title: Text('${item['month']}'),
                        trailing: Text('${item['monthlyTotal']}'),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
