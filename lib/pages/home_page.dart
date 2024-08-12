import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: const Text(
          "Messages",
        ),
        actions: [ //this snippet allows us to go back to the login page logout the current user
          IconButton(
            onPressed: () async{
              bool result = await _authService.logout();
              if (result){
                _alertService.showToast(
                  text: "Successffuly logged out!",
                  icon: Icons.check,
                );
                _navigationService.pushReplacementNamed("/login"); //removes the user ability to go back to the prev page
              }
            }, 
            color: Colors.red,
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],

      ),
      body: _buildUI(),
    );
  }
  Widget _buildUI(){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: _chatList(),
      ),
    );  // avoids operating interface, limited to kernal mode
  }

  Widget _chatList(){
    return StreamBuilder( //creates stream and using the streams data we can build a widget
      stream: _databaseService.getUserProfiles(), 
      builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(
              child: Text("Unable to load data."),
            );

          }
          if(snapshot.hasData && snapshot.data != null){
            final users = snapshot.data!.docs; //list of users
            return ListView.builder( // allows us to programatically build our listview depending on the data provided
              itemCount: users.length,
              itemBuilder: (context,index){
                UserProfile user = users[index].data();
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: ChatTile(
                    userProfile: user, 
                    onTap: () async {
                      final chatExists =
                      await _databaseService.checkChatExists(
                        _authService.user!.uid, 
                        user.uid!
                      );
                      if(!chatExists){
                        await _databaseService.createNewChat(
                          _authService.user!.uid, 
                          user.uid!,
                        );
                      }
                      _navigationService.push(
                        MaterialPageRoute( // we use this when we want our pages to be unique, and pass a varaible to them
                          builder: (context){
                            return ChatPage(
                              chatUser: user,
                            );
                          },
                        ),
                      ); // the reason we use a materialPageRoute and not named route is because we need to pass in the user profile 
                    }, 
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
      }
    );
  }
  
  
}