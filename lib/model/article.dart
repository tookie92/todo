class Article{

  int id;
  int item;
  String prix;
  String magasin;
  String nom;
  String image;


  Article();

  void fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.item = map['item'];
    this.prix = map['prix'];
    this.magasin = map['magasin'];
    this.nom = map['nom'];
    this.image = map['image'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'item' : this.item,
      'prix' : this.prix,
      'magasin': this.magasin,
      'nom' : this.nom,
      'image' : this.image
    };

    if(id != null){
      map['id'] = this.id;
    }

    return map;
  }

}