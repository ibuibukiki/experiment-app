// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:fl_chart/fl_chart.dart';

class IMUScreen extends HookConsumerWidget {
  const IMUScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final accelX = useState(0.0);
    final accelY = useState(0.0);
    final accelZ = useState(0.0);
    final gyroX = useState(0.0);
    final gyroY = useState(0.0);
    final gyroZ = useState(0.0);
    final magX = useState(0.0);
    final magY = useState(0.0);
    final magZ = useState(0.0);

    useEffect(() {
      motionSensors.accelerometerUpdateInterval =
          Duration.microsecondsPerSecond * 10; // samplingrate (test)
      motionSensors.accelerometer.listen(
        (AccelerometerEvent event) {
          accelX.value = event.x;
          accelY.value = event.y;
          accelZ.value = event.z;
        },
      );
      motionSensors.gyroscopeUpdateInterval =
          Duration.microsecondsPerSecond * 10; // samplingrate (test)
      motionSensors.gyroscope.listen(
        (GyroscopeEvent event) {
          gyroX.value = event.x;
          gyroY.value = event.y;
          gyroZ.value = event.z;
        },
      );
      motionSensors.magnetometerUpdateInterval =
          Duration.microsecondsPerSecond * 10; // samplingrate (test)
      motionSensors.magnetometer.listen(
        (MagnetometerEvent event) {
          magX.value = event.x;
          magY.value = event.y;
          magZ.value = event.z;
        },
      );
      return;
    }, []);

    final ValueNotifier<List<FlSpot>?> chartAx = useState([]);
    final ValueNotifier<List<FlSpot>?> chartAy = useState([]);
    final ValueNotifier<List<FlSpot>?> chartAz = useState([]);
    final ValueNotifier<List<FlSpot>?> chartGx = useState([]);
    final ValueNotifier<List<FlSpot>?> chartGy = useState([]);
    final ValueNotifier<List<FlSpot>?> chartGz = useState([]);
    final ValueNotifier<List<FlSpot>?> chartMx = useState([]);
    final ValueNotifier<List<FlSpot>?> chartMy = useState([]);
    final ValueNotifier<List<FlSpot>?> chartMz = useState([]);
    final cnt = useState(0.0);

    useEffect(() {
      chartAx.value?.add(FlSpot(cnt.value, accelX.value));
      if (chartAx.value!.isNotEmpty) {
        if (chartAx.value!.length > 10) {
          chartAx.value!.removeAt(0);
        }
      }
      chartAy.value?.add(FlSpot(cnt.value, accelY.value));
      if (chartAy.value!.isNotEmpty) {
        if (chartAy.value!.length > 10) {
          chartAy.value!.removeAt(0);
        }
      }
      chartAz.value?.add(FlSpot(cnt.value, accelZ.value));
      if (chartAz.value!.isNotEmpty) {
        if (chartAz.value!.length > 10) {
          chartAz.value!.removeAt(0);
        }
      }
      chartGx.value?.add(FlSpot(cnt.value, gyroX.value));
      if (chartGx.value!.isNotEmpty) {
        if (chartGx.value!.length > 10) {
          chartGx.value!.removeAt(0);
        }
      }
      chartGy.value?.add(FlSpot(cnt.value, gyroY.value));
      if (chartGy.value!.isNotEmpty) {
        if (chartGy.value!.length > 10) {
          chartGy.value!.removeAt(0);
        }
      }
      chartGz.value?.add(FlSpot(cnt.value, gyroZ.value));
      if (chartGz.value!.isNotEmpty) {
        if (chartGz.value!.length > 10) {
          chartGz.value!.removeAt(0);
        }
      }
      chartMx.value?.add(FlSpot(cnt.value, magX.value));
      if (chartMx.value!.isNotEmpty) {
        if (chartMx.value!.length > 10) {
          chartMx.value!.removeAt(0);
        }
      }
      chartMy.value?.add(FlSpot(cnt.value, magY.value));
      if (chartMy.value!.isNotEmpty) {
        if (chartMy.value!.length > 10) {
          chartMy.value!.removeAt(0);
        }
      }
      chartMz.value?.add(FlSpot(cnt.value, magZ.value));
      if (chartMz.value!.isNotEmpty) {
        if (chartMz.value!.length > 10) {
          chartMz.value!.removeAt(0);
        }
      }
      cnt.value = cnt.value + 1.0;
      return null;
    }, [accelX.value]);

    Widget graph(
      ValueNotifier<List<FlSpot>?> data,
      String xyz,
      double yMax,
      double yMin,
    ) {
      return SizedBox(
        height: screenHeight / 5,
        width: screenWidth * 3 / 5,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: data.value,
                isCurved: true,
                color: xyz == "x"
                    ? Colors.blue
                    : xyz == "y"
                        ? Colors.orange
                        : Colors.green,
              ),
            ],
            //一番上のz軸しか反応しないので
            lineTouchData: LineTouchData(enabled: false),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            maxY: yMax,
            minY: yMin,
          ),
        ),
      );
    }

    Widget label(
      ValueNotifier<double> data,
      String xyz,
    ) {
      return SizedBox(
        width: 108,
        child: Row(
          children: [
            Container(
              height: 2,
              width: 6,
              color: xyz == "x"
                  ? Colors.blue
                  : xyz == "y"
                      ? Colors.orange
                      : Colors.green,
            ),
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: xyz == "x"
                    ? Colors.blue
                    : xyz == "y"
                        ? Colors.orange
                        : Colors.green,
                shape: BoxShape.circle,
                border: Border.all(width: 0.5, color: Colors.black),
              ),
            ),
            Container(
              height: 2,
              width: 6,
              color: xyz == "x"
                  ? Colors.blue
                  : xyz == "y"
                      ? Colors.orange
                      : Colors.green,
            ),
            Text("  $xyz :", textScaleFactor: 1),
            const Spacer(),
            Text(data.value.toStringAsFixed(5), textScaleFactor: 1),
          ],
        ),
      );
    }

    Widget sensor(
      ValueNotifier<double> x,
      ValueNotifier<double> y,
      ValueNotifier<double> z,
      ValueNotifier<List<FlSpot>?> xList,
      ValueNotifier<List<FlSpot>?> yList,
      ValueNotifier<List<FlSpot>?> zList,
      double yMax,
      double yMin,
    ) {
      return Row(
        children: [
          const SizedBox(width: 6),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              label(x, "x"),
              label(y, "y"),
              label(z, "z"),
              const SizedBox(height: 24),
            ],
          ),
          const Spacer(),
          // x,y,zのグラフを重ねて表示
          Stack(
            children: [
              graph(xList, "x", yMax, yMin),
              graph(yList, "y", yMax, yMin),
              graph(zList, "z", yMax, yMin),
            ],
          )
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "IMU",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Acceleration",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          sensor(accelX, accelY, accelZ, chartAx, chartAy, chartAz, 15, -15),
          const Text(
            "Gyroscope",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          sensor(gyroX, gyroY, gyroZ, chartGx, chartGy, chartGz, 7, -7),
          const Text(
            "Magnetometer",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          sensor(magX, magY, magZ, chartMx, chartMy, chartMz, 100, -100),
        ],
      ),
    );
  }
}
