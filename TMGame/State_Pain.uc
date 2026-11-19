class State_Pain extends CoreTask within HodAI;

var name note;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	OrientMode('face current');
	animscripts_pain.main(false);

	notify (note);
}
