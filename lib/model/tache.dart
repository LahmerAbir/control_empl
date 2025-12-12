class TachePlanning {
  String? id;
  String? cleanerId;
  String? buildingId;
  String? roomId;
  String? startDate;
  String? endDate;
  Room? building;
  Room? room;
  String? createdAt;
  String? updatedAt;

  TachePlanning(
      {this.id,
        this.cleanerId,
        this.buildingId,
        this.roomId,
        this.startDate,
        this.endDate,
        this.building,
        this.room,
        this.createdAt,
        this.updatedAt});

  TachePlanning.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cleanerId = json['cleaner_id'];
    buildingId = json['building_id'];
    roomId = json['room_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    building = json['building'] != null
        ? new Room.fromJson(json['building'])
        : null;
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cleaner_id'] = this.cleanerId;
    data['building_id'] = this.buildingId;
    data['room_id'] = this.roomId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    if (this.building != null) {
      data['building'] = this.building!.toJson();
    }
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Room {
  String? name;

  Room({this.name});

  Room.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}