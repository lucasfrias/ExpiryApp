import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_app/main_page.dart';
//import 'package:flutter_app/Scanner.dart';
import 'package:flutter_app/FoodItemsScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final  Color mainBlack = Color(0xFF383838);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: mainBlack
        ),
    home: MainPage()
    );
  }
}


/// Everything below is a test and used as a sample for navigating different pages. Might create a bottom navigation bar.
class FirstScreen extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Barcode Scanner"),
        ),
        body: new Checkbox(
            value: false,
            onChanged: (bool newValue) {
              Navigator.push(
                ctxt,
                new MaterialPageRoute(builder: (ctxt) => new RandomWordsPage()),
              );
            }
        )
    );
  }

}

class RandomWordsState extends State<RandomWords> {
  @override
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
      floatingActionButton: FloatingActionButton(
        child: Text("Go back"),
        onPressed: (){
          Navigator.push(context, new MaterialPageRoute(builder: (ctxt) => new FirstScreen()));
        },
      ),
    );
  }
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}

class RandomWordsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        //home: RandomWords(),
        home: RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}