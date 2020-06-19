import 'package:cloud_firestore/cloud_firestore.dart';

class Recording {
  final String id;
  final String name;
  final String image;
  final String storagePath;
  final Timestamp timestamp;
  final String version;

  Recording(
      {this.id,
      this.name,
      this.image,
      this.timestamp,
      this.storagePath,
      this.version});

  /// Create Records instance from Firestore DocumentSnapshot
  factory Recording.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Recording(
        id: doc.documentID,
        name: data["name"],
        image: data["image"] ?? "",
        storagePath: data["storagePath"] ?? "",
        timestamp: data["timestamp"],
        version: data["version"]);
  }

  /// Create Records instance from map
  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
        id: map["id"],
        name: map["data"]["name"],
        image: map["data"]["image"] ?? "",
        storagePath: map["data"]["storagePath"] ?? "",
        timestamp: map["data"]["timestamp"],
        version: map["data"]["version"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": image,
      "storagePath": storagePath,
      "timestamp": timestamp,
      "version": version,
    };
  }
}
