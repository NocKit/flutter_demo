import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List counter = [];
  var page = 1;
  var pageSize = 10;
  var searchVal = {
    'name': '',
    'address': ''
  };

  @override
  initState() {
    super.initState();
    getHttp();
  }

  getHttp() async {
    try {
      var response = await Dio().get('http://127.0.0.1:1080/list',
          queryParameters: {'search': jsonEncode(searchVal),'page':page,'pageSize':pageSize});
      print(response.data['data']['list']);
      counter = response.data['data']['list'];
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('DataTable Demo'),
        ),
        body: ListView(
          children: [_createDataTable()],
        ),
      ),
    );
  }

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('日期')),
      DataColumn(label: Text('姓名')),
      DataColumn(label: Text('地址'))
    ];
  }

  List<DataRow> _createRows() {
    return counter
        .map((book) => DataRow(cells: [
              DataCell(Text(book['date'])),
              DataCell(Text(book['name'])),
              DataCell(Text(book['address']))
            ]))
        .toList();
  }
}
