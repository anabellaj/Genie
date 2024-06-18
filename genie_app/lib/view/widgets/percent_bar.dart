import 'package:genie_app/models/group.dart';
import 'package:genie_app/view/screens/fichas_menu.dart';
import 'package:genie_app/view/screens/flashcard_carrousel.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';

class PercentBar extends StatelessWidget {
  const PercentBar({super.key, required this.percent, required this.group, required this.topicId});
  final double percent;
  final Groups group;
  final String topicId;


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: 
                (context)=>FichasView(group: group,topicId: topicId)
                ));
                
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xffD0E1EB), // Adjusted background color
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Seguir Estudiando',
                      style: TextStyle(
                        color: Color(0xFF174A59),
                        fontSize: 20,
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: 20,
                      backgroundColor: Colors.white,
                      progressColor: const Color(0xff084C6E),
                      percent: 0.75, // Adjusted to 75%
                      lineWidth: 7,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: const Text(
                        '75%',
                        style: TextStyle(
                          color: Color(0xff084C6E),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    
  }
}