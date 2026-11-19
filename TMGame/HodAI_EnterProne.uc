class HodAI_EnterProne extends CoreTask within HodAI;

// input
var float iTime;

state main
{
Begin:
	endon ('killanimscript');
	wait (iTime);
	a.pose = 'prone';
}
