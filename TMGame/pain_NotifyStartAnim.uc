class pain_NotifyStartAnim extends CoreTask within animscripts_pain;

// parameter
var name animFlag;

state main
{
Begin:
	endon('killanimscript');
	waittillmatch(animFlag, 'start_aim');
	notify('start_aim');
}
