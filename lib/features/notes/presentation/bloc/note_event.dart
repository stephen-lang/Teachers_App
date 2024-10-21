part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}
final class NotesFetchAllNotes extends NoteEvent {
final String posterId;

  NotesFetchAllNotes({required this.posterId});

}