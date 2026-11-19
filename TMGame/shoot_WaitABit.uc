class shoot_WaitABit extends CoreTask within animscripts_shoot_behavior;

state main
{
Begin:
	endon('enemy');
	endon('done_changing_cover_pos');
	endon('weapon_position_change');
	endon('enemy_visible');
	
	if (obj_isdefined(shootEnt))
	{
		shootEnt.endon('death');
		
		endon('do_slow_things');
		
		// (want to keep self.shootPos up to date)
		wait (0.05);
		while (obj_isdefined(shootEnt))
		{
			shootPos = shootEnt.getShootAtPos();
			wait (0.05);
		}
	}
	else
	{
		waittill('do_slow_things');
	}
}
