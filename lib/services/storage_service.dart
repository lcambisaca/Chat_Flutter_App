import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageService() {}

  Future<String?> uploadUserPfp({
    required File file,
    required String uid,
  }) async {
    Reference fileRef = _firebaseStorage //the instance of our firebase storage
        .ref('/users/pfp') //created a folder that has another folder
        .child(
            '$uid${p.extension(file.path)}'); //name of the file we do this to make it unqiue
    UploadTask task = fileRef.putFile(file); // puts file in sotrgae
    return task.then(
      (g) {
        // we use then when we want to acess something when the thing here task is done
        if (g.state == TaskState.success) {
          // so once task is done we check if it was successful and then return the url
          return fileRef.getDownloadURL();
        }
      },
    );
  }

  Future<String?> uploadImagetoChat(
      {required File file, required String chatID}) async {
    Reference fileRef = _firebaseStorage
        .ref("chats/$chatID") //created a unqie
        .child('${DateTime.now().toIso8601String()}${p.extension(file.path)}'); //p.extension is the actual extension of the file the user selected
      UploadTask task = fileRef.putFile(file);
      return task.then(
      (p) {
        if (p.state == TaskState.success) {
          return fileRef.getDownloadURL();
        }
      },
    );

  }
}
