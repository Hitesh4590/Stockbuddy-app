import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/model/channel.dart';

class ChannelProvider extends ChangeNotifier {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  XFile? get image => _image;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  //
  //
  String get channelImage => _channelImage;
  String _channelImage = '';
  Future<void> initChannelImage(image) async {
    _channelImage = image;
    notifyListeners();
  }

  Future<void> channelImageChange() async {
    var newImage = await _picker.pickImage(source: ImageSource.gallery);
    if (newImage != null) {
      _channelImage = await uploadImages(newImage);
    }

    notifyListeners();
  }

  Future<void> clearChannelImage() async {
    _channelImage = '';
    notifyListeners();
  }

  //
  //
  //

  Future<void> getImage() async {
    _image = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  Future<void> removeImage() async {
    _image = null;
    notifyListeners();
  }

  String downloadUrl = '';
  Future<String> uploadImages(image) async {
    final File file = File(image!.path);
    final String fileName =
        'images/${DateTime.now().millisecondsSinceEpoch.toString()}';
    try {
      // Upload to Firebase Storage
      final UploadTask uploadTask =
          FirebaseStorage.instance.ref(fileName).putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      downloadUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }

    return downloadUrl;
  }

  Future<String> addChannel(ChannelModel channel) async {
    try {
      await usersCollection
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Channel')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('User_Channel')
          .doc()
          .set(channel.toMap())
          .then((value) => print('Channel Added'));
      return 'success';
    } catch (e) {
      return 'Error adding Channel';
    }
  }

  List<ChannelModel> _sysChannel = [];

  List<ChannelModel> get sysChannel => _sysChannel;
  List<ChannelModel> _userChannel = [];

  List<ChannelModel> get userChannel => _userChannel;

  Future fetchChannel() async {
    final QuerySnapshot querySnapshot = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Channel')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('User_Channel')
        .get();
    _userChannel = querySnapshot.docs
        .map((doc) => ChannelModel.fromDocument(doc))
        .toList();

    final QuerySnapshot querySnapshot1 = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Channel')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('System_Channel')
        .get();
    _sysChannel = querySnapshot1.docs
        .map((doc) => ChannelModel.fromDocument(doc))
        .toList();
    notifyListeners();
  }

  Future<void> deleteChannel(ChannelModel channel) async {
    await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Channel')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('User_Channel')
        .where('title', isEqualTo: channel.channelName)
        .where('image', isEqualTo: channel.image)
        .get()
        .then((querySnapshot) async {
      for (var document in querySnapshot.docs) {
        await document.reference.delete();
      }
    });
    await fetchChannel();
  }

  Future<void> updateChannel(
      ChannelModel channel, String image, String title, String notes) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      if (userId != null) {
        final querySnapshot = await usersCollection
            .doc(userId)
            .collection('Channel')
            .doc(userId)
            .collection('User_Channel')
            .where('title', isEqualTo: channel.channelName)
            .where('image', isEqualTo: channel.image)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.update({
            'title': title,
            'image': image,
            'notes': notes,
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
