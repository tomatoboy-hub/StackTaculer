import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import '../common/Footer.dart';

class GyroCubeScreen extends StatefulWidget {
  final int booksCount;
  GyroCubeScreen({Key? key, required this.booksCount}) : super(key: key);

  @override
  _GyroCubeScreenState createState() => _GyroCubeScreenState();
}

class _GyroCubeScreenState extends State<GyroCubeScreen> {
  late Scene _scene;
  List<Object> _bookObjects = []; // ここでオブジェクトを保持するリストを追加
  StreamSubscription<GyroscopeEvent>? gyroscopeEventsSubscription;
  @override
  void dispose() {
    // ジャイロスコープのリスナーを解除する
    gyroscopeEventsSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        title: Text('Gyro Cube'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Cube(
              onSceneCreated: _onSceneCreated,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
  void _onSceneCreated(Scene scene) {
    _scene = scene;
    for (var i = 0; i < widget.booksCount; i++) {
      var bookObject = Object(fileName: 'assets/book.obj');
      bookObject.rotation.setValues(0, 90, 0);
      bookObject.position.setValues(2, 2, -i * 2.0);
      bookObject.scale.setValues(2, 2, 2);
      bookObject.updateTransform();
      print(bookObject.position.x);
      print(i);

      _scene.world.add(bookObject);
      _bookObjects.add(bookObject);
    }


    gyroscopeEventsSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (!mounted) return;
      setState(() {
        // ジャイロスコープデータをオブジェクトの回転に適用し、位置を更新します
        // 位置情報を更新
        for (var bookObject in _bookObjects) {
          // 仮の新しい位置を計算
          double newX = bookObject.position.x + event.x;
          double newY = bookObject.position.y + event.y;
          double newZ = bookObject.position.z + event.z;

          // 許容範囲を定義
          double minX = -10.0, maxX = 10.0;
          double minY = -10.0, maxY = 10.0;
          double minZ = -10.0, maxZ = 10.0;

          // 新しい位置が範囲内にあるかチェックし、範囲外の場合は符号を反転させる
          newX = newX < minX ? -newX : (newX > maxX ? -newX : newX);
          newY = newY < minY ? -newY : (newY > maxY ? -newY : newY);
          newZ = newZ < minZ ? -newZ : (newZ > maxZ ? -newZ : newZ);

          // 更新後の位置をオブジェクトに適用
          bookObject.position.setValues(newX, newY, newZ);
          bookObject.updateTransform();
        }
      });
    });
  }
}
