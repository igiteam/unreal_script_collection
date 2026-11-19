class run_StopShootWhileMovingThreads extends CoreTask within animscripts_run;

state main
{
Begin:
	endon('killanimscript');
	endon('want_shoot_while_moving');
	
	wait(0.05);
	
	notify('end_shoot_while_moving');
	shoot_while_moving_thread = false;
}
