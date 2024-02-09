import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _isbnController = TextEditingController();
  String _bookInfo = '';

  Future<void> _getBookInfo(String isbn) async {
    final String apiUrl = 'https://api.openbd.jp/v1/get?isbn=${Uri.encodeComponent(isbn)}';

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);

        if (data.isNotEmpty) {
          final Map<String, dynamic> bookData = data[0];

          // ここでbookDataから必要な情報を抽出し、表示などの処理を行います
          // 以下は例として、タイトルと著者の取得例です
          final String title = bookData['summary']['title'] ?? 'No title';
          final String author = bookData['summary']['author']?? 'No author';
          String pubdate = bookData['summary']['pubdate']?? 'No pubdate';
          String pricenum = bookData['onix']['ProductSupply']['SupplyDetail']['Price'][0]['PriceAmount'].toString()?? 'No price';
          String pricetype = bookData['onix']['ProductSupply']['SupplyDetail']['Price'][0]['CurrencyCode']?? 'No pricetype';
          String booktype = bookData['summary']['series']?? 'No booktype';
          if (pubdate.length == 4) {
            pubdate =pubdate + "年";
          } else if (pubdate.length == 6) {
            pubdate =pubdate.substring(0, 4) + "年" + pubdate.substring(4, 6) + "月";
          } else if (pubdate.length == 8) {
            pubdate =pubdate.substring(0, 4) + "年" + pubdate.substring(4, 6) + "月" + pubdate.substring(6, 8) + "月";
          }
          String price =pricenum+pricetype;
          setState(() {
            _bookInfo = 'Title: $title\n Author:$author\n pubdate:$pubdate\n price :$price\n booktype :$booktype';
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
              decoration: InputDecoration(labelText: 'Enter ISBN10'),
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