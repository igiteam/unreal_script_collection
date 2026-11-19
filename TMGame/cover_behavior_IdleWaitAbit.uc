class cover_behavior_IdleWaitAbit extends CoreTask within animscripts_cover_behavior;

state main
{
Begin:
	endon('end_idle');
	wait (0.3 + randomfloat(0.1));
	waittill('do_slow_things');
}
