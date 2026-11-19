class utility_ExitProneWrapperProc extends CoreTask within animscripts_utility;

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
	ExitProne(timer);
	waittill('killanimscript');
	
	// in case we dont actually leave prone, change it out of prone
	if(a.pose == 'prone')
		a.pose = 'crouch';
}
