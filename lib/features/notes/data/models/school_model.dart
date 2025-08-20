// data/models/school_model.dart
 
import '../../domain/entities/school.dart';

class SchoolModel extends School {
  SchoolModel({
    required super.id,
    required super.schoolName,
    required super.schoolCode,
  });

  factory SchoolModel.fromMap(String id, Map<String, dynamic> map) {
    return SchoolModel(
      id: id,
      schoolName: map['schoolName'] ?? '',
      schoolCode: map['schoolCode'] ?? '',
    );
  }
}
