import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/user_documents/student_idea_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';


class TeacherResultScreenVM extends ChangeNotifier{
  StudentIdeaService _studentIdeaService=GetIt.I.get<StudentIdeaService>();
  UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  String uid="";
  List<List<UserSignupModel>> _groups=[];
  TeacherResultScreenVM(){
  uid=_firebaseAuth.currentUser!.uid;
  getStudentGroups();
  }

  Future getStudentGroups()async
  {
    await _studentIdeaService.getAllAcceptedIdeas().then((listOfIdeas) {
      listOfIdeas.forEach((idea) {
        List<UserSignupModel> userList=[];
        if(idea.acceptedBy==uid)
          {

            Future.forEach(idea.students, (studentUID) async{
              await _userProfileService.
              getProfileDocument(
                  studentUID.toString(),
                  'student').then((user) {
                userList.add(user!);
              });
            });
            setGroups=userList;
          }



      });
    });
  }

  List<List<UserSignupModel>> get groups=>_groups;

  set setGroups(List<UserSignupModel> group)
  {
    _groups.add(group);
    notifyListeners();
  }
}