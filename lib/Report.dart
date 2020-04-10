import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SavedReport.dart';
import 'dart:async';

class ReportPage extends StatefulWidget {
  Person person = new Person();
  @override
  _ReportPageState createState() => _ReportPageState(person);

  Person getPerson() {
    return this.person;
  }
}

class _ReportPageState extends State<ReportPage> {
  Person person;
  _ReportPageState(Person person){
    this.person = person;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        color: Colors.lightGreen[400],
        width: 2000,
        height: 2000,
        alignment: Alignment.center,
        child: ListView(
          padding: const EdgeInsets.only(top: 80, left:10, right: 10),
          // mainAxisAlignment: Center;
          children: <Widget>[
            Container(
              decoration: 
                new BoxDecoration(
                  borderRadius: 
                    BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: Colors.lightGreen[200],
                ),
              height: 75,
              child: Row(
                children: <Widget>[
                  Text(" Full Name: "),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: new InputDecoration(
                        hintText: " John/Jane M. Smith"
                      ),
                      onSubmitted: (String str) {
                        person.setName(str);
                      },
                    )
                  )
                ],
              ),
            ),
            Container(
              height: 75,
              color: Colors.lightGreen[200],
              child: Row(
                children: <Widget>[
                  Text(" Age: "),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        hintText: " Enter a number here"
                      ),
                      onSubmitted: (String str) {
                        person.setAge(int.parse(str));
                      },
                    )
                  )
                ],
              ),
            ),
            Container(
              height: 75,
              color: Colors.lightGreen[200],
              child: Row(
                children: <Widget>[
                  Text(" Address + Zip Code: "),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: new InputDecoration(
                        hintText: " 123 Maple Street 92405"
                      ),
                      onSubmitted: (String str) {
                        person.setAddress(str);
                      },
                    )
                  )
                ],
              ),
            ),
            Container(
              height: 75,
              color: Colors.lightGreen[200],
              child: Row(
                children: <Widget>[
                  Text(" Condition: "),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        hintText: " Severity on scale of 1-10"
                      ),
                      onSubmitted: (String str) {
                        person.setCondition(int.parse(str));
                      },
                    )
                  )
                ],
              ),
            ),
            Container(
              height: 75,
              decoration: 
                new BoxDecoration(
                  borderRadius: 
                    BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                color: Colors.lightGreen[200],
                ),
              child: Row(
                children: <Widget>[
                  Text(" Are you 100% Certain of having COVID-19? "),
                  SizedBox(
                    width: 65,
                    child: Switch(
                      value: false, 
                      onChanged: (bool val) {
                        person.setCertainty(val);
                        },
                    )
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20),
                      
                      side: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    child: Text("SUBMIT"),
                    onPressed: () {
                      person.submit();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(person)),
                      );
                    },
                  ),
                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20),
                      
                      side: BorderSide(
                        color: Colors.red[500],
                      ),
                    ),
                    child: Text("CANCEL"),
                    onPressed: () {
                      person = null;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(null)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

