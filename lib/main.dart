import 'package:agora_call/call_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';

Future<void> main() async {
  runApp(const MyApp());

  await FlutterLogs.initLogs(
    logLevelsEnabled: [
      LogLevel.INFO,
      LogLevel.WARNING,
      LogLevel.ERROR,
      LogLevel.SEVERE
    ],
    timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
    directoryStructure: DirectoryStructure.FOR_DATE,
    logTypesEnabled: ['device', 'network', 'errors'],
    logFileExtension: LogFileExtension.LOG,
    logsWriteDirectoryName: 'Logs',
    logsExportDirectoryName: 'Logs/Exported',
    debugFileOperations: true,
    isDebuggable: true,
    enabled: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  TextEditingController textEditingController = TextEditingController();
  String message = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: textEditingController,
                autocorrect: false,
                enableSuggestions: false,
                onChanged: (value) {},
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  isDense: true,
                  hintText: 'RoomId',
                  hintStyle: TextStyle(color: Colors.grey[60]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[50]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[50]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              if (message.isNotEmpty) Text(message),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: Text('Create Room'),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => CallPage(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: Text('Join Room'),
                onPressed: () async {
                  if (textEditingController.text.isEmpty) {
                    setState(() {
                      message = 'Please enter RoomId';
                    });
                    return;
                  }

                  await Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => CallPage(
                        roomId: textEditingController.text,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
}
