import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/join_or_create.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';

class JoinedGroups extends StatefulWidget{
  const JoinedGroups({super.key});

  @override
  State<JoinedGroups> createState() => _JoinedGroupsState();
}

class _JoinedGroupsState extends State<JoinedGroups> {

  late bool isLoading = true;
  late List<Widget> groups;

  void getGroups() async{
    List<Widget> g = await Controller.getUserGroups();
    if(mounted){
    setState(() {
      groups = g;
      isLoading = false;
    });
    if(groups.isEmpty){
      
    }
    }
  }
  @override 
    void initState(){
      super.initState();
      getGroups();
    }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: TopBar(),
        body:  isLoading?
                    const Center(child: CircularProgressIndicator()):

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  
                  Text('Grupos de Estudio',
                    style: genieThemeDataDemo.primaryTextTheme.headlineLarge,
                  ),
                  groups.isEmpty? 
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*.70,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "No perteneces a ningún grupo de estudio", 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xffB4B6BF)),),
                     Container(
                      margin: const EdgeInsets.only(top:24),
                      child:  FilledButton
                      (onPressed: (){
                        Navigator.pushReplacement(context, 
                          MaterialPageRoute(builder: (context)=> const JoinOrCreate()) 
                      );  
                      }, 
                      style: mainButtonStyle,
                      child: const Text("Se parte de un grupo")),
                     )
                    ],
                  ))
                  :
                  Expanded(child: 
                    ListView(
                      children: [
                        ...groups
                      ],
                    )
                  )]),
                ),
        bottomNavigationBar: BottomNavBar());

  }
}