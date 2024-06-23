import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService{

  Future addHomeTask(Map<String,dynamic> usermap,String id)async{
    return await FirebaseFirestore.instance
        .collection('Home')
        .doc(id)
        .set(usermap);
  }
  Future addTutionTask(Map<String,dynamic> usermap,String id)async{
    return await FirebaseFirestore.instance
        .collection('Tuition')
        .doc(id)
        .set(usermap);
  }
  Future addSchoolTask(Map<String,dynamic> usermap,String id)async{
    return await FirebaseFirestore.instance
        .collection('School')
        .doc(id)
        .set(usermap);
  }

  Future<Stream<QuerySnapshot>>getTask(String Task)async{
    return await FirebaseFirestore.instance.collection(Task).snapshots();

  }
    deleteTask(String id, String task) async {
    return await FirebaseFirestore.instance.collection(task).doc(id).update({"yes":true});

  }
  removeTask(String id, String task) async {
    return await FirebaseFirestore.instance.collection(task).doc(id).delete();

  }
}