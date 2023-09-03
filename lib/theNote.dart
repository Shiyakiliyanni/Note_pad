import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  final String docuId;
  final String collId;
  final String docId;
  final String colname;
  const Note({Key? key, required this.docuId, required this.collId, required this.docId, required this.colname}) : super(key: key);

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  TextEditingController title = TextEditingController();
  TextEditingController nte = TextEditingController();

  List<Color> bg = [Colors.white, Colors.lightBlueAccent, Colors.lightGreenAccent, Colors.orangeAccent];
  List bg1 = [Colors.black, Colors.blue[900], Colors.green[900], Colors.deepOrange[900]];
  Color defbg = Colors.white;
  Color defTxtCol = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defbg,
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        title: Text(
          "Add note",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showColorPicker(context);
            },
            icon: Icon(Icons.edit, color: Colors.white),
          )
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextField(
                        controller: title,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(fontSize: 24)),
                      ),
                      TextField(
                        controller: nte,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(fontSize: 18.0, color: defTxtCol),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type here',
                            hintStyle: TextStyle(fontSize: 24)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Save();
          Navigator.pop(context);
        },
        tooltip: 'Save note',
        child: Icon(Icons.save_alt_rounded, color: Colors.white,),
        backgroundColor: Colors.cyan[900],
      ),
    );
  }

  void Save(){
    FirebaseFirestore.instance.collection('Folders').doc(widget.docId).collection(widget.colname).doc(widget.docuId).collection(widget.collId).add(
        {'Title': title.text, 'content': nte.text,
          'bgcolor': defbg.value, 'txtcolor': defTxtCol.value
        });
  }
  void _showColorPicker(BuildContext context) async {
    final selectedColor = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.black26,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bg.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    defbg = bg[index];
                    defTxtCol = bg1[index];
                  });
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
                child: Container(
                  height: 210,
                  width: 150,
                  margin: EdgeInsets.all(20),
                  color: bg[index],
                ),
              );
            },
          ),
        );
      },
    );

    if (selectedColor != null) {
      setState(() {
        defbg = selectedColor;
      });
    }
  }
}
