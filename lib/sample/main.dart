// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:paychain_mobile/sample/Service/ProductService.dart';
import 'package:signalr_core/signalr_core.dart';
import 'dart:async';

import 'Model/ProductResponse.dart';

void main() {
  runApp(MaterialApp(
    home: ListViewCustom(),
  ));
}

class ListViewCustom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListViewCustom();
  }
}

class _ListViewCustom extends State<ListViewCustom> {
  ScrollController _scrollController = ScrollController();
  List<Product> items = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _pageSize = 20;
  int _totalRecord = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("SignalR Plugin Example App"),
        ),
        body: ListView.builder(
          controller: _scrollController,
          itemCount: items.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < items.length) {
              return ListTile(title: Text(items[index].name));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  @override
  void initState() {
    _fetchInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _fetchMoreData();
    }
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
    });

    //await Future.delayed(Duration(seconds: 1));
    ProductResponse result =
        await ProductService.getProduct(_currentPage, _pageSize);
    _totalRecord = result.totalRecord;
    items.addAll(result.data);

    setState(() {
      _currentPage++;
      _isLoading = false;
    });
  }

  Future<void> _fetchMoreData() async {
    if (_isLoading || items.length >= _totalRecord) return;

    setState(() {
      _isLoading = true;
    });

    //await Future.delayed(Duration(seconds: 1));
    print("current page: ${_currentPage}");
    ProductResponse result =
        await ProductService.getProduct(_currentPage, _pageSize);
    if (result.statusCode == 200) {
      if (result.status == false) {
        //show error message
        //return;
      }
      if (result.status == true) {
        if (result.message != "") {
          //show message
        }
        setState(() {
          items.addAll(result.data);
          _currentPage++;
          _isLoading = false;
        });
      }
    }

    //write method check status
    if (result.statusCode == 401) {
      //redirect to login screen;
    }
    //show error default message

    print("New items added. Total items: ${items.length}");
  }
}
