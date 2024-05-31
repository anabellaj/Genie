import 'package:flutter/material.dart';
import 'package:genie_app/view/screens/add_group.dart';
import 'package:genie_app/view/screens/create_group.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';

class JoinedGroups extends StatefulWidget{
  const JoinedGroups({super.key});

  @override
  State<JoinedGroups> createState() => _JoinedGroupsState();
}

class _JoinedGroupsState extends State<JoinedGroups> {

  late bool isLoading = true;
  late Widget groups;

  void getGroups() async{
    Widget g = await Controller.getUserGroups();
    print("Hola");
    setState(() {
      groups = g;
      print(groups);
      isLoading = false;
    });

    @override 
    void initState(){
      super.initState();
      getGroups();
    }
  }
  Widget build(BuildContext context){
    return Scaffold(
        body:  isLoading?
                    const Center(child: CircularProgressIndicator()):
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(

              color: genieThemeDataDemo.colorScheme.secondary,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(

                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                      Navigator.pushReplacement(context, 
                        MaterialPageRoute(builder: (context)=>const AddGroupScreen())
                      );
                    },
                    child:Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: genieThemeDataDemo.colorScheme.onSecondary,),
                        Text(
                          'Regresar',
                          style: TextStyle(
                            color: genieThemeDataDemo.colorScheme.onSecondary
                          ),
                        )],
                        )

                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10,left: 12,right: 12),
                    child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Foros',
                      style: genieThemeDataDemo.primaryTextTheme.headlineSmall,),
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(genieThemeDataDemo.colorScheme.onPrimary),
                          iconColor: WidgetStatePropertyAll(genieThemeDataDemo.colorScheme.primary)
                        ),
                        onPressed: ()=>{
                          Navigator.pushReplacement(context, 
                            MaterialPageRoute(builder: (context)=>const CreateGroupPage())
                          )   
                        }, 
                        icon: const Icon(Icons.add))
                    ],
                  ),
                  ),

                ],
              ),
            ),

                    Expanded(
                      child:groups),

          ],
        ),
    );

  }
}