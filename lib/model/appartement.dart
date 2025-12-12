class Appartement {
  String? id;
  String? buildingId;
  String? floorId;
  String? name;
  String? roomType;
  String? description;
  String? createdAt;
  String? updatedAt;

  Appartement(
      {this.id,
        this.buildingId,
        this.floorId,
        this.name,
        this.roomType,
        this.description,
        this.createdAt,
        this.updatedAt});

  Appartement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buildingId = json['building_id'];
    floorId = json['floor_id'];
    name = json['name'];
    roomType = json['room_type'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['building_id'] = this.buildingId;
    data['floor_id'] = this.floorId;
    data['name'] = this.name;
    data['room_type'] = this.roomType;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}