import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'add_screen.dart';
import 'gyro_cube_screen.dart';
import 'package:stacktaculer/database_helper.dart';
import '../book.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StackTaculer'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.queryAllRows(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> item = snapshot.data![index];
              // Bookオブジェクトの作成
              Book book = Book(
                title: item[DatabaseHelper.columnTitle],
                author: item[DatabaseHelper.columnAuthor],
                category: item[DatabaseHelper.columnCategory],
                addedTime: item[DatabaseHelper.columnAddedTime],
              );
              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () {
                  // DetailScreenにBookオブジェクトを渡す
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(book: book),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}