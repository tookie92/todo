import 'package:flutter/material.dart';
import 'package:todo/model/item.dart';
import 'package:todo/screens/ajout_articles.dart';

import 'package:todo/widgets/donnees_vides.dart';
import 'package:todo/model/article.dart';
import 'package:todo/model/databaseClient.dart';
import 'dart:io';

class ItemDetail extends StatefulWidget {
  Item item;

  ItemDetail( Item item){
    this.item = item;
  }

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  List<Article> articles;

  @override
  void initState(){
    super.initState();
    DatabaseClient().allArticles(widget.item.id).then((liste) {
      setState((){
        articles = liste;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.item.nom),
          actions: <Widget> [
            FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return Ajout(widget.item.id);
                  })).then((value){
                    print('On est de retour');
                    DatabaseClient().allArticles(widget.item.id).then((liste) {
                      setState((){
                        articles = liste;
                      });
                    });
                  });
                },
                child:Text(
                  'Ajouter',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
            )
          ],
        ),
        body: (articles == null || articles.length == 0)?
        DonneesVides():
        GridView.builder(
            itemCount: articles.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemBuilder: (context, i){
              Article article = articles[i];
              return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(article.nom, textScaleFactor: 1.4,),
                      Container(
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: (article.image == null)
                            ? Image.asset('assets/images/no-image.png')
                            : Image.file(File(article.image)),
                      ),

                      Text((article.prix == null)? 'Aucun prix renseignè' : 'Prix: ${article.prix}'),
                      Text((article.magasin == null)? 'Aucun magasin renseigné': 'Magasin : ${article.magasin}')
                    ],
                  )
              );
            })


    );
  }
}
