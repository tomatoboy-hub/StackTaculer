import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  final _controller = TextEditingController();
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
                controller: _controller,
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
                  Navigator.pop(context, _controller.text);
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