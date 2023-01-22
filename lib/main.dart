import 'package:flutter/material.dart';
import 'package:memo_app/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _memoList = <String>[];
  var _currentIndex = -1;
  bool _loading = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void loadMemoList() {
    SharedPreferences.getInstance().then((prefs) {
      const key = "memo-list";
      if(prefs.containsKey(key)) {
        _memoList = prefs.getStringList(key)!;
      }
      setState(() {
        _loading =false;
      });
    });
  }

  void storeMemoList() async {
    final prefs = await SharedPreferences.getInstance();
    const key = "memo-list";
    final success = await prefs.setStringList(key, _memoList);
    if(!success){
      debugPrint("Failed to store value");
    }
  }

  void _addMemo() {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.clear();
    setState(() {
      _memoList.add("");
      _currentIndex = _memoList.length - 1;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return Edit(_memoList[_currentIndex], _onChanged);
          }
      ));
    });
  }

  void _onChanged(String text) {
    setState(() {
      _memoList[_currentIndex] = text;
      storeMemoList();
    });
  }

  Widget _buildList() {
    final itemCount = _memoList.isEmpty ? 0 : _memoList.length * 2 - 1;
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: itemCount,
      itemBuilder: (BuildContext context, i) {
        if (i.isOdd) return Divider(height: 2);
        final index = (i/2).floor();
        final memo = _memoList[index];
        return _buildWrapperRow(memo, index);
      },

    );
  }
  
  Widget _buildWrapperRow(String content, int index) {
    return Dismissible(
        background: Container(color: Colors.red),
        key: Key(content),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            _memoList.removeAt(index);
            storeMemoList();
          });
        },
        child: _buildRow(content, index),
    );
  }

  Widget _buildRow(String content, int index){
    return ListTile(
      title: Text(
        content,
        style: _biggerFont,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        _currentIndex = index;
        Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return Edit(_memoList[_currentIndex], _onChanged);
        }));
      },
    );
  }


  @override
  void initState() {
    super.initState();
    loadMemoList();
  }

  @override
  Widget build(BuildContext context) {

    const title = "Home";

    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMemo,
        tooltip: "New Memo",
        child: const Icon(Icons.add),
      ),
    );
  }
}
