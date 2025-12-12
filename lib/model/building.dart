class Building {
  String? id;
  String? name;
  String? address;
  String? description;
  String? createdAt;
  String? updatedAt;

  Building(
      {this.id,
        this.name,
        this.address,
        this.description,
        this.createdAt,
        this.updatedAt});

  Building.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}