import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String email;
  String firstName;
  String lastName;
  String phone;
  String userId;
  bool isCompany;

  UserModel({
    required this.isCompany,
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userId,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'isCompany': isCompany,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'user_id': userId,
    };
  }

  // Extract a User object from a DocumentSnapshot
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      isCompany: doc['isCompany'],
      id: doc.id,
      email: doc['email'],
      firstName: doc['first_name'],
      lastName: doc['last_name'],
      phone: doc['phone'],
      userId: doc['user_id'],
    );
  }
}
