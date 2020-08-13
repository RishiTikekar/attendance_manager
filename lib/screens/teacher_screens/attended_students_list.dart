import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';      
import 'package:intl/intl.dart';

import '../../widgets/custom_drop_down_button.dart';


class AttendedStudentsList extends StatefulWidget {
  @override
  _AttendedStudentsListState createState() => _AttendedStudentsListState();
}

class _AttendedStudentsListState extends State<AttendedStudentsList> {
  Size screenSize;
  TextTheme textTheme;

  final firestoreInstance = Firestore.instance;
  final databaseInstance = FirebaseDatabase.instance;
  String selectedYear = "FE";
  String selectedDivsion = "A";
  String selectedSubject = "CN";
  List<String> _yearsList = ['FE', 'SE', 'TE', 'BE'];
  List<String> _subjectList = ['CN'];
  List<String> _divisionList = ['A', 'B'];
  List<StudentPresentModelNew> newww=[
     StudentPresentModelNew(id: 'xxx', name: 'cccc', rollNo: 0, present: false)
    ];
  @override
  void initState() { 
    newww.insert(0,StudentPresentModelNew(id: 'xxx', name: 'cccc', rollNo: 0, present: false));
   
    super.initState();
    
  }

  bool isLoading = true;
  @override
  Future getDataByDate(String date) async {
     print("%%%%%%%%");
    print(newww[0].id);
    print("%%%%%%%%");
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await firebaseAuth.currentUser();
    String teacherId = user.uid;
    setState(() {
      isLoading = true;
    });
    List<Map<String, bool>> studentDataFromDB = [];
    List<StudentPresentModel> studentDataFromFirestore = [];

    await databaseInstance
        .reference()
        .child("Teachers")
        .child(teacherId)
        .child(selectedYear)
        .child(selectedDivsion)
        .child("CN")
        .child(date.toString())
        .child("Attendance")
        .once()
        .then((DataSnapshot snap) {
      var data = snap.value.toList();

      for (int i = 0; i < data.length; i++) {
        Map data2 = json.decode(data[i]);

        String key = data2.keys.toString();

        var present = data2.values.toList();

        studentDataFromDB.add({key: present[0]});
      }
    });
    print("1st part done");
    await firestoreInstance
        .collection("Years")
        .document(selectedYear)
        .collection(selectedDivsion)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach(
        (studentData) {
          StudentPresentModel student = StudentPresentModel(
            id: studentData['Student Id'],
            rollNo: studentData['Roll No'],
            name: studentData['Full Name'],
          );

          studentDataFromFirestore.add(student);
        },
      );
    });
    for (var i = 0; i < studentDataFromFirestore.length; i++) {
      bool v = studentDataFromDB[i].values.toList()[0];
      StudentPresentModelNew student = StudentPresentModelNew(
          id: studentDataFromFirestore[i].id,
          name: studentDataFromFirestore[i].name,
          rollNo: studentDataFromFirestore[i].rollNo,
          present: v);
      newww.insert(i, student);
    }
    for (var i = 0; i < newww.length; i++) {
      print(newww[i].id);
      print(newww[i].name);
      print(newww[i].rollNo.toString());
      print(newww[i].present.toString());
    }

    print('2nd part done');

    setState(() {
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students List',
          style: Theme.of(context).textTheme.title,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MyDropDowmButton(
                selectedValue: selectedYear,
                icon: Icons.person_pin,
                itemsList: _yearsList,
                width: screenSize.width - 119,
                onChanged: (value) {
                  selectedYear = value;
                  setState(() {});
                },
              ),
              SizedBox(
                height: 10,
              ),
              //division drop down button
              MyDropDowmButton(
                selectedValue: selectedDivsion,
                icon: Icons.category,
                itemsList: _divisionList,
                width: screenSize.width - 119,
                onChanged: (value) {
                  selectedDivsion = value;
                  setState(() {});
                },
              ),
              SizedBox(
                height: 10,
              ),
              MyDropDowmButton(
                selectedValue: selectedSubject,
                icon: Icons.subject,
                itemsList: _subjectList,
                width: screenSize.width - 119,
                onChanged: (value) {
                  selectedSubject = value;
                  setState(() {});
                },
              ),
              SizedBox(
                height: 10,
              ),
              //get list button
              Align(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  elevation: 10.0,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    print('rehersal');
                    print(selectedYear);
                    print(selectedDivsion);
                    print(selectedSubject);
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2022))
                        .then((date) {
                      String d = DateFormat('dd-MM-yyyy').format(date);
                      print('fuck 1');
                      getDataByDate(d);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff4D4D4D)),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            //list view vapar na direct element aligned rahtil ka
                            //ho atmadhe na stack vapar ListTile chya aivaji
                            //or rahude he file majhya app madhe tak me krto te list cha 
                            //ohk
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Attendance',
                                  style: Theme.of(context).textTheme.subtitle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              isLoading
                                  ? Text('wait kro')
                                  : DataTable(
                                      columns: <DataColumn>[
                                        DataColumn(
                                            label: Text(
                                              "Name",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            numeric: false),
                                        DataColumn(
                                            label: Text(
                                              "Roll No",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            numeric: true),
                                        DataColumn(
                                            label: Text(
                                              "Present",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            numeric: false),
                                      ],
                                      rows: newww.map((n) {
                                        DataRow(cells: [
                                          DataCell(
                                            isLoading
                                                ? Text("")
                                                : Text(
                                                    n.name,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff414141)),
                                                  ),
                                          ),
                                          DataCell(isLoading
                                              ? Text("")
                                              : Text(n.id.toString(),
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xff414141)))),
                                          DataCell(isLoading
                                              ? Text("")
                                              : Text(n.present ? "Yes" : "No",
                                                  style: TextStyle(
                                                      color: n.present
                                                          ? Color(0xff2ecc71)
                                                          : Color(
                                                              0xffe74c3c)))),
                                        ]);
                                      }).toList(),
                                    ),
                            ],
                          ),
                        ),
                ),
              )
            ],
          )),
    );
  }
}

class StudentPresentModel {
  String id;
  String name;
  int rollNo;

  StudentPresentModel({this.name, this.id, this.rollNo});
}

class StudentPresentModelNew {
  String id;
  String name;
  int rollNo;
  bool present;
  StudentPresentModelNew({this.name, this.id, this.rollNo, this.present});
}
