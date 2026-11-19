class combat_utility_NotifyOnAnimEnd extends CoreTask within animscripts_combat_utility;

// parameter
var name iAnimNotify;
var name iEndNotify;

// output

// local

state main
{
Begin:
	endon('killanimscript');
	endon(iEndNotify);
	waittillmatch(iAnimNotify, 'end');
	notify(iEndNotify);
}

function Dump()
{
	super.Dump();
	;
	;
}
