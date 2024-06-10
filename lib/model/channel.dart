import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelModel {
  String id;
  String channelName;
  String notes;
  String image;

  ChannelModel({
    required this.id,
    required this.channelName,
    required this.notes,
    required this.image,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'title': channelName,
      'notes': notes,
      'image': image,
    };
  }

  // Extract a User object from a DocumentSnapshot
  factory ChannelModel.fromDocument(DocumentSnapshot doc) {
    return ChannelModel(
      id: doc.id,
      channelName: doc['title'],
      notes: doc['notes'],
      image: doc['image'],
    );
  }
}
