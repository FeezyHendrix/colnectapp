import 'package:flutter/material.dart';
import 'api.dart';
// import 'models/messages.dart'

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Messages'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map _messages = {};
  ScrollController _scrollController = new ScrollController();
  var _initial_load = false;

  @override
  void didChangeDependencies() {
    if (!_initial_load) {
      ApiProvider.fetchMessage('').then((value) {
        _messages = value;
        // print(value);
        // fetchMoreMessages();
        setState(() {
          _initial_load = true;
        });
      });
    }

    super.didChangeDependencies();
  }

  

  Widget _buildMessageUI() {
    return ListView.builder(
      itemExtent: null,
      itemCount: _messages['messages'].length,
      itemBuilder: (BuildContext context, i) {
        // print(i);/
        // if (i.isOdd) return Divider();

        final item = _messages['messages'][i];
        print(item);
        final index = i ~/ 2;
     
        if (index >= _messages['messages'].length) {
          print('fetching');
          fetchMoreMessages();
        }

        return _buildSingleMessage(index, item, context);
      },
    );
  }

  Widget _buildSingleMessage(index, item, context) {
    return Container(
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Message dismissed")));
            _messages['messages'].removeAt(index);
          });
        },
        background: Container(color: Colors.red),
        child: ListTile(
            title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'http://message-list.appspot.com/${item['author']['photoUrl'].toString()}'),
              radius: 35.0,
            ),
            SizedBox(width: 20,),
            Column(children: <Widget>[
              Text('${item['author']['name'].toString()}', textAlign: TextAlign.left,),
              Container(child: Text('${item['content'].toString()}', overflow:  TextOverflow.ellipsis, maxLines: 1, softWrap: true), width: 250,),
            ],)
          ],
        )), 
      ),
    );
  }

  void fetchMoreMessages() async {
    final pageToken = _messages['pageToken'];
    ApiProvider.fetchMessage(pageToken).then((value) {
      print('fetch more');
      print(value);
      setState(() {
        _messages['messages'].addAll(value.messages);
        _messages['pageToken'] = value.pageToken;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          height: double.infinity,
          child: _initial_load
              ? _buildMessageUI()
              : Center(
                  child: new CircularProgressIndicator(),
                )),
    );
  }
}
