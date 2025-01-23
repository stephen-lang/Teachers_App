 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notesEntity.dart';

class NotesModel extends Notesentity {
  NotesModel({required super.noteId, required super.grade, required super.indicators, required super.contentStandard, required super.substrand, required super.strand, required super.classSize, required super.Subject, required super.posterId, required super.updatedAt,super.lessonNote});
  Map<String, Object?> toDocument() {
    return {
    'noteId':noteId,
    'grade':grade,
    'indicators':indicators,
    'contentStandard':contentStandard,
    'substrand':substrand,
    'strand':strand,
    'classSize':classSize,
    'subject':Subject,
    'posterId': posterId,
    'updatedAt': updatedAt.toIso8601String(), 
    "lessonNote": lessonNote,
    };
  }
 Map<String, dynamic> toJson() {
    return {
      "noteId": noteId,
      "grade": grade,
      "indicators": indicators,
      "contentStandard": contentStandard,
      "substrand": substrand,
      "strand": strand,
      'classSize':classSize,
      "subject": Subject,
      "posterId": posterId,
      "updatedAt": updatedAt.toIso8601String(),
      "lessonNote": lessonNote,
    };
  }
  static NotesModel fromEntity(entity) {
  // Adding error handling and default values
  return NotesModel(
    noteId: entity.noteId,  // Default to -1 if null
    grade: entity.grade,  // Default to -1 if null
    indicators: entity.indicators.isNotEmpty ? entity.indicators : 'No indicators provided', // Check for empty string
    contentStandard: entity.contentStandard.isNotEmpty ? entity.contentStandard : 'No content standard provided', // Check for empty string
    substrand: entity.substrand.isNotEmpty ? entity.substrand : 'No substrand provided', // Check for empty string
    strand: entity.strand.isNotEmpty ? entity.strand : 'No strand provided', // Check for empty string
    classSize: entity.classSize > 0 ? entity.classSize : 0,  // Ensure valid class size
    Subject: entity.Subject.isNotEmpty ? entity.Subject : 'No subject provided', // Check for empty string
    posterId: entity.posterId.isNotEmpty ? entity.posterId : throw Exception('Poster ID is required'), // Require a posterId or throw error
    updatedAt: entity.updatedAt, // Default to current date if null
    lessonNote: entity.lessonNote,
  );
}

  //from document or from Json 
  static Notesentity fromDocument(Map<String, dynamic> doc) {
    return Notesentity(
    noteId:doc['noteId'],
    grade:doc['grade'],
    indicators:doc['indicators'],
    contentStandard:doc['contentStandard'],
    substrand:doc['substrand'],
    strand:doc['strand'],
    classSize:doc['classSize'],
    Subject: doc['subject'],
    posterId: doc['posterId'], 
    updatedAt: (doc['updatedAt'] != null && doc['updatedAt'] is Timestamp)
            ? (doc['updatedAt'] as Timestamp).toDate()
            : DateTime.now(), // Parse string back to DateTime
    lessonNote: doc["lessonNote"],);
  }

  @override
  String toString() {
    return 'NotesModel(noteId: $noteId, grade: $grade, indicators: $indicators)';
  }
}
