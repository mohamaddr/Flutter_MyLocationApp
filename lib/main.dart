import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'SideMenu.dart';
import 'map.dart';
//import 'package:credentials_helper/credentials_helper.dart';

// void main() {
//   // Credentials credentials = Credentials.fromFile('/credentials.json');

//   runApp(MyApp());
//   //print("JJJJJJJ" + credentials.apiKey);
// }

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // #docregion build

  final title = 'Startup Name Generator';
  @override
  Widget build(BuildContext context) {
    print("mykey" + DotEnv().env['MAPS_API_KEY']);
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.red,
        hintColor: Colors.white30,
      ),
      //home: RandomWords(),

      home: MyHomePage(title: 'Flutter Login'),
    );
  }
  // #enddocregion build
}

TextStyle style = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 15.0,
);

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 15.0,
  );

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 5, 5, -5),
          hintText: "Email",
          enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.white30))

          //border: OutlineInputBorder()
          ),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 5, 5, -5),
          hintText: "Password",
          enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.white30))),
    );
    final loginButon = Material(
      elevation: 12.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: 220,
        padding: EdgeInsets.fromLTRB(5, 5, 5, 1),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyMap()),
          );
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.purple[700],
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.red[900], Colors.red[300]])),
          //color: Colors.purple[700],
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "images/pro",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 50.0),
                emailField,
                SizedBox(height: 15.0),
                passwordField,
                SizedBox(
                  height: 200.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// #enddocregion MyApp

// #docregion RWS-var
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _saved = Set<WordPair>(); // NEW
  final _biggerFont = const TextStyle(fontSize: 18.0);
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    // to add the scrollbar, we need to warp the listView inside the scrollbar
    return Scrollbar(
        child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: /*1*/ (context, i) {
              if (i.isOdd) return Divider(); /*2*/

              final index = i ~/ 2; /*3*/
              if (index >= _suggestions.length) {
                _suggestions.addAll(generateWordPairs().take(1)); /*4*/
              }
              return _buildRow(_suggestions[index]);
            }));
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair); // NEW

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
      leading: CircleAvatar(
        // The url link should exactaly the same as the one definded in the yaml file.
        backgroundImage: AssetImage('images/pro.jpg'),
        radius: 30,
      ),
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        // NEW from here...
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        // NEW lines from here...
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      }, // ... to here.
    );
  }
  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        // this is childrens, incicats by []
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  // #enddocregion RWS-build
  // #docregion RWS-var
  String camelUrl = 'https://i.stack.imgur.com/YN0m7.png';

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                leading: CircleAvatar(
                  // The url link should exactaly the same as the one definded in the yaml file.
                  backgroundImage: NetworkImage(camelUrl),
                  radius: 20,
                ),
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scrollbar(
              child: Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(11.0),
              children: divided,
            ),
          ));
        }, // ...to here.
      ),
    );
  }
}
// #enddocregion RWS-var

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
