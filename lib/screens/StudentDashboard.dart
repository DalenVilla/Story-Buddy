// lib/library/screens/student_dashboard.dart
import 'package:flutter/material.dart';
import 'package:story_buddy/widgets/StoryCard.dart';
import 'package:story_buddy/widgets/SectionTitle.dart';
import 'package:story_buddy/widgets/BottomNav.dart';

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(_) => Scaffold(
    appBar: AppBar(
      title:Text('Storytime'),
      actions:[IconButton(icon:Icon(Icons.settings), onPressed:(){} )],
    ),
    body:Padding(
      padding:EdgeInsets.all(16),
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          Text('Welcome back, Leo', style:TextStyle(fontSize:24)),
          SizedBox(height:8),
          ElevatedButton(onPressed:(){}, child:Text('Discover My Story')),
          SectionTitle('My Story Journey'),
          SizedBox(
            height:160,
            child:ListView(
              scrollDirection:Axis.horizontal,
              children:[
                StoryCard(title:'The Magical Treehouse', imagePath:'assets/treehouse.png'),
                StoryCard(title:'Adventures with Buddy', imagePath:'assets/buddy.png'),
                // ...
              ]
            )
          ),
          SectionTitle('For Teachers'),
          SizedBox(
            height:160,
            child:ListView(
              scrollDirection:Axis.horizontal,
              children:[
                StoryCard(title:'Classroom Adventure', imagePath:'assets/classroom.png'),
                StoryCard(title:'Field Trip Fun', imagePath:'assets/fieldtrip.png'),
                // ...
              ]
            )
          ),
        ]
      )
    ),
    bottomNavigationBar:BottomNav(),
  );
}
