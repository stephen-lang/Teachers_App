import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notesEntity.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/usecases/get_all_notes.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/usecases/upload_notes.dart';

part 'note_event.dart';
part 'note_state.dart';
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetAllNotes _getAllNotes;
  final UploadNotes _uploadNotes;

  NoteBloc({
    required GetAllNotes getAllNotes,
    required UploadNotes uploadNotes,
  })  : _getAllNotes = getAllNotes,
        _uploadNotes = uploadNotes,
        super(NoteInitial()) {
    on<NotesFetchAllNotes>(_onNoteDownload);
    on<NotesUploadNotes>(_onNoteUpload);
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
    ));

    result.fold(
      (failure) => emit(
        Notefailure(message: failure.message)
        ),
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
              notes: [])); // Or emit another state like NoNotesState
        } else {
          print(notes
              .first); // Safely print first note only if the list is not empty
          emit(NoteDisplaySuccess(notes: notes));
        }
      },
    );
  }
}
