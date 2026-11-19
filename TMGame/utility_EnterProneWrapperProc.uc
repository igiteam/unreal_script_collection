class utility_EnterProneWrapperProc extends CoreTask within animscripts_utility;

// parameter
var float timer;

// output

// local

state main
{
Begin:
	endon('death');
	notify('anim_prone_change');
	endon('anim_prone_change');
	// wrapper so we can put a breakpoint on it
	EnterProne( timer );
	waittill('killanimscript');
	
	// in case we dont actually make it into prone by the time another script comes in
	//if(a.pose != 'prone')
	//	a.pose = 'prone';
}
