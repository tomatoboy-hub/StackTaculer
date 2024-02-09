import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final  Map<String,dynamic> book;

  DetailScreen ({required this.book});

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
            Text('Book $book is selected.'),
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