class State_CustomAnim extends CoreTask within HodAI_DoCustomAnim;

var name note;
state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	run (new(outer) class'StateCustomAnim_PlayCustomAnim', false);
	notify (note);
}
