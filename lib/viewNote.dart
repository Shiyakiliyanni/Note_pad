import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class viewNote extends StatefulWidget {
  final String documentId;
  final String docuId;
  final String collId;
  final String docId;
  final String colname;
  const viewNote({super.key, required this.documentId, required this.docuId, required this.collId, required this.docId, required this.colname});

  @override
  State<viewNote> createState() => _viewNoteState();
}

class _viewNoteState extends State<viewNote> {

  TextEditingController noteTitle = TextEditingController();
  TextEditingController note = TextEditingController();

  var data;
  var bgcol;
  var txtcol;
  bool col = false;
  bool gotIt = false;
  bool edit = false;
  bool displayTick = false;

  getData()async{
    DocumentSnapshot notesnap = await FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).doc(widget.docuId).collection(widget.collId).doc(widget.documentId).get();
    data = await notesnap.data() as Map;
    print('data: $data');
    noteTitle.text = data['Title'];
    note.text = data['content'];
    bgcol = data['bgcolor'];
    txtcol = data['txtcolor'];
    // print(bgcol);
    // print(txtcol);
    gotIt = true;
    changeTheBools();
    print(gotIt);
    print(col);
    return gotIt;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool changeTheBools(){
    setState(() {
      if(gotIt == true){
        col = true;
      }
    });
    return col;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        title: Text('View note', style: TextStyle(color: Colors.white),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white,),
        ),
        actions: [
          displayTick ? IconButton(onPressed: (){
            updateContent(note.text);
            Navigator.pop(context);
          },
              icon: Icon(Icons.check, color: Colors.white,)
          ) : IconButton(onPressed: (){
            null;
          },
              icon: Icon(Icons.note, color: Colors.cyan[900],))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: changeTheBools() ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*100,
            color: Color(bgcol),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: noteTitle,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Color(txtcol), fontSize: 28),
                ),
                TextField(
                  onTap: (){
                    setState(() {
                      edit = true;
                      displayTick = true;
                    });
                  },
                  controller: note,
                  readOnly: edit ? false : true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      ),
                  style: TextStyle(color: Color(txtcol), fontSize: 22),
                )
              ],
            ),
          ) : Center(child: CircularProgressIndicator()),
          )
        ],
      ),
    );
  }
  
   void updateContent(String updatedNote){
     FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).doc(widget.docuId).collection(widget.collId).doc(widget.documentId).update(
         {'content': updatedNote});
   }
}

