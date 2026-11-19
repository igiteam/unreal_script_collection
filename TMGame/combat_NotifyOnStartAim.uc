class combat_NotifyOnStartAim extends CoreTask within animscripts_combat;

// parameter
var name iEndonStr;
var name iFlagName;

// output

// local

state main
{
Begin:
	endon(iEndonStr);
	waittillmatch(iFlagName, 'start_aim');
	finishedReload = true;
	notify('start_aim');
}
