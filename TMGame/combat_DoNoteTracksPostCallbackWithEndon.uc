class combat_DoNoteTracksPostCallbackWithEndon extends CoreTask within animscripts_combat;

// parameter
var name iFlagName;
var DelegateNoteTracksPostCallback iInterceptFunction;
var name iEndonMsg;

// output

// local

state main
{
Begin:
	endon(iEndonMsg);
	animscripts_shared.DoNoteTracksPostCallback(iFlagName, iInterceptFunction);
}
