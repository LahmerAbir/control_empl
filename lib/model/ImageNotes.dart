class ImageNote {
  String? id;
  String? roomId;
  String? cleanerId;
  String? text;
  String? createdAt;
  String? updatedAt;
  List<Images>? images;

  ImageNote(
      {this.id,
        this.roomId,
        this.cleanerId,
        this.text,
        this.createdAt,
        this.updatedAt,
        this.images});

  ImageNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    cleanerId = json['cleaner_id'];
    text = json['text'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_id'] = this.roomId;
    data['cleaner_id'] = this.cleanerId;
    data['text'] = this.text;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? id;
  String? noteId;
  String? imageUrl;
  String? uploadedBy;
  String? uploadedAt;

  Images(
      {this.id, this.noteId, this.imageUrl, this.uploadedBy, this.uploadedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noteId = json['note_id'];
    imageUrl = json['image_url'];
    uploadedBy = json['uploaded_by'];
    uploadedAt = json['uploaded_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['note_id'] = this.noteId;
    data['image_url'] = this.imageUrl;
    data['uploaded_by'] = this.uploadedBy;
    data['uploaded_at'] = this.uploadedAt;
    return data;
  }
}