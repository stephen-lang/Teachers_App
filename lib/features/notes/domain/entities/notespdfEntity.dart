class  notespdfEntity {
  final String Pdfid;
  final String posterId;
  final String fileName;
  final String lessonplanUpload;
  final DateTime generatedAt;
  final String  schoolId;
 
notespdfEntity({
    required this.Pdfid,
    required this.posterId,
    required this.fileName,
    required this.lessonplanUpload,
    required this.generatedAt,
    required this.schoolId,
  });
}