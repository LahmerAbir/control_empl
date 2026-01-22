class PlanningCleaner {
  String? id;
  String? cleanerId;
  String? buildingId;
  String? roomId;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  String? status;
  Building1? building;
  Building1? room;

  PlanningCleaner({
    this.id,
    this.cleanerId,
    this.buildingId,
    this.roomId,
    this.startDate,
    this.status,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.building,
    this.room,
  });

  PlanningCleaner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cleanerId = json['cleaner_id'];
    buildingId = json['building_id'];
    roomId = json['room_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    building = json['building'] != null
        ? new Building1.fromJson(json['building'])
        : null;
    room = json['room'] != null ? new Building1.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cleaner_id'] = this.cleanerId;
    data['building_id'] = this.buildingId;
    data['room_id'] = this.roomId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.building != null) {
      data['building'] = this.building!.toJson();
    }
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    return data;
  }

  PlanningCleaner copyWith({
    String? cleanerId,
    String? buildingId,
    String? roomId,
    String? startDate,
    String? endDate,
    String? status,
  }) {
    return PlanningCleaner(
      id: id,
      cleanerId: cleanerId ?? this.cleanerId,
      buildingId: buildingId ?? this.buildingId,
      roomId: roomId ?? this.roomId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status ?? this.status,
      building: building,
      room: room,
    );
  }
}

class Building1 {
  String? name;

  Building1({this.name});

  Building1.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
