import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_pad/Notes.dart';
import 'package:note_pad/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class sub_files extends StatefulWidget {

  final String text;
  final String docId;
  final String colname;
  sub_files({required this.text, required this.docId, required this.colname});

  @override
  State<sub_files> createState() => _sub_filesState();
}

class _sub_filesState extends State<sub_files> {


  TextEditingController txt = TextEditingController();
  bool given1 = false;
  List Foldname1 = [];
  late String file1;
  int num= 0;
  Map docList1 = {};
  Map dataMap1 = {};
  bool given = false;


  getData()async {
    List big = [];
    List big1 = [];
    List big3 = [];
    List big4 = [];
    QuerySnapshot s = await FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).get();
    num = s.docs.length;
    for (var i = 0; i < num; i++) {
      final title = s.docs[i].reference.id;
      print('title : $title');
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).doc(title).get();
    var data = await snapshot.data() as Map;
    //TODO
    if(big.contains(title)){
    null;
    }else{
      big.add(title);
      big1.add(data);
    docList1.addAll({widget.docId : big});
    dataMap1.addAll({widget.docId : big1});
    }
    if(big.contains(docList1[i])){
      null;
    }else{
      print('doc list: $docList1');
      print('data map: $dataMap1');
      print("big3 : $big3");
      big3.clear();
      big4.clear();
      big3.add(docList1);
      big4.add(dataMap1);
    }

    if(docList1.isNotEmpty){
    setState(() {
      given1 = true;
    });
    print(given1);
    }

    print('doclist: $docList1');
    print('data: $data');
    print('snap: $snapshot');
    print('big: $big');
    print('Datamap:$dataMap1');
    print('length: ${dataMap1[widget.docId]?.length}');
    print('big 3: $big3');
    print('big 4: $big4');
  }
    given = true;
    return given;
  }

  sendData(String title)async{
    await FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).doc().set({'name': title});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future _displayTextInputDialog1(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Name of the Folder'),
            content: TextField(
              controller: txt,
              decoration: InputDecoration(
                  hintText: ''
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    if(txt.text.isNotEmpty){
                      setState(() {
                        given = false;
                      });
                      sendData(txt.text);
                      getData();
                      Foldname1.add(txt.text);
                      Navigator.pop(context);
                      txt.clear();
                    }
                  },
                  child: Text('OK')
              ),
              TextButton(
                  onPressed: (){

                  },
                  child: Text('Cancel')
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        title: Text(widget.text, style: TextStyle(
            color: Colors.white
        ),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white,),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.8,
            child: given1 ?
            Container(
              child: given ? ListView.builder(
                  itemCount: dataMap1[widget.docId]?.length,
                  itemBuilder: (context, index) {
                    var keyList = dataMap1.keys.toList();
                    var a = dataMap1[keyList[0]][index]['name'];
print('a: $a');
                    //print(dataMap1.values.elementAt(1)[1]['name']);
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            ViewNotes(text: dataMap1[keyList[0]][index]['name'],
                            docuId: docList1[widget.docId][index].toString(),
                            collId: dataMap1[keyList[0]][index]['name'].toString(),
                                docId: widget.docId, colname: widget.colname)));
                      },
                      child: Card(
                        color: Colors.cyan[700],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(dataMap1[keyList[0]][index]['name'], style: TextStyle(
                                color: Colors.white
                            ),),
                            leading: Icon(Icons.folder, color: Colors.white,),
                            trailing: Container(
                              width: 50,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  IconButton(
                                      onPressed: (){
                                        showDialog(
                                            context: context,
                                            builder: (context){
                                              return  AlertDialog(
                                                title: Text("Delete"),
                                                content: Text('This folder will be deleted'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: (){
                                                        Navigator.of(context).pop();
                                                        onFolderDeleted(index);
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
                                      icon: Icon(Icons.delete, color: Colors.white,)
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ) : Center(child: CircularProgressIndicator(),),
            )

            : Text('Theres no folders here')
          )

        ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog1(context);
        },
        tooltip: 'Add folder',
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.cyan[900],
      ),
    );
  }
  void onFolderDeleted(int index) {
    print('The doclist being removed: ${docList1[widget.docId][index]}');
    print('the data being removed: ${dataMap1[widget.docId][index]}');
    String temp = docList1[widget.docId][index];
    docList1[widget.docId].remove(index);
    FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).doc(temp).delete();
    dataMap1[widget.docId].remove(index);
    if(docList1.isEmpty){
      given1 = false;
    }
    getData();
    setState(() {
      given = false;
    });
    print('After delete doclst : $docList1');
  }
}
// class subFile{
//   int count2 = 0;
//   String foN ='';

  // void theclick(int l, String a){
  //   List c = List.generate(l, (index) => null);
  //   a = foN;
  //   c.add(foN);
  // }
// }