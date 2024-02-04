import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'add_screen.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  final List<String> _books = [];

  void _addBook(String bookTitle){
    setState(() {
      _books.add(bookTitle);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StackTaculer'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _books.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Text(_books[index]),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(bookTitle: _books[index]),
                  )
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final String? newBookTitle = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
          if (newBookTitle != null){
            _addBook(newBookTitle);
          }
        },
      )
    );
  }

}