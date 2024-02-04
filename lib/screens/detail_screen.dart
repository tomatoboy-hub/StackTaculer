import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final  String bookTitle;

  DetailScreen ({required this.bookTitle});

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
            Text('Book $bookTitle is selected.'),
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