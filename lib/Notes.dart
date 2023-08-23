import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_pad/theNote.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        title: Text(widget.text, style: TextStyle(color: Colors.white),),
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
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListTile(
                      tileColor: noteList[index]['bgcolor'],
                      title: Text(noteList[index]['Title'],
                        style: TextStyle(color: noteList[index]['txtcolor']),
                      ),
                      leading: Icon(Icons.note_outlined),
                      subtitle: Text(noteList[index]['content'],
                        // style: TextStyle(color: noteList[index]['txtcolor']),
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
              docId: widget.docId, colname: widget.colname)));
        },
        child: Icon(Icons.add, color: Colors.white,),
          backgroundColor: Colors.cyan[900],
        tooltip: 'Add note',
      ),
    );
  }
}
