import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();

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
                  controller: _controller2,
                decoration: InputDecoration(
                  labelText: 'Author'
                ),
              ),
              TextField(
                controller: _controller3,
                decoration: InputDecoration(
                    labelText: 'isbn'
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context,  _controller3.text, );
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