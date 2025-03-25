import '../../domain/entities/notespdfEntity.dart';

class Notespdfmodel extends notespdfEntity {
  Notespdfmodel(
      {required super.Pdfid,
      required super.posterId,
      required super.fileName,
      required super.generatedAt, 
      required super.lessonplanUpload});
  Map<String, dynamic> toDocument() {
    return {
      'Pdfid': Pdfid,
      'posterId': posterId,
      'fileName': fileName,
      'generatedAt': generatedAt,
      'lessonplanUpload': lessonplanUpload,
    };
  }

  /// Create a new instance with updated fields
  Notespdfmodel copyWith({
    String? Pdfid,
    String? posterId,
    String? fileName,
    String? lessonplanUpload,
    DateTime? generatedAt,
  }) {
    return Notespdfmodel(
      Pdfid: Pdfid ?? this.Pdfid,
      posterId: posterId ?? this.posterId,
      fileName: fileName ?? this.fileName,
      lessonplanUpload: lessonplanUpload ?? this.lessonplanUpload,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  static Notespdfmodel fromEntity(entity) {
    // Adding error handling and default values
    return Notespdfmodel(
      Pdfid: entity.Pdfid,
      posterId: entity.posterId,
      fileName: entity.fileName,
      lessonplanUpload:entity.lessonplanUpload,
      generatedAt: entity.generatedAt,
    );
  }

 //from document or from Json 
  static notespdfEntity fromDocument(Map<String, dynamic> doc) {
    return notespdfEntity(
    Pdfid:doc['noteId'],
    posterId: doc['posterId'],
    fileName: doc['fileName'],
    lessonplanUpload: doc['lessonplanUpload'],
    generatedAt: doc['generatedAt']
    );
  }
}
