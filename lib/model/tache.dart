class TachePlanning {
  final String? id;
  final String? cleanerId;
  final String? buildingId;
  final String? roomId;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Cleaner? cleaner;
  final Room? room;

  TachePlanning({
     this.id,
     this.cleanerId,
     this.buildingId,
     this.roomId,
     this.startDate,
    this.endDate,
     this.createdAt,
     this.updatedAt,
    this.cleaner,
    this.room,
  });

  /// FROM JSON
  factory TachePlanning.fromJson(Map<String, dynamic> json) {
    return TachePlanning(
      id: json['id'],
      cleanerId: json['cleaner_id'],
      buildingId: json['building_id'],
      roomId: json['room_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate:
      json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      cleaner:
      json['cleaner'] != null ? Cleaner.fromJson(json['cleaner']) : null,
      room: json['room'] != null ? Room.fromJson(json['room']) : null,
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cleaner_id': cleanerId,
      'building_id': buildingId,
      'room_id': roomId,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'cleaner': cleaner?.toJson(),
      'room': room?.toJson(),
    };
  }
}
class Cleaner {
  final String firstName;
  final String lastName;

  Cleaner({
    required this.firstName,
    required this.lastName,
  });

  factory Cleaner.fromJson(Map<String, dynamic> json) {
    return Cleaner(
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
class Room {
  final String name;

  Room({required this.name});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
