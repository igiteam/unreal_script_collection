class run_RunShootWhileMovingThreads extends CoreTask within animscripts_run;

// parameter

// output

// local

state main
{
Begin:
	notify('want_shoot_while_moving');

	if (shoot_while_moving_thread)
		_return();
	shoot_while_moving_thread = true;
	
	RunDecideWhatAndHowToShoot(true);
	RunShootWhileMoving(true);
}
