import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  String? id;
  String? email;
  String? name;
  String? photo;
  String? address;

  Company({
    this.id,
    this.email,
    this.name,
    this.photo,
    this.address,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'company_email': email,
      'company_name': name,
      'company_photo': photo,
      'company_address': address,
    };
  }

  // Extract a User object from a DocumentSnapshot
  factory Company.fromDocument(DocumentSnapshot doc) {
    return Company(
      id: doc.id,
      email: doc['company_email'],
      name: doc['company_name'],
      address: doc['company_address'],
      photo: doc['company_photo'],
    );
  }
}
