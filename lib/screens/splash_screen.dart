

import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';
import 'package:inventura_app/screens/artikli/artikli.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    
    _navigateHome();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(ColorPalette.backgroundImageOpacity), BlendMode.dstATop),
          image: const AssetImage(ColorPalette.backgroundImagePath),
           fit: BoxFit.cover),
      ),
      child: const Center(
        child: Text('Naziv aplikacije')
      ),
    );
  }

  _navigateHome() {
    Future.delayed(const Duration(microseconds: 1500), () async { 
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ArtikliScreen()));
    });
  }
}