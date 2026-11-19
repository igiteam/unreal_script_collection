class cover_wall_DoNoteTracksForPopup extends CoreTask within animscripts_cover_wall;

// parameter
var name iAnimName;

state main
{
Begin:
	endon('killanimscript');
	endon('stop_popup_donotetracks');
	animscripts_shared.DoNoteTracks(iAnimName);
}
