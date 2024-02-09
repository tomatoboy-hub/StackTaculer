import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'add_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class HomeScreen extends StatefulWidget{

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  final List<Map<String,dynamic>> _books = [];
  Map<String,dynamic> book = {};
  void _addBook(Map <String,dynamic> book){
    setState(() {
      _books.add(book);
    });
  }
  Future<void> _getBookInfo(String isbn) async {
    final String apiUrl = 'https://api.openbd.jp/v1/get?isbn=${Uri.encodeComponent(isbn)}';

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final Map<String, dynamic> bookData = data[0];
          // ここでbookDataから必要な情報を抽出し、表示などの処理を行います
          // 以下は例として、タイトルと著者の取得例です
          final String title = bookData['summary']['title'] ?? 'No title';
          final String author = bookData['summary']['author']?? 'No author';
          String pubdate = bookData['summary']['pubdate']?? 'No pubdate';
          String pricenum = bookData['onix']['ProductSupply']['SupplyDetail']['Price'][0]['PriceAmount']?? 'No price';
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
            book = {'Title': title,'Author':author,'pubdate':pubdate ,'price':price ,'booktype' :booktype};
          });
        }
      } else {
        setState(() {
          book = {'Title': 'error','Author':'error','pubdate':'error' ,'price':'error' ,'booktype' :'error'};
        });
      }
    } catch (e) {
      setState(() {
        book = {
          'Title': 'error',
          'Author': 'error',
          'pubdate': 'error',
          'price': 'error',
          'booktype': 'error'
        };
      });
    }
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
              title: Text(_books[index]["Title"]),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(book: _books[index]),
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
          final String? isbn = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
          print(isbn);
          if (isbn != null){
            await _getBookInfo(isbn);
            _addBook(book);//addbook機能してない理由不明
            print(_books);
          }
        },
      )
    );
  }

}