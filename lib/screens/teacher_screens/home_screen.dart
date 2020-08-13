import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../constants/routes.dart';

import './attended_students_list.dart';

class TeacherHomeScreen extends StatefulWidget {
  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase databaseInstance = FirebaseDatabase.instance;
  String professorName;

  var _isLoading = false;

  void getProfessorDetails() async {
    //changing state to loading
    setState(() {
      _isLoading = true;
    });

    //gettig logged in user
    FirebaseUser user = await firebaseAuth.currentUser();

    //getting user details from realtime database
    await databaseInstance
        .reference()
        .child("Teachers")
        .child(user.uid)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> userData = snapshot.value;
      professorName = userData['Name'];
    });

    //changing state to not loading
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProfessorDetails();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;
    DateTime todaysDate = DateTime.now();

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
          'Attendance',
          style: textTheme.title,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //date
                  _buildDateWidget(textTheme, todaysDate),
                  //professor detail
                  _buildProfessorDetailWidget(screenSize, textTheme),
                  //take attendance button
                  _buildTakeAttendanceButton(context, textTheme),
                  //student attended button
                  RaisedButton(
                    onPressed: () {
                      //TODO, change this later
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => AttendedStudentsList(),
                        ),
                      );
                    },
                    child: Text('Lecture Details'),
                  ),
                ],
              ),
            ),
    );
  }

  _buildTakeAttendanceButton(BuildContext context, TextTheme textTheme) {
    return RaisedButton(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      color: Theme.of(context).primaryColor,
      elevation: 15.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Take Attendance',
            style: textTheme.button,
          ),
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 32.0,
          ),
        ],
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.TAKE_ATTENDANCE_SCREEN);
      },
    );
  }

  _buildProfessorDetailWidget(Size screenSize, TextTheme textTheme) {
    return Container(
      width: screenSize.width,
      height: screenSize.height * 0.1,
      margin: const EdgeInsets.only(
        top: 36.0,
        bottom: 24.0,
      ),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Color(0xFF5D5D5D),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10.0,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Welcome !',
            style: textTheme.button,
          ),
          Text(
            'Prof. $professorName',
            style: textTheme.title,
          ),
        ],
      ),
    );
  }

  _buildDateWidget(TextTheme textTheme, DateTime todaysDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //week day
        Text(
          DateFormat.EEEE().format(todaysDate),
          style: textTheme.body1.copyWith(
            color: Colors.white,
          ),
        ),
        //date row
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //date
            Text(
              DateFormat.d().format(todaysDate),
              style: textTheme.headline.copyWith(
                fontSize: 56.0,
              ),
            ),
            //date suffix
            Text(
              getDayOfMonthSuffix(int.parse(DateFormat.d().format(todaysDate))),
              style: textTheme.headline,
            ),
            //spacing
            SizedBox(
              width: 8.0,
            ),
            //month
            Transform.translate(
              offset: Offset(0.0, 12),
              child: Text(
                DateFormat.MMMM().format(todaysDate) + ", ",
                style: textTheme.title,
              ),
            ),
            //year
            Transform.translate(
              offset: Offset(0.0, 12),
              child: Text(
                DateFormat.y().format(todaysDate),
                style: textTheme.title,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'TH';
    }

    switch (dayNum % 10) {
      case 1:
        return 'ST';
      case 2:
        return 'ND';
      case 3:
        return 'RD';
      default:
        return 'TH';
    }
  }
}
