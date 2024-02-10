import 'package:flutter/material.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/services.dart';


class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String readData = "";
  String typeData = "";

  Future scan() async {
    try {
      var scan = await BarcodeScanner.scan();
      setState(() {
        readData = scan.rawContent;
        typeData = scan.format.name;
      });
      print('Read Data: $readData');
      print('Type Data: $typeData');
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          readData = 'Camera permissions are not valid.';
        });
      } else {
        setState(() => readData = 'Unexplained error : $e');
      }
    } on FormatException {
      setState(() => readData = 'Failed to read (I used the back button before starting the scan).');
    } catch (e) {
      setState(() => readData = 'Unknown error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bar Codes scan')),
      body: Center(
        child: ElevatedButton(
          onPressed: scan,
          child: Text('バーコードを読み込む'),
        ),
      ),
    );
  }
}