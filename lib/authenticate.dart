import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/sign_button.dart';
import 'package:todos/pages/home.dart';

class Authenticate extends StatefulWidget {
  static const String id = "sign";
  final String? title;

  const Authenticate({
    Key? key,
    this.title = "Smartfarms",
  }) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  //authenticating user
  final FirebaseAuth fireAuth = FirebaseAuth.instance;
  // final database = FirebaseDatabase.instance.reference();
  bool isLoading = false;
  String accountMessage = "";

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  @override
  void initState() {
    super.initState();
    User? user;
    //checkInstance(user, buildContext);
    void getUser(User user, BuildContext ctx) async {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            user: user,
          ),
        ),
      );
    }
    // }

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        GoogleSignInAccount _currentUser = account!;
      });
      _handleFirebase() async {
        final GoogleSignInAccount? account = await _googleSignIn.signIn();
        final GoogleSignInAuthentication authentication =
            await account!.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
            idToken: authentication.idToken,
            accessToken: authentication.accessToken);

        final UserCredential authResult =
            await fireAuth.signInWithCredential(credential);
        user = authResult.user;

        getUser(user!, context);
      }

      _handleFirebase();

      _googleSignIn.signInSilently();
    });
  }

  Future<void> handleSignIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _googleSignIn.signIn();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: const [
              Icon(Icons.assignment_turned_in_rounded),
              Text('Logged in Successfully!'),
            ],
          ),
        ),
      );
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: const <Widget>[
              Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 30,
              ),
              Text('network error! Check your connection'),
            ],
          ),
        ),
      );
    }
  }

  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: height * 0.3,
                width: double.infinity,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    //borderRadius: BorderRadius.vertical(bottom: Radius.circular(10),),
                  ),
                  // child: Image.asset('images/Smartfarms exports/logo_1.png'),
                  child: const ColoredBox(
                    color: Colors.blue,
                  ),
                ),
              ),
              const Spacer()
            ],
          ),
          Positioned(
            top: 180,
            left: 35,
            right: 35,
            child: Container(
              width: width * 0.7,
              height: height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //GoogleUserCircleAvatar(identity: identity),
                      // const CircleAvatar(
                      //   backgroundImage:
                      //       AssetImage('images/Smartfarms exports/logo_6.png'),
                      //   radius: 40,
                      // ),
                      const TextFieldContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              hintText: "email or username",
                              enabledBorder: InputBorder.none,
                              suffixIcon: Icon(Icons.account_circle)),
                        ),
                      ),
                      TextFieldContainer(
                        child: TextField(
                          obscureText: isHidden,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            hintText: "password",
                            enabledBorder: InputBorder.none,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isHidden = !isHidden;
                                });
                              },
                              child: Icon(
                                isHidden
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              accountMessage = "You need to sign up first";
                            });
                          },
                          child: Text(
                            'Sign In',
                            style: Theme.of(context)
                                .textTheme
                                .button!
                                .copyWith(fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SignInButton(
                        buttonType: ButtonType.google,
                        onPressed: () {
                          handleSignIn();
                        },
                        btnText: 'Sign In With Google',
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(accountMessage,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isLoading
              ? const Align(
                  alignment: Alignment(0.0, -0.85),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}

/////

class TextFieldContainer extends StatelessWidget {
  final Widget? child;

  const TextFieldContainer({
    Key? key,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: child,
      ),
    );
  }
}

class CustDivider extends StatelessWidget {
  const CustDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(
          indent: 20,
          endIndent: 10,
          color: Colors.black,
          thickness: .9,
        )),
        Text(
          'create account',
          style: Theme.of(context).textTheme.button!.copyWith(fontSize: 16),
        ),
        const Expanded(
            child: Divider(
          indent: 10,
          endIndent: 20,
          color: Colors.black,
          thickness: .9,
        )),
      ],
    );
  }
}
