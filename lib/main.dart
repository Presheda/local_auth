import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "Local Auth"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final LocalAuthentication _localAuthentication =
  LocalAuthentication();

  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Not Authorized";

  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try{
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e){
      print(e);
    }

    if(!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });

  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;

    try{
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e){
      print(e);
    }

    if(!mounted) return;
    setState(() {
      _availableBiometricTypes = listOfBiometrics;
    });

  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;

    try{
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
          localizedReason: "Please Authenticat to complete transaction",
        useErrorDialogs: true,
          stickyAuth: true,
      );
    } on PlatformException catch (e){
      print(e);
    }

    if(!mounted) return;
    setState(() {
      if(isAuthorized){
        _authorizedOrNot = "Authorized";
      } else {
        _authorizedOrNot = "Not Authorized";
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Can we check Biometric : $_canCheckBiometric"),
            RaisedButton(
              onPressed: _checkBiometric,
              child: Text("Check Biometric"),
              color: Colors.red,
              colorBrightness: Brightness.light,
            ),

            Text("List of Biometric types :"
                " ${_availableBiometricTypes.toString()}"),
            RaisedButton(
              onPressed: _getListOfBiometricTypes,
              child: Text("List of Biometric types"),
              color: Colors.red,
              colorBrightness: Brightness.light,
            ),



            Text("Authorized : $_authorizedOrNot" ),

            RaisedButton(
              onPressed: _authorizeNow,
              child: Text("Authorize now"),
              color: Colors.red,
              colorBrightness: Brightness.light,
            ),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
        backgroundColor: Colors.white,
        child: CustomPaint(
          child: Container(),
          foregroundPainter: FloatingPainter(),
        ),
      ),
    );
  }
}

class FloatingPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {
    
    Paint amberPaint = Paint()
        ..color = Colors.amber
        ..strokeWidth = 5;

    Paint greenPaint = Paint()
        ..color = Colors.green
        ..strokeWidth = 5;

    Paint redPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 5;

    Paint bluePaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 5;
    
    canvas.drawLine(Offset(size.width*0.25, size.height*0.5),
        Offset(size.width * 0.5, size.height*0.5),
        amberPaint);

    canvas.drawLine(Offset(size.width*0.5, size.height*0.5),
        Offset(size.width * 0.75, size.height*0.5),
        bluePaint);

    canvas.drawLine(Offset(size.width*0.5, size.height*0.5),
        Offset(size.width * 0.5, size.height*0.75),
        greenPaint);

    canvas.drawLine(Offset(size.width*0.5, size.height*0.5),
        Offset(size.width * 0.5, size.height*0.25),
        redPaint);
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {

    return false;
  }

}