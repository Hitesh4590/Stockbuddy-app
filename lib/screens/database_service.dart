import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/model/inventory.dart';
import 'package:stockbuddy_flutter_app/model/user.dart';
import 'package:stockbuddy_flutter_app/model/order.dart';

class DatabaseService {
  final _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  // final String? uid = FirebaseAuth.instance.currentUser?.uid;

  Future<bool> login(email, password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      await getUser(user.user?.uid);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signup(
    String email,
    password,
    firstname,
    lastname,
    phone,
  ) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final newUser = UserModel(
          id: user.user!.uid,
          email: email,
          firstName: firstname,
          lastName: lastname,
          phone: phone,
          userId: user.user!.uid);
      await addUser(newUser);
      //await addUser(user.user?.uid, email, firstname, lastname, phone);

      await getUser(user.user?.uid);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> addUser(UserModel user) async {
    try {
      usersCollection
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set(user.toMap())
          .then((value) => print('User Added'));
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future<String?> getUser(uid) async {
    try {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      final snapshot = await users.doc(uid).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return 'success';
    } catch (e) {
      return 'Error fetching user';
    }
  }

  Future<String> addInventory(InventoryItem inventory) async {
    try {
      usersCollection
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Inventory')
          .doc()
          .set(inventory.toMap())
          .then((value) => print('Inventory item Added'));
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future logout() async {
    await _auth.signOut();
  }

  List<String> downloadUrls = [];
  Future<List<String>> uploadImages(List<XFile> images) async {
    if (images.isEmpty) return [];

    downloadUrls.clear();
    for (XFile image in images) {
      File file = File(image.path);
      String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch.toString()}';
      try {
        // Upload to Firebase Storage
        UploadTask uploadTask =
            FirebaseStorage.instance.ref(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {
        print(e);
        return [];
      }
    }
    return downloadUrls;
  }
}
