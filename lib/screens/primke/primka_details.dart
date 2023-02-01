import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrimkaDetailsScreen extends StatefulWidget {
  const PrimkaDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PrimkaDetailsScreen> createState() => _PrimkaDetailsScreenState();
}

class _PrimkaDetailsScreenState extends State<PrimkaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("PRIMKA DETAILS"),
    );
  }
}