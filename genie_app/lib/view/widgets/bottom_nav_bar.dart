

import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/controller.dart';

class BottomNavBar extends BottomAppBar{
  BottomNavBar({super.key});

  
  @override
  State<BottomNavBar> createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar>{

  int selIndex=0;

  

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 4,
      selectedItemColor: genieThemeDataDemo.colorScheme.onPrimary,
      unselectedItemColor: genieThemeDataDemo.colorScheme.secondary,
      backgroundColor: genieThemeDataDemo.colorScheme.primary,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index){
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        setState(() {
          selIndex=index;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context)=> Controller.manageNavigation(selIndex))
        );
      },
      items: const [
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.home)
          
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.add, color: Colors.white,)
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.search, color: Colors.white,)
        )
      ],

    );
  }
}