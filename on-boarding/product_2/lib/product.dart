class Product {
  String _name;
  String _description;
  double _price;

  Product(this._name, this._description, this._price);

  // Getters
  String get name => _name;
  String get description => _description;
  double get price => _price;

  // Setters
  set name(String newName) {
    if (newName.isNotEmpty) {
      _name = newName;
    }
  }

  set description(String newDescription) {
    if (newDescription.isNotEmpty) {
      _description = newDescription;
    }
  }

  set price(double newPrice) {
    if (newPrice > 0) {
      _price = newPrice;
    }
  }
}
