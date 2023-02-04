import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevices();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Printer"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<BluetoothDevice>(
              value: selectedDevice,
              hint: const Text("Select Device"),
              items: devices
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name!),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDevice = value;
                });
              }),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                printer.connect(selectedDevice!);
              },
              child: const Text("Connect")),
          ElevatedButton(
              onPressed: () {
                printer.disconnect();
              },
              child: const Text("Disconnect")),
          ElevatedButton(
              onPressed: () async {
                if ((await printer.isConnected)!) {
                  printer.printNewLine();
                  printer.printCustom("Fuck You", 0, 1);
                  printer.printNewLine();
                  printer.printNewLine();
                }
              },
              child: const Text("Print"))
        ],
      ),
    );
  }
}
