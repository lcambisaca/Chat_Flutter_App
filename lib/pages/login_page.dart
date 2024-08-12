import 'package:chat_app/consts.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //formstate is used for validation
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormkey = GlobalKey();
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  String? email, password;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      child: Column(
        children: [
          _headerText(),
          _loginForm(),
          _createAnAccountLink(),

          ],
        ),
      ),
    );

  }

  Widget _headerText(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi Welcome Back",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "Hello again, you've been missed",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginForm(){
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ), 
      child: Form(
        key: _loginFormkey, // using this key we can perform diff operations
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, //this is to set up spacing :)
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              height: MediaQuery.sizeOf(context).height * 0.1, // this gets 0.10 the max height of the screem
              hintText: "Email",
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value){
                setState(() {
                  email = value;
                });
              },

            ),
            CustomFormField(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: "Password",
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              obscureText: true, //this hides password
              onSaved: (value){
                setState(() {
                  password = value;
                });
              },
            ),
            _loginButton(),
          ],
        )
      ),
    );
  }

  Widget _loginButton(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async{
          if(_loginFormkey.currentState?.validate() ?? false){ // this calls a validate function (may not be implemented yet) on the form where this  key  is attached 
            _loginFormkey.currentState?.save(); //this calls a save function on the form this key is attached in
              bool result = await _authService.login(email!, password!);//! says itll not be empty
            if (result){
              _navigationService.pushReplacementNamed("/home");

            }else{
              _alertService.showToast(
                text: "Failed to login, Please try again!",
                icon: Icons.error,
                );

            }
          }

        },
        color: Theme.of(context).colorScheme.primary,
        child: const Text(
          "Login", 
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _createAnAccountLink(){
    return  Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center, //this is to set up spacing :)
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
           const Text("Don't have an Account? "),
            GestureDetector(
              onTap: (){
                _navigationService.pushNamed("/register"); // we do this so we can go back to prev page
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
           ),
        ],
      ),
    );
  }





}

