import 'package:flutter/material.dart';
import './scan_screen.dart';
import '../database_helper.dart';
class AddScreen extends StatelessWidget {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _categoryController = TextEditingController();
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
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Book Title'
                ),
              ),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Author'
                ),
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category'
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await DatabaseHelper.instance.insert({
                    DatabaseHelper.columnTitle: _titleController.text,
                    DatabaseHelper.columnAuthor: _authorController.text,
                    DatabaseHelper.columnCategory: _categoryController.text,
                    DatabaseHelper.columnAddedTime: DateTime.now().toString(),
                  });
                  Navigator.pop(context);
                },
                child: Text('Add Book'),
              )
            ]
          )
        )
      )
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt), // Changed from 'add' to 'camera_alt'
        onPressed: () async {
          final String? newBookTitle = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondScreen()),
          );
        },
      ),
    );

  }
}