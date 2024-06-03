import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/add_forum.dart';
import 'package:genie_app/view/screens/group_view.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';
import '../theme.dart';
import 'package:genie_app/view/widgets/appbar.dart';




class ForumsListPage extends StatefulWidget{
  final Groups groupId;
  const ForumsListPage({super.key, required this.groupId});

  @override
  State<ForumsListPage> createState()=> _ForumsListPageState();

}

class _ForumsListPageState extends State<ForumsListPage>{
  late bool isLoading=true;
  late List<Widget> previews;

  void getForums()async {
    List<Widget> p = await Controller.getForums(widget.groupId);
    setState(() {
      previews= p;
      isLoading=false;
    });

  }

  @override
  void initState() {
    super.initState();
    
    getForums();
  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar:TopBar(),
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
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> GroupView(group: widget.groupId)));
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
                            MaterialPageRoute(builder: (context)=> AddForum(groupId: widget.groupId,))
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
                      child:
                      previews.isEmpty?
                      const Center(child: Text('No hay foros disponibles', style: TextStyle(color: Color(0xffB4B6BF)),),):
                      ListView(
                        children: [
                          ...previews
                        ],
                      )
                      ),

          ],
        ),
        bottomNavigationBar: BottomNavBar(),
    );}
}