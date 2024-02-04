import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Book')
      ),
      body: Center(
        child: Padding(
          padding:EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Book Title'
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Author'
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Add Book'),
              )
            ]
          )
        )
      )

    );

  }
}