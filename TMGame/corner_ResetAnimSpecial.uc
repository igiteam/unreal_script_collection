class corner_ResetAnimSpecial extends CoreTask within animscripts_corner;

// parameter
var float iDelay;

state main
{
Begin:
	endon('killanimscript');
	wait (iDelay);
	a.special = 'none';
}
