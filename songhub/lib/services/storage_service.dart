import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> loadImage(String image) async {
    return await _storage.ref().child(image).getDownloadURL();
  }

  Future uploadFile(String collection, _image) async {    
    
  //   StorageReference ref = _storage.ref().child('chats/${Path.basename(_image.path)}}');    
  //   StorageUploadTask uploadTask = ref.putFile(_image);    
  //   await uploadTask.onComplete;
    
  //   return  ref.getDownloadURL();
  return null;
  }  
}
