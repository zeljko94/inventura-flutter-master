import 'package:flutter/material.dart';
import 'package:inventura_app/common/color_palette.dart';

class SettingsIzvozPodatakaScreen extends StatefulWidget {
  const SettingsIzvozPodatakaScreen({ Key? key }) : super(key: key);

  @override
  _SettingsIzvozPodatakaScreenState createState() => _SettingsIzvozPodatakaScreenState();
}

class _SettingsIzvozPodatakaScreenState extends State<SettingsIzvozPodatakaScreen> {


  TextEditingController linkZaUvozPodatakaSaRestApijaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(children: [
                const ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('Izvoz podataka', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  // subtitle: Text('Podnaslov'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                ],),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: linkZaUvozPodatakaSaRestApijaController,
                    cursorColor: ColorPalette.primary,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Link za uvoz podataka sa rest backenda',
                      floatingLabelStyle:
                          TextStyle(color: ColorPalette.primary),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette.primary,
                            width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      return null;
                    },
                    onTap: () async {
      
                    },
                  ),
                ),
              ],)
            ),
          );
  }
}