import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_pad/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sub_files extends StatefulWidget {

  final String text;
  sub_files({required this.text});

  @override
  State<sub_files> createState() => _sub_filesState();
}

class _sub_filesState extends State<sub_files> {

  List instances = [];


  TextEditingController txt = TextEditingController();
  bool given1 = false;
  List Foldname1 = [];
  int count1 = 0;
  late String file1;
  Future<void> _displayTextInputDialog1(BuildContext context, subFile file) async {
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
                    setState(() {
                      Foldname1.add(txt.text);
                      given1 = true;
                      Navigator.pop(context);
                      txt.clear();
                      file.theclick(count1, txt.text);
                    });
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
            child: ListView.builder(
                itemCount: Foldname1.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.95,
                      height: 50,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.cyan[100]
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.folder, color: Colors.white,),
                          SizedBox(
                            width: 5,
                          ),
                          Text((given1 ?  Foldname1[index] : 'Folder name'), style:
                          TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),
                  );
                }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          count1++;
          subFile a = subFile();
          _displayTextInputDialog1(context, a);
        },
        tooltip: 'Add folder',
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
class subFile{
  int count2 = 0;
  String foN ='';

  void theclick(int l, String a){
    List c = List.generate(l, (index) => null);
    a = foN;
    c.add(foN);
  }
}