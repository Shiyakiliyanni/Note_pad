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

  getData()async{
    DocumentSnapshot notesnap = await FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).doc(widget.docuId).collection(widget.collId).doc(widget.documentId).get();
    data = await notesnap.data() as Map;
    print('data: $data');
    noteTitle.text = data['Title'];
    note.text = data['content'];
    bgcol = data['bgcolor'];
    txtcol = data['txtcolor'];
    print(bgcol);
    print(txtcol);
    gotIt = true;
    return gotIt;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool changeTheBools(){
    if(gotIt == true){
      col = true;
    }
    return col;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(),
      body: changeTheBools() ? Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(bgcol),
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            TextField(
              controller: noteTitle,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(color: Color(txtcol)),
            ),
            TextField(
              controller: note,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  ),
              style: TextStyle(color: Color(txtcol)),
            )
          ],
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}

