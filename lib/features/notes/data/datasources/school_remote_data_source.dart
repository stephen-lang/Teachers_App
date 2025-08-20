// data/datasources/school_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/school_model.dart';

abstract class SchoolRemoteDataSource {
  Future<SchoolModel> getSchoolById(String schoolId);
}

class SchoolRemoteDataSourceImpl implements SchoolRemoteDataSource {
  final FirebaseFirestore firestore;

  SchoolRemoteDataSourceImpl(this.firestore );

  @override
  Future<SchoolModel> getSchoolById(String schoolId) async {
    final doc = await firestore.collection('Schools').doc(schoolId).get();

    if (!doc.exists) {
      throw Exception('School not found');
    }

    return SchoolModel.fromMap(doc.id, doc.data()!);
  }
}
