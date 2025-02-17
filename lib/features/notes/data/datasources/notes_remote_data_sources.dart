import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teacherapp_cleanarchitect/core/error/exceptions.dart';
import 'package:teacherapp_cleanarchitect/features/notes/data/models/notes_model.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notesEntity.dart';

abstract interface class NotesRemoteDataSources {
  Future<NotesModel> uploadNotes(NotesModel notes);
  Future<List<NotesModel>> downloadNotes(String posterId);
   Future<void> deleteNotes(String noteId);
  //most def read
}

class NotesRemoteDataSourcesImpl implements NotesRemoteDataSources {
  final FirebaseFirestore _firestore;
  // ignore: unused_field
  final FirebaseAuth _firebaseAuth;

  NotesRemoteDataSourcesImpl(this._firebaseAuth, this._firestore) {
    // Initialize the auth listener in the constructor
  }
  @override
  Future<List<NotesModel>> downloadNotes(String posterId) async {
    try {
      // Fetch all notes for the current user
      QuerySnapshot snapshot = await _firestore
          .collection('notes')
          .where('posterId', isEqualTo: posterId)
          .get();
//print("Query Snapshot: ${snapshot.docs.length} docs found");

      if (snapshot.docs.isNotEmpty) {
        // Map the result and cast to List<NotesModel>
        List<NotesModel> notesList = snapshot.docs.map((doc) {
          // Use the fromDocument method to parse the Firestore document into an entity
          final Notesentity entity = NotesModel.fromDocument(doc.data() as Map<String, dynamic>);

          // Now convert the entity to a NotesModel using the fromEntity method
          return NotesModel.fromEntity(entity);
        }).toList();
        print("Notes List: ${notesList.length} found");
        return notesList;
        // print("Query Snapshot: ${notesList.length} docs found");
      } else {
        //print("No documents found for posterId: $posterId");
        return [];
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

@override
Future<NotesModel> uploadNotes(NotesModel notes) async {
  try {
    // Create a new document reference with a Firestore-generated ID
    DocumentReference documentRef = _firestore.collection('notes').doc();

    // Attach Firestore-generated ID as noteId
    NotesModel updatedNotes = notes.copyWith(noteId: documentRef.id);

    // Save the note to Firestore with the new noteId
    await documentRef.set(updatedNotes.toDocument());

    // Retrieve the saved document
    DocumentSnapshot docSnapshot = await documentRef.get();

    if (docSnapshot.exists) {
      // Convert Firestore document back to NotesModel
      Notesentity uploadedNotes = NotesModel.fromDocument(
        docSnapshot.data() as Map<String, dynamic>,
      );
      return NotesModel.fromEntity(uploadedNotes);
    } else {
      print("No document found after submission.");
      return NotesModel(
        noteId: '',
        grade: 0,
        indicators: '',
        contentStandard: '',
        substrand: '',
        strand: '',
        classSize: 0,
        Subject: '',
        posterId: '',
        updatedAt: DateTime.now(),
        lessonNote: '',
      );
    }
  } catch (e) {
    throw ServerException(message: e.toString());
  }
}

  
  @override
  Future<void> deleteNotes(String UniqueId) async{
   try {
      await _firestore.collection('notes').doc(UniqueId).delete();
     } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
