class stop_SetLastStoppedTime extends CoreTask within animscripts_stop;

state main
{
Begin:
	endon('death');
	waittill('killanimscript');
	lastStoppedTime = gettime();
}
