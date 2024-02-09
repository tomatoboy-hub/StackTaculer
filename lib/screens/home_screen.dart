import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'add_screen.dart';
import 'gyro_cube_screen.dart';
import 'package:stacktaculer/database_helper.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  Future<List<Map<String,dynamic>>> _fetchBooks() async {
    return await DatabaseHelper.instance.queryAllRows();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StackTaculer'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.threed_rotation),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GyroCubeScreen()),
              );
            },
          ),
        ],
      ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchBooks(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var book = snapshot.data![index];
                  return ListTile(
                    title: Text(book['title']), // 'title'はデータベースのカラム名に合わせてください
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(bookTitle: book['title']),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return CircularProgressIndicator();
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