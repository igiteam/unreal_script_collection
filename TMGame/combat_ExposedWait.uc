class combat_ExposedWait extends CoreTask within animscripts_combat;

state main
{
Begin:
	if (!obj_isdefined(enemy) || !cansee(enemy))
	{
		endon('enemy');
		endon('shoot_behavior_change');
		
		wait (0.2 + randomfloat(0.1));
		waittill('do_slow_things');
	}
	else
	{
		wait (0.05);
	}
}
