import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:document_file_save/document_file_save.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    List<int> htmlBytes = utf8.encode("<h1>Header 1</h1><p>This is sample text</p>");
    List<int> textBytes = utf8.encode("Some data");

    // save multiple files
    DocumentFileSave.saveMultipleFiles([htmlBytes, textBytes], ["htmlfile.html", "textfile.txt"], ["text/html", "text/plain"]);

    // save single file
    // DocumentFileSave.saveFile(htmlBytes, "my test html file.html", "text/html");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('document_file_save Plugin'),
        ),
        body: Center(
          child: Text('Please check file in Download folder (or Files App in iOS)'),
        ),
      ),
    );
  }

}
