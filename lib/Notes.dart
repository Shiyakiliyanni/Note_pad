import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_pad/theNote.dart';
import 'package:note_pad/viewNote.dart';

class ViewNotes extends StatefulWidget {
  final String text;
  final String docuId;
  final String collId;
  final String docId;
  final String colname;
  const ViewNotes({Key? key, required this.text, required this.docuId, required this.collId, required this.docId, required this.colname}) : super(key: key);

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {

  int len = 0;
  List noteList = [];
  List docuList = [];
  bool nempty = false;
  bool got = false;
  var moreThan29;

  getData()async{
    QuerySnapshot noteQuery = await FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).doc(widget.docuId).collection(widget.collId).get();
    len = noteQuery.docs.length;
    for(var i = 0; i<len; i++){
      final docName = noteQuery.docs[i].reference.id;
      print('Document name: $docName');
      DocumentSnapshot noteSnap = await FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).doc(widget.docuId).collection(widget.collId).doc(docName).get();
      var data = await noteSnap.data() as Map;
      print('data: $data');
      if(docuList.contains(docName)){
        null;
      }else{
        docuList.add(docName);
        noteList.add(data);
      }
      if(docuList.isNotEmpty){
        setState(() {
          nempty = true;
        });
      }
      print('doculist: $docuList');
      print('notelist: $noteList');
    }
    got = true;
    return got;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool StringCount(int index){
    int contentlength =  noteList[index]['content'].toString().length;
    if(contentlength >= 25){
      moreThan29 = true;
    }else{
      moreThan29 = false;
    }
    return moreThan29;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        title: Text(widget.text, style: TextStyle(color: Colors.white),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white,),
        ),
      ),
      body: nempty ? got ? Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.8,
            child: ListView.builder(
              itemCount: noteList.length,
                itemBuilder: (context, index){
              return GestureDetector(
                onLongPress: (){
                  showDialog(
                      context: context,
                      builder: (context){
                        return  AlertDialog(
                          title: Text("Delete"),
                          content: Text('This note will be deleted'),
                          actions: [
                            TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  deleteNote(index);
                                },
                                child: Text('OK')
                            ),
                            TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel')
                            ),
                          ],
                        );
                      }
                  );
                },
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewNote(docuId: widget.docuId,
                      collId: widget.collId,
                      docId: widget.docId, colname: widget.colname, documentId: docuList[index])));
                },
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: ListTile(
                      tileColor: Color(noteList[index]['bgcolor']),
                      title: Text(noteList[index]['Title'],
                        style: TextStyle(color: Color(noteList[index]['txtcolor'])),
                      ),
                      leading: Icon(Icons.note),
                      subtitle: Row(
                        children: [
                          Text(noteList[index]['content'].toString().substring(0, StringCount(index) ? 25 : null),
                            style: TextStyle(color: Color(noteList[index]['txtcolor'])),
                          ),
                          Text(StringCount(index) ? '...' : "", style: TextStyle(color: Color(noteList[index]['txtcolor'])),),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()) :
          Center(child: Text('No notes to display'),),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Note(docuId: widget.docuId,
              collId: widget.collId,
              docId: widget.docId, colname: widget.colname))).then((value) {
                getData();
          });
        },
        child: Icon(Icons.add, color: Colors.white,),
          backgroundColor: Colors.cyan[900],
        tooltip: 'Add note',
      ),
    );
  }

  void deleteNote(int index){
    setState(() {
      print('note document id: ${docuList[index]}');
      print('note items being deleted: ${noteList[index]}');
      FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).doc(widget.docuId).collection(widget.collId).doc(docuList[index]).delete();
      docuList.removeAt(index);
      noteList.removeAt(index);
      getData();
    });
  }

}
