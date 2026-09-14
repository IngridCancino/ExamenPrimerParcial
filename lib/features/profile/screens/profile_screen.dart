import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text("Mi Perfil"),
    ),
    body: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
    children: [
      CircleAvatar(
    child: Icon(
    Icons.person,),),
    Text("Siriusito",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),),
    Divider(),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(child:
      Card(
    child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        Text("Entrenamientos completados:",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),),
        Text("15"),
      ],),),),),
      Expanded(child:
    Card(
    child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        Text("Días cumpliendo la dieta:",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),),
        Text("1"),
      ],),),),),
    ],
    ),
    ],
   ),), );
  }
}