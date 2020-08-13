import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../widgets/date_widget.dart';

import '../../constants/routes.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static String apiUrl="https://attendance-manager-dc452.firebaseio.com/Teachers/9xkcUpl9Z8PyFPwZC7de0baLszt1";
  Future dataFromDb() async{
    print("1");
    var data=await http.get(apiUrl);
    print(data.body);
    print("2");
    var data2=json.decode(data.body);
    print("3");
    print(data2.toString());
  }
  //  final firestoreInstance = Firestore.instance;
  //  final databaseInstance=FirebaseDatabase.instance;

  //  bool isLoading=true;

  //   Future getDataByDate(String date) async {
    
   
  //   setState(() {
  //     isLoading = true;
  //   });
    
  //     // var data = snap.value.toList();

  //     // for (int i = 0; i < data.length; i++) {
  //     //   Map data2 = json.decode(data[i]);

  //     //   String key = data2.keys.toString();

  //     //   var present = data2.values.toList();

  //     //   studentDataFromDB.add({key: present[0]});
  //     // }

  //   await databaseInstance
  //       .reference()
  //       .child("Teachers").

  //   //     ((DataSnapshot snap) {
  //   // });
  //   print("1st part done");
  //   await firestoreInstance
  //       .collection("Years")
  //       .document(selectedYear)
  //       .collection(selectedDivsion)
  //       .getDocuments()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.documents.forEach(
  //       (studentData) {
          
  //       },
  //     );
  //   });
    
   

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  int percentage = 70;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Image.asset(
          'assets/icons/menu.png',
        ),
        centerTitle: true,
        title: Text(
          'Admin Controls',
          style: textTheme.title,
        ),
      ),
      body:Center(
        child: RaisedButton(onPressed: (){
          dataFromDb();
        }),
      ) /*SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 22.0,
            right: 22.0,
            bottom: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //heading date
              DateWidget(),
              //miscellaneous information
              _buildMiscellaneousInformation(
                context,
                screenSize,
                textTheme,
              ),
              //average attendance information
              _buildAverageAttendanceInformation(
                context,
                screenSize,
                textTheme,
              ),
              //actions
              _buildActions(
                context,
                screenSize,
                textTheme,
              ),
            ],
          ),
        ),
      ),*/
    );
  }

 /* _buildActions(
    BuildContext context,
    Size screenSize,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Actions',
          textAlign: TextAlign.start,
          style: textTheme.title,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //get stats button
              RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 36.0,
                ),
                elevation: 1.0,
                onPressed: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/stats.png',
                      height: screenSize.height * 0.045,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      'Get \n Statistics',
                      textAlign: TextAlign.center,
                      style: textTheme.button,
                    ),
                  ],
                ),
              ),
              //new teacher button
              RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 36.0,
                ),
                elevation: 1.0,
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.CREATE_TEACHER_SCREEN);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/new_teacherpng.png',
                      height: screenSize.height * 0.05,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      'New \n Teacher',
                      textAlign: TextAlign.center,
                      style: textTheme.button,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(TextTheme textTheme) {
    // String percentage = "70";
    double absentPercenage = 100 - percentage.toDouble();
    return [
      PieChartSectionData(
        color: Color(0xFF2ecc71),
        value: percentage.toDouble(),
        title: "$percentage %",
        radius: 42,
        titleStyle: textTheme.title,
      ),
      PieChartSectionData(
        color: Color(0xFFe74c3c),
        value: absentPercenage,
        title: "$absentPercenage %",
        radius: 40,
        titleStyle: textTheme.title,
      ),
    ];
  }

  _buildAverageAttendanceInformation(
    BuildContext context,
    Size screenSize,
    TextTheme textTheme,
  ) {
    return Container(
      width: screenSize.width,
      height: screenSize.height * 0.3,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  startDegreeOffset: 180,
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(textTheme),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'On Average $percentage% \n Students Attend \n Their Lecture!',
                textAlign: TextAlign.center,
                style: textTheme.subtitle,
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //indicator
                  Container(
                    height: 18.0,
                    width: 18.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFF2ecc71),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  //indicator text
                  Text('Present', style: textTheme.subtitle),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //indicator
                  Container(
                    height: 18.0,
                    width: 18.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFe74c3c),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  //indicator text
                  Text('Absent', style: textTheme.subtitle),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildMiscellaneousInformation(
    BuildContext context,
    Size screenSize,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: <Widget>[
          //total students count
          Container(
            height: screenSize.height * 0.18,
            // width: screenSize.width / 3,
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 13.0,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).backgroundColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //student image
                Image.asset(
                  'assets/icons/student.png',
                  height: screenSize.height * 0.08,
                ),
                //student title
                Text(
                  'Students',
                  style: textTheme.subtitle,
                ),
                //student count
                Text(
                  '1200', //TODO, calculate this
                  style: textTheme.subtitle,
                ),
              ],
            ),
          ),
          //total steacher count
          Container(
            height: screenSize.height * 0.18,
            // width: screenSize.width / 3,
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 13.0,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).backgroundColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //teacher image
                Image.asset(
                  'assets/icons/teacher.png',
                  height: screenSize.height * 0.08,
                ),
                //teacher title
                Text(
                  'Teachers',
                  style: textTheme.subtitle,
                ),
                //teacher count
                Text(
                  '36', //TODO, calculate this
                  style: textTheme.subtitle,
                ),
              ],
            ),
          ),
          //lectures steacher count
          Container(
            height: screenSize.height * 0.18,
            // width: screenSize.width / 3,
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 13.0,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).backgroundColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //lectures image
                Image.asset(
                  'assets/icons/lectures.png',
                  height: screenSize.height * 0.08,
                ),
                //lectures title
                Text(
                  'Lectures', //TODO, calculate this
                  style: textTheme.subtitle,
                ),
                //lectures count
                Text(
                  '128',
                  style: textTheme.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*/
}
