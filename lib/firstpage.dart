import 'dart:js';
import 'dart:js_util';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:note_pad/settings.dart';
import 'package:note_pad/subfile.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_pad/viewNote.dart';


class first_page extends StatefulWidget {
  const first_page({Key? key}) : super(key: key);

  @override
  State<first_page> createState() => _first_pageState();
}

class _first_pageState extends State<first_page> {
  final GlobalKey scaffol_key = new GlobalKey();


  TextEditingController search = TextEditingController();
  TextEditingController nameFold = TextEditingController();
  int count = 0;
  bool same = false;
  List<String> Foldname = [];
  bool given = false;
  bool isItEmpty = false;
  String redWar = 'Please enter a name';
  var err;
  late String barName;
  List docList = [];
  int num = 0;
  List dataMap = [];
  bool given1 = false;
  bool forSearch =  false;
  List titles = [];
  List filteredTitles = [];
  bool searchCompleted =  false;
  bool searchDataGot = false;
  Map forPath = {};

  getData()async{
    CollectionReference cr = FirebaseFirestore.instance.collection('Folders');
    QuerySnapshot querySnapshot = await cr.get();
    num = querySnapshot.docs.length;
    for(var i = 0; i<num; i++){
      final title = querySnapshot.docs[i].reference.id;
      print('title : $title');
      DocumentSnapshot snapshot =  await cr.doc(title).get();
      var data = await snapshot.data() as Map;
      if(docList.contains(title)){
        null;
      }else{
        docList.add(title);
        dataMap.add(data);
      }
      if(docList.isNotEmpty){
        given1 = true;
      }
      print('doclist: $docList');
      print('data: $data');
      print('snap: $snapshot');
      print('Datamap: $dataMap');
    }
    given = true;
    setState(() {

    });
    return given;
  }

  searchData()async{
    List docList1 = [];
    List docList2 = [];
    List docList3 = [];
    try {
      print('aaa');
      CollectionReference cr = FirebaseFirestore.instance.collection('Folders');
      QuerySnapshot qs = await cr.get();
      var len = qs.docs.length;
      for (var i = 0; i < len; i++) {
        String doc1 = qs.docs[i].reference.id;
        docList1.add(doc1);
        DocumentSnapshot documentSnapshot = await cr.doc(doc1).get();
        var dataa = documentSnapshot.data() as Map;
        CollectionReference cr1 = await cr.doc(doc1).collection(dataa['name']);
        QuerySnapshot qs1 = await cr1.get();
        var len1 = qs1.docs.length;
        for (var j = 0; j < len1; j++) {
          String doc2 = qs1.docs[j].reference.id;
          docList2.add(doc2);
          DocumentSnapshot ds = await cr1.doc(doc2).get();
          var data = await ds.data() as Map;
          CollectionReference cr2 = await cr1.doc(doc2).collection(data['name']);
          QuerySnapshot qs2 = await cr2.get();
          var len2 = qs2.docs.length;
          for (var k = 0; k < len2; k++) {
            String doc3 = qs2.docs[k].reference.id;
            docList3.add(doc3);
            DocumentSnapshot ds1 = await cr2.doc(doc3).get();
            var daata = await ds1.data() as Map;
            titles.add(daata['Title']);
            forPath.addAll({
              daata['Title']: [{'doc1':doc1},
                {'colname': dataa['name']}, {'doc2': doc2},
                {'colname2': data['name']}, {'doc3': doc3}]
            });
          }
        }
      }
      print('list of titles : $titles');
    }catch(e){
      print('Query error = $e');
    }
    searchDataGot = true;
    return searchDataGot;
  }

  void performSearch(String givenText){
    setState(() {
      if(searchDataGot == true){
        filteredTitles = titles.where((element) =>
            element.toString().toLowerCase().contains(givenText.toLowerCase())).toList();
        searchCompleted = true;
        print(searchCompleted);
      }else{
        searchCompleted = false;
      }
      });
  }

  // bool isDocThere(){
  //   if(docList.isNotEmpty){
  //     return false;
  //   }else{
  //     return true;
  //   }
  // }
  // Future setName(String folderName)async{
  //   return cr.add({'name': folderName});
  // }

  sendData(String title)async{
    await FirebaseFirestore.instance.collection('Folders').doc().set({'name':title});
  }

  @override
  void initState() {
    getData();
    searchData();
    super.initState();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Name of the Folder'),
            content: TextField(
              controller: nameFold,
              decoration: InputDecoration(
                  hintText: '',
                errorText: err
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    if(nameFold.text.isNotEmpty){
                      setState(() {
                        given = false;
                      });
                      sendData(nameFold.text);
                      getData();
                      Foldname.add(nameFold.text);
                      Navigator.pop(context as BuildContext);
                      nameFold.clear();
                    }
                  },
                  child: Text('OK')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    nameFold.clear();
                  },
                  child: Text('Cancel')
              ),
            ],

          );
        });
  }
  int _selectedIndex = 0;
  void _onItemTapped(index){
    setState(() {
      _selectedIndex = index;
    });
  }
  // Future whenOkIsPressed()async{
  //   if(nameFold.text.isNotEmpty){
  //     while(Foldname.isNotEmpty){
  //       for(var i=0;i<=Foldname.length;i++){
  //         if(nameFold.text == Foldname[i]){
  //           same = true;
  //         }
  //       }
  //     }
  //     if(same = false){
  //       Foldname.add(nameFold.text);
  //       barName = nameFold.text;
  //       given = true;
  //       print(given);
  //       print(Foldname.length);
  //       Navigator.pop(context as BuildContext);
  //       nameFold.clear();
  //     }
  //
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffol_key,
      backgroundColor: Colors.yellow[100],
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan[900],
              ),
              child: Text('Side bar', style: TextStyle(color: Colors.white),),
            ),
            ListTile(
              title: const Text('Notes'),
              selected: _selectedIndex == 0,
              selectedTileColor: Colors.yellow[100],
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Backup'),
              selected: _selectedIndex == 1,
              selectedTileColor: Colors.yellow[100],
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              selected: _selectedIndex == 2,
              selectedTileColor: Colors.yellow[100],
              onTap: () {
                _onItemTapped(2);
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => settings()));
              },
            ),
            ListTile(
              title: const Text('Account'),
              selected: _selectedIndex == 3,
              selectedTileColor: Colors.yellow[100],
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.cyan[900],
            pinned: true,
            flexibleSpace: Container(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Text('NOTES', style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: 50,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: GestureDetector(
                    child: TextField(
                      controller: search,
                      onChanged: (text){
                        setState(() {
                          if(search.text.isNotEmpty){
                            forSearch = true;
                            print('search initiated');
                            performSearch(search.text);
                          }else{
                            forSearch = false;
                          }
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search notes',
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Icon(Icons.search, color: Colors.grey,)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                      width: MediaQuery.of(context).size.width*0.95,
                      height: 500,
                      child: forSearch ? searchCompleted ? Container(
                        width: MediaQuery.of(context).size.width ,
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          itemCount: filteredTitles.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  viewNote(documentId: forPath[filteredTitles[index]]![4]['doc3'], docuId: forPath[filteredTitles[index]]![2]['doc2'], collId: forPath[filteredTitles[index]]![3]['colname2'], docId: forPath[filteredTitles[index]]![0]['doc1'], colname: forPath[filteredTitles[index]]![1]['colname'])
                                  ));
                                },
                                child: ListTile(
                                  title: Text(filteredTitles[index]),
                                  tileColor: Colors.yellow[100],
                                ),
                              );
                            }
                        ),
                      ) : Center(child: Text('Please wait a moment'),): given1 ? !given ? Center(
                        child: Column(
                          children: [
                            Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ) :
                      ListView.builder(
                          itemCount: dataMap.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                //print(Foldname[index]);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        sub_files(text: dataMap[index]['name'], docId: docList[index].toString(), colname: dataMap[index]['name'].toString()))
                                );
                              },
                              child: Card(
                                color: Colors.cyan[700],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(dataMap[index]['name'], style: TextStyle(
                                        color: Colors.white
                                    ),),
                                    leading: Icon(
                                      Icons.folder, color: Colors.white,),
                                    trailing: Container(
                                      width: 50,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Delete"),
                                                        content: Text(
                                                            'This folder will be deleted'),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator
                                                                    .of(
                                                                    context)
                                                                    .pop();
                                                                onFolderDeleted(
                                                                    index);
                                                              },
                                                              child: Text(
                                                                  'OK')
                                                          ),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator
                                                                    .of(
                                                                    context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  'Cancel')
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                );
                                              },
                                              icon: Icon(Icons.delete,
                                                color: Colors.white,)
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                      ) : Center(child: Text('There is no notes'))
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            count++;
            print(count);
            _displayTextInputDialog(context);
          });
        },
        tooltip: 'Add folder',
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.cyan[900],
      ),
    );
  }

  void onFolderDeleted(int index) {
    setState(() {
      print('The doclist being removed: ${docList[index]}');
      print('the data being removed: ${dataMap[index]}');
      FirebaseFirestore.instance.collection('Folders').doc(docList[index]).delete();
      docList.removeAt(index);
      dataMap.removeAt(index);
      getData();
      if(docList.isEmpty){
        given1 = false;
      }
    });
  }

  void searchOperation(String searchTxt){

  }
}

// String? ValidateName(String value){
//   if(value.isEmpty){
//     return 'Please enter a Name';
//   }
//     return null;
// }
//TODO: THIS SHIT!!
// class Intact{
//
//   Intact({required this.text});
// }
