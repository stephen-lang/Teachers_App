part of 'note_bloc.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}
final class NoteLoading extends NoteState {}
final class Notefailure extends NoteState {
   final String message;

  Notefailure({required this.message});
}
final class NoteUploadSuccess extends NoteState {
 
}

class NoteDeletedSucess extends NoteState {}


final class NoteDisplaySuccess extends NoteState {
final List<Notesentity> notes;

  NoteDisplaySuccess({required this.notes});

}
