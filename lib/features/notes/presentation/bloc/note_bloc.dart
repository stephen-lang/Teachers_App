import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notesEntity.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/usecases/get_all_notes.dart';
 
 
part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final  GetAllNotes _getAllNotes; 
  NoteBloc({
    required GetAllNotes getAllNotes,
  
  }) :_getAllNotes= getAllNotes, super(NoteInitial()) {

    on<NoteEvent>((event, emit) =>emit(NoteLoading()));
    on<NotesFetchAllNotes>(_onNoteDownload);
  }

  void _onNoteDownload(NotesFetchAllNotes event,Emitter<NoteState> emit)
async {
    emit(NoteLoading());

    final result = await _getAllNotes.call(downloadNotesParams(posterId: event.posterId));

    result.fold(
      (failure) => emit(Notefailure(message:failure.message)),
      (notes) {
        print(notes.first);
        emit( NoteDisplaySuccess(notes: notes));},
    );
  }
}