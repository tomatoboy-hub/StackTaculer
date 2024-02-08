import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FirstPage(),
    );
  }
}
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}
class _FirstPageState extends State<FirstPage> {
  final TextEditingController _isbnController = TextEditingController();
  String _bookInfo = '';

  Future<void> _getBookInfo(String isbn) async {
    final String apiUrl =
        'https://iss.ndl.go.jp/api/opensearch?isbn=${Uri.encodeComponent(isbn)}';

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final xml.XmlDocument document = xml.XmlDocument.parse(response.body);

        final List<xml.XmlElement> entries =
        document.findAllElements('item').toList();

        if (entries.isNotEmpty) {
          final String title =
              entries[0].findElements('title').first.value ?? 'No title';
          final String author =
              entries[0].findElements('dc:creator').first.value ?? 'No author';

          setState(() {
            _bookInfo = 'Title: $title\nAuthor: $author';
          });
        } else {
          setState(() {
            _bookInfo = 'No information found';
          });
        }
      } else {
        setState(() {
          _bookInfo = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _bookInfo = 'Error: $e';
      });
    }
  }

  String nametext='';
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Info App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _isbnController,
              decoration: InputDecoration(labelText: 'Enter ISBN'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String isbn = _isbnController.text;
                if (isbn.isNotEmpty) {
                  _getBookInfo(isbn);
                }
              },
              child: Text('Get Book Info'),
            ),
            SizedBox(height: 20),
            Text(_bookInfo),
          ],
        ),
      ),
    );
  }
}