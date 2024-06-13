import 'package:flutter/material.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/tabs.dart';

class FichasView extends StatefulWidget {
  const FichasView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FichasViewState createState() => _FichasViewState();
}

class _FichasViewState extends State<FichasView> {
  late bool isLoading = true;
  late List<Widget> topics = [];

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('hola fichas'),
    );
  }
}
