class NoteTracksPostCallback_HandlePutaway extends DelegateNoteTracksPostCallback;

function Execute(name note)
{
	animscripts_combat.handlePutaway(note);
}
