class shared_DoNoteTracksForever extends CoreTask within animscripts_shared;

// parameter
var name flagName;
var name killString;

// output

// local
var int time;
var float timetaken;

state main
{
Begin:
	if (killString != '')
		endon (killString);
	endon ('killanimscript');

	while (true)
	{
		//prof_begin( "DoNoteTracksForeverProc" );
		time = GetTime();
		//prof_begin( "notetracksFunc" );
		DoNoteTracks(flagName);
		//prof_end( "notetracksFunc" );
		timetaken = 0.001 * (GetTime() - time);
		if (timetaken < 0.05)
		{
			time = GetTime();
			//prof_begin( "notetracksFunc" );
			DoNoteTracks(flagName);
			//prof_end( "notetracksFunc" );
			timetaken = 0.001 * (GetTime() - time);
			if ( timetaken < 0.05)
			{
				//println (GetTime()+" "+debugIdentifier+" animscripts\shared::DoNoteTracksForever is trying to cause an infinite loop on anim "+flagName+", returned "+returnedNote+".");
				wait (0.05 - timetaken);
			}
		}
		//(GetTime()+" "+debugIdentifier+" DoNoteTracksForever returned in "+timetaken+" ms.");#/
		//prof_end( "DoNoteTracksForeverProc" );
	}
}
