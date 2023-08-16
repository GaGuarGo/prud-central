import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:prud_central/classes/size_config.dart';
import 'package:prud_central/screens/login_screen.dart';

class SplashTab extends StatefulWidget {
  @override
  _SplashTabState createState() => _SplashTabState();
}

class _SplashTabState extends State<SplashTab> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 40,
              width: SizeConfig.blockSizeHorizontal * 40,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                        tileMode: TileMode.mirror,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.greenAccent])
                    .createShader(bounds),
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Colors.white, BlendMode.modulate),
                  child: FlareActor(
                    'assets/PrudLoadWhite.flr',
                    animation: 'load',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }
}
