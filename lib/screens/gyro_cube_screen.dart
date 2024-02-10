import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import '../common/Footer.dart';
import 'dart:math' as math;

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

  GyroscopeEvent? _currentGyroEvent;
  Vector3? _currentBookPosition;

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
        title: Text('Book Universe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Cube(
              onSceneCreated: _onSceneCreated,
            ),
          ),
          if (_currentGyroEvent != null) ...[
            Text('Gyro X: ${_currentGyroEvent!.x.toStringAsFixed(2)}'),
            Text('Gyro Y: ${_currentGyroEvent!.y.toStringAsFixed(2)}'),
            Text('Gyro Z: ${_currentGyroEvent!.z.toStringAsFixed(2)}'),
          ],
          // 最初のオブジェクトの座標を表示（もし存在すれば）
          if (_currentBookPosition != null) ...[
            Text('Book X: ${_currentBookPosition!.x.toStringAsFixed(2)}'),
            Text('Book Y: ${_currentBookPosition!.y.toStringAsFixed(2)}'),
            Text('Book Z: ${_currentBookPosition!.z.toStringAsFixed(2)}'),
          ],
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
  void _onSceneCreated(Scene scene) {
    _scene = scene;
    final radius = 5.0; // オブジェクトを配置する球の半径
    final center = Vector3(0, 0, 0); // 球の中心座標
    for (var i = 0; i < widget.booksCount; i++) {
      // 経度と緯度をランダムに選択
      final theta = math.Random().nextDouble() * 2 * math.pi; // 0 から 2π
      final phi = math.acos(2 * math.Random().nextDouble() - 1); // -1 から 1 の値をacosに通すことで、0 から π の範囲に

      // 球面座標系から直交座標系への変換
      final x = center.x + radius * math.sin(phi) * math.cos(theta);
      final y = center.y + radius * math.sin(phi) * math.sin(theta);
      final z = center.z + radius * math.cos(phi);
      var bookObject = Object(fileName: 'assets/book.obj');
      bookObject.rotation.setValues(0, -theta, 0); // オブジェクトが中心を向くように調
      bookObject.position.setValues(x, y, z);
      bookObject.updateTransform();
      print(bookObject.position.x);
      print(i);

      _scene.world.add(bookObject);
      _bookObjects.add(bookObject);
    }


    gyroscopeEventsSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (!mounted) return;
      setState(() {
        _currentGyroEvent = event;
        // ジャイロスコープデータをオブジェクトの回転に適用し、位置を更新します
        // 位置情報を更新
        if (_bookObjects.isNotEmpty) {
          _currentBookPosition = _bookObjects.first.position;
        }
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
