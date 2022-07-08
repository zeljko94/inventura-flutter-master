import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsSkeniranjeScreen extends StatefulWidget {
  const SettingsSkeniranjeScreen({ Key? key }) : super(key: key);

  @override
  _SettingsSkeniranjeScreenState createState() => _SettingsSkeniranjeScreenState();
}

class _SettingsSkeniranjeScreenState extends State<SettingsSkeniranjeScreen> {

  bool trimLeadingZerosSwitch = false;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(children: [
                const ListTile(
                  leading: Icon(Icons.qr_code_2),
                  title: Text('Skeniranje', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  // subtitle: Text('Podnaslov'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Trim leading zeros'),
                  ),
                  CupertinoSwitch(value: trimLeadingZerosSwitch, onChanged: (value) {
                    setState(() {
                      trimLeadingZerosSwitch  = !trimLeadingZerosSwitch;
                    });
                  })
                ],),
              ],)
            ),
          );
  }
}