import 'package:cloud_firestore/cloud_firestore.dart';

class Recording {
  final String id;
  final String label;
  final String image;
  final String storagePath;
  final Timestamp timestamp;
  final String versionDescription;

  Recording(
      {this.id,
      this.label,
      this.image,
      this.timestamp,
      this.storagePath,
      this.versionDescription});

  /// Create Records instance from Firestore DocumentSnapshot
  factory Recording.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Recording(
        id: doc.documentID,
        label: data["label"],
        image: data["image"] ?? "",
        storagePath: data["storagePath"] ?? "",
        timestamp: data["timestamp"],
        versionDescription: data["versionDescription"]);
  }

  /// Create Records instance from map
  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
        id: map["id"],
        label: map["data"]["label"],
        image: map["data"]["image"] ?? "",
        storagePath: map["data"]["storagePath"] ?? "",
        timestamp: map["data"]["timestamp"],
        versionDescription: map["data"]["versionDescription"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "label": label,
      "image": image,
      "storagePath": storagePath,
      "timestamp": timestamp,
      "versionDescription": versionDescription,
    };
  }
}
