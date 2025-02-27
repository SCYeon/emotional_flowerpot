import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class User{
  var email;
  var pw;

  User(this.email, this.pw);
}
class UserData{
  var saveID;
  var savePW;

  UserData(saveId, savePW);
}
var saveUser;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  static const routeName = '/signin';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _googleSignIn () async {
    final bool isSignedIn = await GoogleSignIn().isSignedIn();
    GoogleSignInAccount googleUser;
    if (isSignedIn) googleUser = await GoogleSignIn().signInSilently();
    else googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    // print("signed in " + user.displayName);
    return user;
  }

  _buildLoading() {
    return Center(child: CircularProgressIndicator(),);
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 130,),
                Text("Emotional Garden",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'IndieFlower',
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.black54)),
                SizedBox(height: 80,),
                Container(
                  width: 270.0,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'ex) abcd2039@xxx.com',
                      border: OutlineInputBorder(),
                    ),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                // Container(height: 10,),
                SizedBox(height: 10,),
                Container(
                  width: 270.0,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'ex) a1b2c3d4w5',
                      border: OutlineInputBorder(),
                    ),
                    controller: passwordController,
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 10,),
                ButtonTheme(
                  minWidth: 100.0,
                  child: RaisedButton(
                    child: Text('Sign in',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white)),
                    color: Colors.blueGrey,
                    onPressed: () {
                      _buildLogin(User(emailController.text, passwordController.text));
                    },
                  ),
                ),
                SizedBox(height: 50,),
                Text("Don't have an account yet?"),
                SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    setState(() => _loading = true);
                    await _googleSignIn();
                    setState(() => _loading = false);
                    Navigator.pushReplacementNamed(context, '/first');
                  },
                ),
                ButtonTheme(
                  minWidth: 220.0,
                  child: RaisedButton(
                    child: Text('Sign up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54)),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, '/signUp');
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Center(
        child: Container(
          height: 700,
          width: 450,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: new NetworkImage(
                            "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2F3jfzU%2FbtqZoxR9Uew%2FtTGr9rT4vypHlNHG2N3Sy1%2Fimg.gif"),
                        fit: BoxFit.fill)),
              ),
              _loading ? _buildLoading() : _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  //오류부분
  Widget _buildLogin(User InputUser){
    bool dataID = false;
    bool dataPW = false;
/*
    var ref = firebase.database().ref();

    ref.reference().once("value").then((Datasnapshot snapshot){
      var dataID = snapshot.hasChild("${InputUser.email}");
      var dataPW = snapshot.hasChild("${InputUser.pw}");
        if ((dataID == true) && (dataPW == true)) {
          // home화면으로
          Navigator.pushNamed(context, '/home');
        }
        else { //저장X인 경우 다이얼로그
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
                content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Please check your email or password",
                  ),
                ],
              ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
          }
        });
*/

  }
/*
    Firestore.instance.collection("User").where("Email", isEqualTo: InputUser.email)
        .getDocuments().then((querySnapshot) => {
          snapshot.forEach((DocumentSnapshot){
            dataID = true;
            print("dataID값 : $dataID");
            })

      Firestore.instance.collection("User").where("Password", isEqualTo: InputUser.pw)
          .getDocuments().then((querySnapshot) => {
        dataPW = true,
        print("dataPW값: $dataPW"),

        if ((dataID == true) && (dataPW == true)) {
      // home화면으로
        Navigator.pushNamed(context, '/home'),
          }
          else { //저장X인 경우 다이얼로그
          showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
          return AlertDialog(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
          content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Text(
          "Please check your email or password",
          ),
          ],
          ),
          actions: <Widget>[
          new FlatButton(
          child: new Text("OK"),
          onPressed: () {
          Navigator.pop(context);
          },
          ),
          ],
          );
          }),
          },
          }),
    });
*/
/*
      if ((doc["Email"] == "${InputUser.email}") && (doc["Password"] == "${InputUser.pw}")) {
        Navigator.pushNamed(context, '/home');
      }
      else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Please check your email or password",
                    ),
                  ],
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
     */
/*
    //dataID 와 dataPW 가 있는 documents가 있을때 실행하는 실행문을 적는게 아닌가? 왜 false지?
    Firestore.instance.collection("User").where("Email", isEqualTo: InputUser.email)
        .getDocuments().then((querySnapshot) => {
      dataID = true,
      print("dataID값 : $dataID"),
    });

    Firestore.instance.collection("User").where("Password", isEqualTo: InputUser.pw)
        .getDocuments().then((querySnapshot) => {
      dataPW = true
    });

    print("INPUT값: ${InputUser.email}, ${InputUser.pw}\n dataID 값: $dataID, dataPW 값: $dataPW");


    if ((dataID == true)&&(dataPW == true)) {
      // home화면으로
      Navigator.pushNamed(context, '/home');
    }
    else { //저장X인 경우 다이얼로그
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Please check your email or password",
                  ),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
    */
/*
//임시
    var saveID = Firestore.instance.collection("User").where("Email", isEqualTo: InputUser.email);
    if(saveID != null)  dataID = true;

    var savePW = Firestore.instance.collection("User").where("Password", isEqualTo: InputUser.pw);
    if(savePW != null)  dataPW = true;


    if ((dataID == true) && (dataPW == true)) {
      // home화면으로
      Navigator.pushNamed(context, '/home');
    }
    else { //저장X인 경우 다이얼로그
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Please check your email or password",
                  ),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
 */
/*
    //아이디,비밀번호가 저장되어있을때
    Firestore.instance.collection('User').document().get()
        .then((DocumentSnapshot ds) {
          saveID = ds.data["email"]; //User컬렉션에 저장된 문서 중 Email값
          savePW = ds.data["password"]; //User컬렉션에 저장된 문서 중 Password값
          if (InputUser.email == saveID && InputUser.pw == savePW) {
            // home화면으로
            Navigator.pushNamed(context, '/home');
          }
          else { //저장X인 경우 다이얼로그
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Please check your email or password",
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          }
        }
    );*/
}