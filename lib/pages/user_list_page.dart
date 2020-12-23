import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/utils/API.dart';
import 'user_detail_page.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

class UserList extends StatelessWidget {
  final String api = Github.getAllUsers;

  ///Load user list
  Future<List> getData() async {
    final response = await http.get("$api");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          "Unable to load data,\nplease check your network connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Github Users"),
          backgroundColor: Color(0xff33313b),
        ),
        body: Container(
          child: new FutureBuilder<List>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new _ItemList(
                  users: snapshot.data,
                );
              }
              if (snapshot.hasError) {
                return new Center(
                  child: new Text(
                      "Unable to load data,\nplease check your network connection",
                      textAlign: TextAlign.center),
                );
              } else {
                return _buildLoadingPage();
              }
            },
          ),
        ));
  }
}

///Set up user list
class _ItemList extends StatefulWidget {
  final List users;

  const _ItemList({Key key, this.users}) : super(key: key);
  @override
  __ItemListState createState() => __ItemListState();
}

class __ItemListState extends State<_ItemList> {
  int counter = 10;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.users.length == 0
          ? 0
          : widget.users.length <= counter
              ? widget.users.length
              : counter + 1,
      itemBuilder: (context, i) {
        return (i >= counter)
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    counter += 10;
                  });
                },
                child: Container(
                  height: 45,
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff33313b), Color(0xff4592af)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Load More',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            : new Container(
                padding:
                    const EdgeInsets.only(top: 1.0, bottom: 1.0, right: 1.0),
                child: new GestureDetector(
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new Detail(username: widget.users[i]['login']))),
                  child: new Card(
                    child: new ListTile(
                      title: new Text(widget.users[i]['login']),
                      leading: new CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage('${widget.users[i]['avatar_url']}'),
                      ),
                      subtitle: new Text("${widget.users[i]['html_url']}"),
                    ),
                  ),
                ));
      },
    );
  }
}

Widget _buildLoadingPage() => Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
