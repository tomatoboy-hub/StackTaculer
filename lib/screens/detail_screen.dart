import 'package:flutter/material.dart';
import '../book.dart'; // Bookクラスを定義したファイル

class DetailScreen extends StatelessWidget {
  final Book book;
  final VoidCallback onDelete; // onDeleteプロパティを追加
  const DetailScreen({Key? key, required this.book, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Title: ${book.title}'),
            Text('Author: ${book.author}'),
            Text('Category: ${book.category}'),
            Text('Added on: ${book.addedTime}'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onDelete, // 削除ボタン
        tooltip: 'Delete',
        child: Icon(Icons.delete),
      ),
    );
  }
}