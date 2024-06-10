import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/model/channel.dart';
import 'package:stockbuddy_flutter_app/model/inventory.dart';
import 'package:stockbuddy_flutter_app/model/user.dart';

class DatabaseService {
  final _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

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
      await addSystemChannel();
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

  Future<void> addSystemChannel() async {
    List<ChannelModel> systemChannels = [
      ChannelModel(
          id: '',
          channelName: 'WhatsApp',
          image:
              'https://firebasestorage.googleapis.com/v0/b/stockbuddy-dev.appspot.com/o/images%2Fwhatsapp.png?alt=media&token=f0eeeafc-775c-4c2b-a208-c34733d2e74b',
          notes: ''),
      ChannelModel(
          id: '',
          channelName: 'Facebook',
          notes: '',
          image:
              'https://firebasestorage.googleapis.com/v0/b/stockbuddy-dev.appspot.com/o/images%2Ffacebook.png?alt=media&token=2cede3bc-b0ed-43a1-bf38-49d00a570ba3'),
      ChannelModel(
          id: '',
          channelName: 'Instagram',
          notes: '',
          image:
              'https://firebasestorage.googleapis.com/v0/b/stockbuddy-dev.appspot.com/o/images%2Finstagram.png?alt=media&token=a0bc4da4-e86f-4d50-81bf-f0d83a886c22'),
    ];
    for (int i = 0; i < systemChannels.length; i++) {
      try {
        await usersCollection
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('Channel')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('System_Channel')
            .doc()
            .set(systemChannels[i].toMap())
            .then((value) => print('System Channels Added'));
      } catch (e) {
        print('error adding system channel');
      }
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
      return 'Error adding Inventory';
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
