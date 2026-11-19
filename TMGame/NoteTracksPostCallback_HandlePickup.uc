class NoteTracksPostCallback_HandlePickup extends DelegateNoteTracksPostCallback;

function Execute(name note)
{
	animscripts_combat.handlePickup(note);
}
