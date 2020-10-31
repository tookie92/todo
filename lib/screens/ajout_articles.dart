import 'package:flutter/material.dart';
import 'dart:io';
import 'package:todo/model/article.dart';
import 'package:todo/model/databaseClient.dart';
import 'package:image_picker/image_picker.dart';

class Ajout extends StatefulWidget {
  int id;

  Ajout(int id){
    this.id = id;
  }
  @override
  _AjoutState createState() => _AjoutState();
}

class _AjoutState extends State<Ajout> {
  String image;
  String nom;
  String magasin;
  String prix;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter'),
        actions: <Widget>[
          FlatButton(
              onPressed: ajouter,
              child:Text(
                'Valider',
                style: TextStyle(
                  color: Colors.orange,
                ),
              )
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Article a ajouter',
              textScaleFactor: 1.4,
              style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic
              ),

            ),

            Card(
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (image == null)?
                  Image.asset('assets/images/no-image.png', fit: BoxFit.cover,)
                      :Image.file(File(image), ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(icon: Icon(Icons.camera_enhance), onPressed: ()=> getImage(ImageSource.camera)),
                      IconButton(icon: Icon(Icons.photo_library), onPressed: ()=> getImage(ImageSource.gallery))
                    ],
                  ),
                  textField(TypeTextField.nom, 'nom de l\'artiicle'),
                  textField(TypeTextField.prix, 'Prix'),
                  textField(TypeTextField.magasin, 'Magasin'),



                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextField textField (TypeTextField type, String label){
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: (String string){
        switch(type){
          case TypeTextField.nom:
            nom = string;
            break;
          case TypeTextField.prix:
            prix = string;
            break;
          case TypeTextField.magasin:
            magasin = string;
            break;
        }
      },
    );

  }

  void ajouter(){
    if(nom != null){
      Map<String, dynamic> map={
        'nom' : nom, 'item' : widget.id
      };

      if(magasin != null){
        map['magasin'] = magasin;
      }

      if(prix != null){
        map['prix'] = prix;
      }

      if(image != null){
        map['image'] = image;
      }
      Article article = Article();
      article.fromMap(map);
      DatabaseClient().upsertArticle(article).then((value) {
        image = null;
        nom = null;
        magasin = null;
        prix = null;
        Navigator.pop(context);
      });

    }

  }

  Future getImage(ImageSource source) async{
    var nouvelleImage = await ImagePicker.pickImage(source: source);
    setState(() {
      image = nouvelleImage.path;
    });
  }
}

enum TypeTextField{ nom, prix , magasin}