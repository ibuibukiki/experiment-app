// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fl_chart/fl_chart.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final _accelX = useState(0.0);
    final _accelY = useState(0.0);
    final _accelZ = useState(0.0);
    final _localAccel = useState("");
    final _gyro = useState("");
    final _magnet = useState("");

    useEffect(() {
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          _accelX.value = event.x;
          _accelY.value = event.y;
          _accelZ.value = event.z;
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
      return null;
    }, []);

    final ValueNotifier<List<FlSpot>?> chartAx = useState([]);
    final ValueNotifier<List<FlSpot>?> chartAy = useState([]);
    final ValueNotifier<List<FlSpot>?> chartAz = useState([]);
    final cnt = useState(0.0);

    useEffect(() {
      chartAx.value?.add(FlSpot(cnt.value, _accelX.value));
      if (chartAx.value!.isNotEmpty) {
        if (chartAx.value!.length > 10) {
          chartAx.value!.removeAt(0);
        }
      }
      chartAy.value?.add(FlSpot(cnt.value, _accelY.value));
      if (chartAy.value!.isNotEmpty) {
        if (chartAy.value!.length > 10) {
          chartAy.value!.removeAt(0);
        }
      }
      chartAz.value?.add(FlSpot(cnt.value, _accelZ.value));
      if (chartAz.value!.isNotEmpty) {
        if (chartAz.value!.length > 10) {
          chartAz.value!.removeAt(0);
        }
      }
      cnt.value = cnt.value + 1.0;
      return null;
    }, [_accelX.value]);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: null,
        toolbarHeight: 0,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("accel x : ${_accelX.value}"),
              Text("accel_y : ${_accelY.value}"),
              Text("accel_z : ${_accelZ.value}"),
              SizedBox(
                height: screenHeight / 4,
                width: screenWidth - 100,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(spots: chartAx.value),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 4,
                width: screenWidth - 100,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(spots: chartAy.value),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 4,
                width: screenWidth - 100,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(spots: chartAz.value),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
