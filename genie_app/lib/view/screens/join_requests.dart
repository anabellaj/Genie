import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/join_request.dart';
import 'package:genie_app/viewModel/JoinRequestNotification.dart';
import 'package:genie_app/viewModel/controllerSocial.dart';

class JoinRequestPage extends StatefulWidget{
  const JoinRequestPage({super.key, required this.group});
  final Groups group;

  @override State<JoinRequestPage> createState() => _JoinRequestPageState();
}

class _JoinRequestPageState extends State<JoinRequestPage>{

  List<JoinRequest> requests = [];
  List<dynamic> add = [];
  List<dynamic> remove = [];
  late bool isLoading=false;

  void manageRequests()async{
    setState(() {
      isLoading=true;
    });
    await ControllerSocial.manageJoinRequests(widget.group, add, remove);
    Navigator.of(context).pop();
  }

   @override
  void initState() {
    setState(() {
      requests = ControllerSocial.getRequests(widget.group);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return NotificationListener<JoinRequestNotification>(
      onNotification: (n){
        if(n.state){
          add.add(n.id);
        }else{
          remove.add(n.id);
          List<JoinRequest> r= ControllerSocial.removeJoinRequest(requests, n.id);
          setState(() {
            requests=r;
          });
        }
        return true;
      },
      child: Scaffold(
      appBar: TopBar(),
      body:isLoading? Center(child: CircularProgressIndicator(),):
      Column(
        children: [
           Container(
        color: genieThemeDataDemo.colorScheme.secondary,
        
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              manageRequests();
            },
            child: Row(
              children: [
                Icon(Icons.chevron_left,
                  color: genieThemeDataDemo.colorScheme.onSecondary),
                Text(
                  'Regresar',
                  style: TextStyle(
                    color: genieThemeDataDemo.colorScheme.onSecondary),
                )
              ],
            )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
            "Solicitudes",
            style: genieThemeDataDemo.primaryTextTheme.headlineSmall,
          ),
            )
        ],
      ),
      ),
      Expanded(
        child: 
        requests.isEmpty? 
        Center(child: Text("No hay solicitudes de acceso al grupo ", style: TextStyle(color: Color(0xffB4B6BF))),):
        ListView(
          children: [...requests],
        ))
      ],),
      bottomNavigationBar: BottomNavBar(),
    ),);
  }
}