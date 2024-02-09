import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';

class GyroCubeScreen extends StatefulWidget {
  @override
  _GyroCubeScreenState createState() => _GyroCubeScreenState();
}

class _GyroCubeScreenState extends State<GyroCubeScreen> {
  late Scene _scene;
  late Object _cubeObject;
  double _x = 0.0, _y = 0.0, _z = 0.0; // オブジェクトの位置を追跡
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
          Text('X: $_x, Y: $_y, Z: $_z'),// オブジェクトの位置を表示
        ],
      ),
    );
  }
  void _onSceneCreated(Scene scene) {
    _scene = scene;
    _cubeObject = Object(fileName:'assets/book.obj');
    _scene.world.add(_cubeObject);

    gyroscopeEventsSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (!mounted) return;
      setState(() {
        // ジャイロスコープデータをオブジェクトの回転に適用し、位置を更新します。
        _cubeObject.rotation.x += event.x;
        _cubeObject.rotation.y += event.y;
        _cubeObject.rotation.z += event.z;
        // 位置情報を更新
        _cubeObject.position.x += event.x;
        _cubeObject.position.y += event.y;
        _cubeObject.position.z += event.z;
        _x = _cubeObject.position.x;
        _y = _cubeObject.position.y;
        _z = _cubeObject.position.z;

      });
    });
  }
}
