import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  var searchVal = {'name': '', 'address': ''};

  @override
  initState() {
    super.initState();
    getHttp();
  }

  getHttp() async {
    try {
      var response = await Dio().get('http://melispok.tk:1080/list',
          queryParameters: {
            'search': jsonEncode(searchVal),
            'page': page,
            'pageSize': pageSize
          });
      print(response.data['data']['list']);
      counter = response.data['data']['list'];
      setState(() {

      });
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
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                _flushButton(),
              ],
            ),
            _createDataTable()
          ],
        ),
      ),
    );
  }

  _flushButton() {
    return RaisedButton(
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        getHttp();
      },
      child: Text("刷新"),
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
    return
      counter.map((item) => DataRow(
              cells:[
                DataCell(Text(item['date']),
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: item['date'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },),
                DataCell(Text(item['name']),
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: item['name'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black45,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },),
                DataCell(
                  Text(item['address']),
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: item['address'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black45,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                )
              ],
            ))
        .toList();
  }
}
