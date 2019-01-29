import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Currency Converter'),
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

  String valorInicial = "BRL";
  double valorFinal = 0.0;
  String valorCorrente = "valor";
  String jsonString = "";

  final myController = TextEditingController();

  Future<String> getData() async{
    http.Response response = await http.get(
        Uri.encodeFull("http://free.currencyconverterapi.com/api/v5/convert?q=USD_BRL&compact=y"),
        headers: {
          "Accept" : "Application/json"
        }
    );

    setState(() {
      jsonString = response.body;
      Map<String, dynamic> bruto = jsonDecode(jsonString);
      //print('Howdy, ${bruto['USD_BRL']}!');
      //print('Howdy, ${bruto['USD_BRL']['val']}!');
      valorCorrente = bruto['USD_BRL']['val'].toString();
      //print('valorCorrente, ${valorCorrente}');
    });

    return "success";
  }

  void initState(){
    this.getData();
  }

  void calcular(){
    setState(() {
      if(myController.text == "") {
        myController.text = "1";
      }
      valorInicial = myController.text;
      valorFinal = double.parse(valorInicial).toDouble() * double.parse(valorCorrente).toDouble();
    });
  }

  Widget buildButton(){
    return new Expanded(
     child: new MaterialButton(
        child: new Text("convert"),
        onPressed: () => calcular(),
        color: Colors.blueGrey,
        textColor: Colors.white,
        padding: new EdgeInsets.all(12.0),
     ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: new Container(
        padding: new EdgeInsets.all(48.0),
        child: new Column(
          //mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

          new Text(
            'USD to BRL',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 26.0,
              color: Colors.red,
            ),
          ),

          /*
          new Expanded(
            child: new Divider(),
          ),
          */

          new Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'USD',
                ),
                controller: myController,
                autofocus: true,
                keyboardType: TextInputType.number,
              ),
              new Row(
                children: [
                  Text(
                    '$valorFinal',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ],
              ),
            ],
          ),

          new Row(
            children: [
              buildButton(),
            ],
          ),
        ],)
      )
    );
  }
}