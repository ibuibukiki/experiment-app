// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _accel = useState("");
    final _localAccel = useState("");
    final _gyro = useState("");
    final _magnet = useState("");

    useEffect(() {
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          _accel.value = "accel\n${event.x}\n${event.y}\n${event.z}";
        },
      );
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          _localAccel.value = "local accel\n${event.x}\n${event.y}\n${event.z}";
        },
      );
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          _gyro.value = "gyro\n${event.x}\n${event.y}\n${event.z}";
        },
      );
      magnetometerEvents.listen((MagnetometerEvent event) {
        _magnet.value = "magnet\n${event.x}\n${event.y}\n${event.z}";
      });
    }, []);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: null,
          toolbarHeight: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(_accel.value, style: Theme.of(context).textTheme.headline6),
            Text(_localAccel.value,
                style: Theme.of(context).textTheme.headline6),
            Text(_gyro.value, style: Theme.of(context).textTheme.headline6),
            Text(_magnet.value, style: Theme.of(context).textTheme.headline6),
          ],
        ));
  }
}
