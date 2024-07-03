import 'package:genie_app/models/following.dart';
import 'package:genie_app/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:genie_app/view/widgets/appbar.dart';
import 'package:genie_app/view/widgets/bottom_nav_bar.dart';
import 'package:genie_app/view/widgets/follow_request.dart';
import 'package:genie_app/viewModel/FollowRequestNotification.dart';
import 'package:genie_app/viewModel/controllerSocial.dart';

class FollowRequestPage extends StatefulWidget {
  const FollowRequestPage({super.key});

  @override
  State<FollowRequestPage> createState() => _FollowRequestPageState();
}

class _FollowRequestPageState extends State<FollowRequestPage> {
  late Following following = Following.fromJson(
      {"follows": [], "followed": [], "requests": [], "requested": []});
  late List<FollowRequest> requests = [];
  late List<dynamic> remove = [];
  late List<dynamic> accept = [];
  late bool isLoading = true;
  void getRequests() async {
    Following f = await ControllerSocial.getFollowing();
    List<FollowRequest> r = await ControllerSocial.getFollowRequests(f);
    setState(() {
      following = f;
      requests = r;
      isLoading = false;
    });
  }

  void finalizeRequests() async {
    setState(() {
      isLoading = true;
    });
    await ControllerSocial.manageRequests(accept, remove, following);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    getRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<FollowRequestNotification>(
      onNotification: (n){
        if(n.result){
          accept.add(n.id);
        }else{
          List<FollowRequest> r = ControllerSocial.removeRequest(requests, n.id);
          remove.add(n.id);
          setState(() {
            requests=r;
          });
        }
        return true;
      },
      child: Scaffold(
      appBar: TopBar(),
      body: isLoading? const Center(child: CircularProgressIndicator(),)
      : Column(
                  children: [
                    Container(
                      color: genieThemeDataDemo.colorScheme.secondary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                              onPressed: () {
                                finalizeRequests();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.chevron_left,
                                      color: genieThemeDataDemo
                                          .colorScheme.onSecondary),
                                  Text(
                                    'Regresar',
                                    style: TextStyle(
                                        color: genieThemeDataDemo
                                            .colorScheme.onSecondary),
                                  )
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Text(
                              "Solicitudes de Amistad",
                              style: genieThemeDataDemo
                                  .primaryTextTheme.headlineSmall,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: 
                      requests.isEmpty? 
                      Center(child: Text("No hay solicitudes de amistad", style: TextStyle(color: Color(0xffB4B6BF))),):
                      ListView(
                      children: [...requests],
                    ))
                  ],
                ),
          bottomNavigationBar: BottomNavBar(),
        ));
  }
}
