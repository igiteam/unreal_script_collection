class combat_CantSeeEnemyWait extends CoreTask within animscripts_combat;

state main
{
Begin:
	endon('shoot_behavior_change');
	
	wait (0.4 + randomfloat(0.4));
	waittill('do_slow_things');
}
