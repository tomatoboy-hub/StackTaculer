import 'package:flutter/material.dart';
import './scan_screen.dart';
import '../database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/services.dart';
import '../common/Footer.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen>  {
  final _isbnController = TextEditingController();
  String _isbn = ''; // スキャンしたISBNコードを保持する状態変数
  Map<String, dynamic> book = {}; // 書籍情報を一時的に保持する変数
  bool _isLoading = false; // 書籍情報の取得中を示すフラグ

  @override
  void dispose() {
    _isbnController.dispose(); // コントローラのクリーンアップ
    super.dispose();
  }

  Future<void> _scanISBN() async {
    var result = await BarcodeScanner.scan();
    setState(() {
      _isbn = result.rawContent; // スキャン結果を状態変数に保存
    });
  }
  // スキャンしたISBNで書籍情報を取得するメソッド
  Future<void> _fetchBookInfo(String isbn) async {
    setState(() {
      _isLoading = true; // ローディング開始
    });
    final String apiUrl = 'https://api.openbd.jp/v1/get?isbn=$isbn';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data');
        if (data.isNotEmpty && data[0] != null) {
          setState(() {
            book = {
              'title': data[0]['summary']['title'] ?? 'No title',
              'author': data[0]['summary']['author'] ?? 'No author',
              'price' : data[0]['onix']['ProductSupply']['SupplyDetail']['Price'][0]['PriceAmount'].toString() ?? "No price",
              'series' : data[0]['summary']['series']?? 'No booktype',
              // その他の必要な書籍情報を追加
            };
            _isLoading = false; // ローディング終了
          });
          print('Book info: $book');
        } else {
          print("No data found for ISBN: $_isbn");
          setState(() {
            _isLoading = false; // ローディング終了
            print("No data found for ISBN: $_isbn");
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // ローディング終了
        print("Error fetching book data: $e");
      });
    }
  }
  // 取得した書籍情報をデータベースに追加するメソッド
  Future<void> _addBookToDatabase() async {
    // データベースへの追加処理を実装
    await DatabaseHelper.instance.insert({
      DatabaseHelper.columnTitle: book['title'],
      DatabaseHelper.columnAuthor: book['author'],
      DatabaseHelper.columnCategory: book['series'],
      DatabaseHelper.columnPrice: book['price'],
      DatabaseHelper.columnAddedTime: DateTime.now().toString(),
      // その他のカラムに対応するデータを追加
    });
    Navigator.pop(context); // データ追加後に前の画面に戻る
  }


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
              if (_isLoading) CircularProgressIndicator(),
              TextField(
                controller: _isbnController,
                decoration: InputDecoration(
                  labelText: 'ISBN Code',
                  hintText: 'Enter ISBN manually or scan',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final isbn = _isbnController.text.trim();
                  if (isbn.isNotEmpty) {
                    _fetchBookInfo(isbn);
                  }
                },
                child: Text('Fetch Book Info'),
              ),
              ElevatedButton(
                onPressed: _scanISBN,
                child: Text('Scan ISBN'),
              ),
              if (_isbn.isNotEmpty) Text('Scanned ISBN: $_isbn'),
              ElevatedButton(
                onPressed: _isbn.isNotEmpty ? () =>  _fetchBookInfo(_isbn) : null,
                child: Text('Fetch Book Info'),
              ),

              if (book.isNotEmpty) ...[
                Text('Title: ${book['title']}'),
                Text('Author: ${book['author']}'),
                Text('Price: ${book['price']}'),
                Text('Series: ${book['series']}'),
                ElevatedButton(
                  onPressed: _addBookToDatabase,
                  child: Text('Add to Database'),
                ),


              ],
              ElevatedButton(
                onPressed: () async {
                  await DatabaseHelper.instance.resetDatabase();
                  final snackBar = SnackBar(
                    content: Text('Database has been reset.'),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text('Reset Database'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // ボタンの背景色
                ),
              ),
            ]
          )
        )
      ),
      bottomNavigationBar: Footer(),
    );

  }
}