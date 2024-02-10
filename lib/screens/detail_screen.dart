import 'package:flutter/material.dart';
import '../book.dart'; // Bookクラスを定義したファイル
import '../common/Footer.dart';

class DetailScreen extends StatelessWidget {
  final Book book;
  final VoidCallback onDelete; // onDeleteプロパティを追加
  const DetailScreen({Key? key, required this.book, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide()
                    )
                ),
                child: Text('Title', style: TextStyle(fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(book.title, style:  TextStyle(fontSize: 20),),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide()
                    )
                ),
                child: Text('Author', style: TextStyle(fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(book.author, style:  TextStyle(fontSize: 20),),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide()
                    )
                ),
                child: Text('Category', style: TextStyle(fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(book.category, style:  TextStyle(fontSize: 20),),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide()
                    )
                ),
                child: Text('Added on', style: TextStyle(fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(book.addedTime, style:  TextStyle(fontSize: 20),),
              ),

              /*
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back'),
            ),
             */
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFbf7449),
        onPressed: onDelete, // 削除ボタン
        tooltip: 'Delete',
        child: Icon(Icons.delete,color: Color(0xFF401b13),),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}