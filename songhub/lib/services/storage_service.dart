import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> loadImage(String image) async {
    var result;
    try {
      result = await _storage.ref().child(image).getDownloadURL();
    } catch (err) {
      print(err);
      result = 'assets/placeholderCover.png';
    }
    return result;
  }

  Future<String> uploadFile(String collection, _image) async {    
    
    StorageReference ref = _storage.ref().child('$collection/${basename(_image.path)}}');    
    StorageUploadTask uploadTask = ref.putFile(_image);    
    await uploadTask.onComplete;
    
    return await ref.getDownloadURL() as String;
  }  
}
