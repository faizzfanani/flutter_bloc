import 'package:flutter/material.dart';
import 'package:flutter_bloc/model/user_model.dart';
import 'package:flutter_bloc/utils/api.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'dart:developer';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Detail extends StatefulWidget {
  final String username;

  Detail({this.username});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool _isOpen = false;
  PanelController _panelController = PanelController();
  final String api = Github.getAllUsers;

  ///load data
  Future<User> get getData async {
    final response = await http.get("$api/" + widget.username);
    if (response.statusCode == 200) {
      log('data: ${json.decode(response.body)}');
      final jsonBody = json.decode(response.body);
      return User.fromJson(jsonBody);
    } else {
      throw Exception(
          "Unable to load data,\nplease check your network connection");
    }
  }

  @override
  void initState() {
    super.initState();
    print("test");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User>(
        future: getData,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData)
            return _kill(context);
          //return _buildBody(snapshot.data, context);
          else if (snapshot.hasError)
            return _buildErrorPage(snapshot.error);
          else
            return _buildLoadingPage();
        },
      ),
    );
  }

  Widget _buildBody(User user, BuildContext context) => Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 0.65,
              child: Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(user.avatarUrl ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.35,
              child: Container(
                color: Colors.white,
              ),
            ),

            /// Sliding Panel
            SlidingUpPanel(
              controller: _panelController,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
              minHeight: MediaQuery.of(context).size.height * 0.43,
              maxHeight: MediaQuery.of(context).size.height * 0.55,
              body: GestureDetector(
                onTap: () => _panelController.close(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              panelBuilder: (ScrollController controller) =>
                  _panelBody(controller, user, context),
              onPanelSlide: (value) {
                if (value >= 0.2) {
                  if (!_isOpen) {
                    setState(() {
                      _isOpen = true;
                    });
                  }
                }
              },
              onPanelClosed: () {
                setState(() {
                  _isOpen = false;
                });
              },
            ),
          ],
        ),
      );

  Widget _buildErrorPage(error) => Material(
        child: Center(
          child: Text("ERROR: $error"),
        ),
      );

  Widget _buildLoadingPage() => Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget _kill(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          }),
    );
  }
}

/// **********************************************
/// WIDGETS
/// **********************************************
/// Panel Body
SingleChildScrollView _panelBody(
    ScrollController controller, User user, BuildContext context) {
  double hPadding = 40;

  return SingleChildScrollView(
    controller: controller,
    physics: ClampingScrollPhysics(),
    child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          height: MediaQuery.of(context).size.height * 0.22,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _titleSection(user),
              _infoSection(user),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: _additionalSection(user),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          height: 45,
          margin: EdgeInsets.only(left: 10, right: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff33313b), Color(0xff4592af)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Text(
              'Follow',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    ),
  );
}

/// Info Section
Row _infoSection(User user) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      _infoCell(title: 'Following', value: user.following),
      Container(
        width: 1,
        height: 40,
        color: Colors.grey,
      ),
      _infoCell(title: 'Followers', value: user.followers),
      Container(
        width: 1,
        height: 40,
        color: Colors.grey,
      ),
      _infoCell(title: 'Public repos', value: user.publicRepo),
    ],
  );
}

/// Info Cell
Column _infoCell({String title, String value}) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 8,
      ),
      Text(
        title,
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
      SizedBox(
        height: 8,
      ),
      Text(
        value,
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    ],
  );
}

/// Title Section
Column _titleSection(User user) {
  return Column(
    children: <Widget>[
      Text(
        user.name ?? '',
        style: TextStyle(
          fontFamily: 'NimbusSanL',
          fontWeight: FontWeight.w700,
          fontSize: 30,
        ),
      ),
      SizedBox(
        height: 8,
      ),
      Text(
        user.login ?? '',
        style: TextStyle(
          fontFamily: 'NimbusSanL',
          fontSize: 16,
        ),
      ),
      SizedBox(
        height: 2,
      ),
      Text(
        user.email ?? '',
        style: TextStyle(
          fontFamily: 'NimbusSanL',
          fontStyle: FontStyle.italic,
          fontSize: 16,
        ),
      ),
    ],
  );
}

///Additional info section
Column _additionalSection(User user) {
  return Column(
    children: <Widget>[
      _infoCell(title: 'Bio :', value: user.bio ?? '-'),
      _infoCell(title: 'Company :', value: user.company ?? '-'),
      _infoCell(title: 'Profile Url :', value: user.htmlUrl ?? '-'),
    ],
  );
}
