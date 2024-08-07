import 'package:flutter/material.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/add_friends.dart';
import 'package:genie_app/view/screens/join_requests.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/viewModel/controller.dart';
import '../theme.dart';
// import 'package:genie_app/view/screens/modify_profile.dart';

class AlignedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AlignedText({Key? key, required this.text, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0), // Adjust padding as needed
      child: Text(text // Use provided style or default
          ),
    );
  }
}

class MembersView extends StatefulWidget {
  final Groups group;
  const MembersView({super.key, required this.group});

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  bool isLoading = true;
  late Widget members;
  late bool isAdmin=false;

  void getMembers() async{
    Widget g = await Controller.obtainGroupMembers(widget.group.members, widget.group);
    bool admin = await Controller.checkAdminCurrUser(widget.group.admins[0]);
    if(mounted){
    setState(() {
      members = g;
      isLoading = false;
      isAdmin=admin;
    });
    }
  }


    @override 
  void initState(){
    super.initState();
    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: TopBar(),
          body: isLoading? const Center(child: CircularProgressIndicator()):
          Column(
        children: [
          Container(
              padding: const EdgeInsets.all(12.0),
              color: genieThemeDataDemo.colorScheme.secondary,
              child: Column(children: [
                TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                      Navigator.of(context).pop(); //CAMBIAR ROUTE A group_menu
                    },
                    child: Row(children: [
                      Icon(
                        Icons.chevron_left,
                        color: genieThemeDataDemo.colorScheme.onPrimary,
                      ),
                      Text(
                        'Regresar',
                        style: TextStyle(
                            color: genieThemeDataDemo.colorScheme.onPrimary),
                      )
                    ])),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Miembros",
                        style:
                            genieThemeDataDemo.primaryTextTheme.headlineSmall,
                      ),
                      Row(children: [
                        TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                       AddFriendPage(group: widget.group))); 
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              genieThemeDataDemo.colorScheme.surface,
                          foregroundColor:
                              genieThemeDataDemo.colorScheme.secondary,
                          textStyle: genieThemeDataDemo.textTheme.bodyMedium?.copyWith(fontSize: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: const Text('Invitar'),
                      ),
                      SizedBox(width: 12,),
                      !isAdmin? SizedBox.shrink():
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      JoinRequestPage(group: widget.group,))); 
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              genieThemeDataDemo.colorScheme.surface,
                          foregroundColor:
                              genieThemeDataDemo.colorScheme.secondary,
                          textStyle: genieThemeDataDemo.textTheme.bodyMedium?.copyWith(fontSize: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: const Text('Solicitudes'),
                      )
                      ],)
                    ])
              ])),
        Expanded(child:members)])
        
    , bottomNavigationBar: BottomNavBar());
  }
}