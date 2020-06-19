import 'package:cloud_firestore/cloud_firestore.dart';

class Recording {
  final String id;
  final String name;
  String image;
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
        name: map["name"],
        image: map["image"] ?? "",
        storagePath: map["storagePath"] ?? "",
        timestamp: map["timestamp"],
        version: map["version"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "participantImg": image,
      "storagePath": storagePath,
      "timestamp": timestamp,
      "version": version,
    };
  }
}
