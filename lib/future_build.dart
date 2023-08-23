import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FutureBuild extends StatefulWidget {
  const FutureBuild({Key? key}) : super(key: key);

  @override
  State<FutureBuild> createState() => _FutureBuildState();
}

class _FutureBuildState extends State<FutureBuild> {

  getData()async{
    CollectionReference cr = FirebaseFirestore.instance.collection('Folders');
    DocumentSnapshot ds = await cr.doc('folder').get();
    var data = ds.data();
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            var data = snapshot.data as Map;
            print('Data = $data');
            return Container(
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (cntxt, index){
                    return Card(
                      child: ListTile(
                        title: Text(data['name']),
                      ),
                    );
                  }),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
