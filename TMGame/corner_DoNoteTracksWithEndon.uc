class corner_DoNoteTracksWithEndon extends CoreTask within animscripts_corner;

// parameter
var name iAnimName;

state main
{
Begin:
	endon('killanimscript');
	animscripts_shared.DoNoteTracks(iAnimName);
}
