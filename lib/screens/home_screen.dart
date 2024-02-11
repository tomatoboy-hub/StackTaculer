import 'package:flutter/material.dart';
import 'package:stacktaculer/main1%20(2).dart';
import 'detail_screen.dart';
import 'add_screen.dart';
import 'gyro_cube_screen.dart';
import 'package:stacktaculer/database_helper.dart';
import '../book.dart';
import '../common/Footer.dart';
import './amount_screen.dart';
import 'setting.dart';
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
          IconButton(
            icon: Icon(Icons.account_balance_wallet), // アイコンを選択
            onPressed: () {
              // AmountScreen に遷移する
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AmountScreen()),
              );
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
            padding: EdgeInsets.all(15),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> item = snapshot.data![index];
              // Bookオブジェクトの作成
              Book book = Book(
                id: item[DatabaseHelper.columnId] as int,
                title: item[DatabaseHelper.columnTitle] as String,
                author: item[DatabaseHelper.columnAuthor] as String,
                category: item[DatabaseHelper.columnCategory] as String,
                price : item[DatabaseHelper.columnPrice] as String,
                addedTime: item[DatabaseHelper.columnAddedTime] as String,
              );
              return Card(
                margin: const EdgeInsets.only(bottom: 10.0),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
                child: ListTile(
                  title: Text(book.title,
                  style: TextStyle(fontSize: MeApp.currentFontSize),),
                  subtitle: Text(book.author),
                  onTap: () async {
                    // DetailScreenにBookオブジェクトを渡す
                    bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(book: book,onDelete: () async {
                          await DatabaseHelper.instance.delete(book.id);
                          Navigator.pop(context, true); // 削除後にtrueを返す
                        }),
                      ),
                    )?? false;
                    if (result == true) {
                      setState(() {});
                    }
                  },
                  tileColor: Color(0xFFf2f2f2),
                  trailing: IconButton(
                    icon: Icon(Icons.delete,color: Color(0xFF401b13),),
                    onPressed: () async {
                      // データベースからアイテムを削除
                      await DatabaseHelper.instance.delete(book.id);
                      // UIを更新
                      setState(() {});
                    },
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFbf7449),
        child: Icon(Icons.add,color: Color(0xFF401b13),),
        onPressed: () async {
          // 書籍追加画面から戻った後、リストを更新する
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
          setState(() {}); // FutureBuilderを再実行してリストを更新
        },
      ),
      bottomNavigationBar: Footer(),
    );
  }
}