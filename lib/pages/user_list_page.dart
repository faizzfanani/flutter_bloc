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
                return new ItemList(
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
class ItemList extends StatelessWidget {
  final List users;
  int counter = 10;

  ItemList({this.users});
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: users == null ? 0 : users.length,
      itemBuilder: (context, i) {
        return new Container(
            padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, right: 1.0),
            child: new GestureDetector(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new Detail(username: users[i]['login']))),
              child: new Card(
                child: new ListTile(
                  title: new Text(users[i]['login']),
                  leading: new CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage('${users[i]['avatar_url']}'),
                  ),
                  subtitle: new Text("${users[i]['html_url']}"),
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
