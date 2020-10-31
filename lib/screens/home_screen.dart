import 'package:flutter/material.dart';
import 'package:todo/model/item.dart';

//ajouter async pour le dialogue
import 'dart:async';
import 'package:todo/widgets/donnees_vides.dart';
import 'package:todo/model/databaseClient.dart';
import 'package:todo/widgets/item_detail.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String nouvelleListe;
  List<Item> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Hallo'),
        actions: [
          FlatButton(
              onPressed: (() => ajouter(null)),
              child: Text(
                'Ajouter',
                style: TextStyle(
                  color: Colors.red,
                ),
              )
          ),
        ],
      ),
      body: (items == null || items.length == 0)?
      DonneesVides():
      ListView.builder(
          itemCount: items.length,
          itemBuilder: (context,i){
            Item item = items[i];
            return ListTile(
              title: Text(item.nom),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  DatabaseClient().delete(item.id, 'item').then((int) {
                    print("L'int recuperer est: $int ");
                    recuperer();
                  });
                },
              ),
              leading: IconButton(
                icon: Icon(Icons.edit),
                onPressed: (() => ajouter(item)),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContext)=> ItemDetail(item))),
            );

          }
      )
      ,
    );
  }

  // Comment ajouter un dialogue
  Future<Null> ajouter(Item item) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext){
          return AlertDialog(
            title: Text('Ajouter une liste de jouets', overflow: TextOverflow.ellipsis,),
            content: TextField(
              decoration: InputDecoration(
                labelText: 'Liste',
                hintText: (item == null) ?'Ex: mes prochains jeux videos' : item.nom,
              ),
              onChanged: (String str){
                nouvelleListe = str;
              },
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(buildContext),
                child: Text(
                    'Annuler'
                ),
              ),
              FlatButton(
                onPressed: () {
                  // Ajouter le code pour pouvoir ajouter a la base de donnees

                  if(nouvelleListe != null){
                    if(item == null){
                      item = new Item();
                      Map<String, dynamic> map = {'nom': nouvelleListe};
                      item.fromMap(map);
                    }else{
                      item.nom = nouvelleListe;
                    }
                    DatabaseClient().upsertItem(item).then((i) => recuperer());
                    nouvelleListe = null;
                  }
                  Navigator.pop(buildContext);
                },
                child: Text(
                  'Valider',
                  style: TextStyle(
                      color: Colors.green
                  ),
                ),
              )

            ],
          );
        }
    );
  }

  void recuperer(){
    DatabaseClient().allItem().then((items) {
      setState(() {
        this.items =items;
      });
    });
  }
}
