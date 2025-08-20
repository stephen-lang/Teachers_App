import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notesEntity.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notespdfEntity.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/usecases/delete_notes.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/usecases/download_PDF_notes.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/usecases/get_all_notes.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/usecases/uploadPDF_notes.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/usecases/upload_notes.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final UploadPDFNotes _uploadPdfNotes;
  final GetAllNotes _getAllNotes;
  final UploadNotes _uploadNotes;
  final DeleteNoteById _deleteNoteById;
  final GetPDFNotes _getPDFNotes;
    
  NoteBloc({
    required GetPDFNotes  GetPDFNotes,
    required UploadPDFNotes uploadPDFnotes,
    required DeleteNoteById deleteNotes,
    required GetAllNotes getAllNotes,
    required UploadNotes uploadNotes,
  })  : _uploadPdfNotes = uploadPDFnotes,
        _getPDFNotes=GetPDFNotes,
        _getAllNotes = getAllNotes,
        _uploadNotes = uploadNotes,
        _deleteNoteById = deleteNotes,
        super(NoteInitial()) {
    on<NotesFetchAllNotes>(_onNoteDownload);
    on<NotesUploadNotes>(_onNoteUpload);
    on<NoteDeleteNotes>(_onNoteDelete);
    on<NotesFetchPDFNotes>(_onGetPDFNotes);
    on<NotesUploadPDFNotes>(_onNotePDFUpload);

  }



    // Handler for uploading PDF notes
  Future<void> _onNotePDFUpload(
    NotesUploadPDFNotes event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());
    final result = await _uploadPdfNotes( UploadpdfNotesParam(
      posterId: event.posterId,
      Pdfid: event.Pdfid,
      fileName: event.fileName,
      lessonplanUpload:event.lessonplanUpload,
      generatedAt: event.generatedAt,
      schoolId: event.schoolId,
    ));

    result.fold(
      (failure) => emit(Notefailure(message: failure.message)),
      (note) => emit(NoteUploadSuccess()),
    );
  }

  Future<void> _onNoteDelete(
    NoteDeleteNotes event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());

    final result = await _deleteNoteById
        .call(DeleteNotesParams(UniqueId: event.UniqueId)); // Execute use case

    result.fold(
      (failure) =>
          emit(Notefailure(message: failure.message)), // Handle failure
      (_) => emit(NoteDeletedSucess()), // Emit success state
    );
  }



  // Handler for uploading notes
  Future<void> _onNoteUpload(
    NotesUploadNotes event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());
    final result = await _uploadNotes(UploadNotesParam(
      posterId: event.posterId,
      noteId: event.noteId,
      grade: event.grade,
      indicators: event.indicators,
      contentStandard: event.contentStandard,
      substrand: event.substrand,
      strand: event.strand,
      classSize: event.classSize,
      Subject: event.Subject,
      updatedAt: event.updatedAt,
      lessonNote: event.lessonNote,
      schoolId: event.schoolId,
    ));

    result.fold(
      (failure) => emit(Notefailure(message: failure.message)),
      (note) => emit(NoteUploadSuccess()),
    );
  }

  void _onNoteDownload(
      NotesFetchAllNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());

    final result =
        await _getAllNotes.call(downloadNotesParams(posterId: event.posterId));

    result.fold(
      (failure) => emit(
        Notefailure(message: failure.message),
      ),
      (notes) {
        if (notes.isEmpty) {
          // Handle the case when there are no notes
          emit(NoteDisplaySuccess(
              notes: const [])); // Or emit another state like NoNotesState
        } else {
          print(notes
              .first); // Safely print first note only if the list is not empty
          emit(NoteDisplaySuccess(notes: notes));
        }
      },
    );
  }

    void _onGetPDFNotes( NotesFetchPDFNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());

    final result =
        await _getPDFNotes.call(downloadPDFNotesParams(posterId: event.posterId));

    result.fold(
      (failure) => emit(
        Notefailure(message: failure.message),
 
      ),
      (pdfnote) {
        if (pdfnote.isEmpty) {
          // Handle the case when there are no notes
           print("Note is empty");
          emit(PDFNoteDisplaySuccess(
               pdfnote: const [])); // Or emit another state like NoNotesState
                        

        } else {
          
          print(pdfnote
              .first); // Safely print first note only if the list is not empty
          emit(PDFNoteDisplaySuccess(pdfnote: pdfnote));
        }
      },
    );
  }
}
