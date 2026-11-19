class arrival_DoNoteTracksForExit extends CoreTask within animscripts_cover_arrival;

// parameter
var name animname;
var bool hasExitAlign;

// output

// local

state main
{
Begin:
	endon('killanimscript');
	animscripts_shared.DoNoteTracks(animname);

	if (!hasExitAlign)
	{
		anim_notify.data = 'exit_align';
		notify(animname, anim_notify); // failsafe
	}
}
