class shared_DoNoteTracksForTime extends CoreTask within animscripts_shared;

// parameter
var float time;
var name flagName;

// output

// local
var HodObject ent;

state main
{
Begin:
	ent = HodObject(NewObject(class'HodObject'));
	ent.WaitNotify(time, 'stop_notetracks', true);
	ent.endon('stop_notetracks');
	DoNoteTracksForever(flagName, '');
}
