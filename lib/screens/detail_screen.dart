import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final int bookId;

  DetailScreen ({required this.bookId});

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Book $bookId'),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('Go back'),
            )
          ],
        ),
      )
    );
  }
}