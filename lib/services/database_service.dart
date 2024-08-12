import 'dart:ffi';

import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference? _usersCollections;
  CollectionReference? _chatsCollections;

  late AuthService _authService;
  final GetIt _getIt = GetIt.instance;
  
  
  DatabaseService(){
    _authService = _getIt.get<AuthService>();
    _setupCollectionRefrences();
  }
  //snapshots are used to represent the state of an asynchronous operations, suxch as fechting data from a data base :)

  void _setupCollectionRefrences(){
    _usersCollections = 
    _firebaseFirestore.collection("users").withConverter<UserProfile>(
      fromFirestore: (snapshots, _) => UserProfile.fromJson( // style for one line function
        snapshots.data()!) ,
      toFirestore: (userProfile, _) => userProfile.toJson(),
    );

    _chatsCollections = _firebaseFirestore
      .collection("chats")
      .withConverter<Chat>( // we do this so we can have strong type safety and ensure that the data that gets //saved in the database and retrieved from the database confroms to a ceratin layout
        fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!), //WE TRANSFROM THE DATA WE GET FROM SNAPSHOTS
        toFirestore: (chat, _) => chat.toJson());

  }

  Future<void> createUserProfile({required UserProfile userProfile}) async{
    await _usersCollections?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfiles(){ //establishes a sequnece of events to happen
    return _usersCollections
    ?.where("uid",isNotEqualTo: _authService.user!.uid )
    .snapshots() as Stream<QuerySnapshot<UserProfile>>; // the reason we use snapshots is because it returns a stream of QuerySnapshots
    // which we can use to update our UI as data within the actual database changes and we'll automatical;y
    // get these changes shown across our UI
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String ChatID = generateChatID(uid1: uid1, uid2: uid2);
    final result = await _chatsCollections?.doc(ChatID).get();
    if(result != null){
      return result.exists;
    }
    return false;

  }
  Future<void> createNewChat(String uid1, String uid2)  async{
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollections!.doc(chatID);
    final chat = Chat(
      id: chatID, 
      participants: [uid1,uid2], 
      messages: [],
    );
    await docRef.set(chat); // set puts stuff in the firebasee


  }
 
  Future<void> sendChatMessage(
    String uid1, String uid2, Message message) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollections!.doc(chatID);
    await docRef.update(
      {
        "messages" : FieldValue.arrayUnion(
          [
            message.toJson(), //hey update chat doc with this chat id, and go to messages array and take the existing array and merge it with this array
          ]
        ),
      }
    );


  }
 //The reason we use a stream is so whenever the document gets updated in cloudfire store we get updates of that in the stream, so we can
  // consume the stream and see real messages as they come

  
  Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2){
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    return _chatsCollections?.doc(chatID).snapshots() 
      as Stream<DocumentSnapshot<Chat>>;
  }






  
}