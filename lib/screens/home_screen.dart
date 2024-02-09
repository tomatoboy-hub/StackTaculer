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
  int _booksCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StackTaculer'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.threed_rotation),
            onPressed: () {
              if (_booksCount > 0) { // 本の数が0より大きい場合のみ遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GyroCubeScreen(booksCount: _booksCount),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.queryAllRows(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            // 本の数を更新
            _booksCount = snapshot.data!.length;
          }
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // 書籍追加画面から戻った後、リストを更新する
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
          setState(() {}); // FutureBuilderを再実行してリストを更新
        },
      ),
    );
  }
}