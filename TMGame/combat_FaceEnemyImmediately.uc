class combat_FaceEnemyImmediately extends CoreTask within animscripts_combat;

// parameter

// output

// local
var float lMaxYawChange;
var float lYawChange;

state main
{
Begin:
	endon('killanimscript');
	notify('facing_enemy_immediately');
	endon('facing_enemy_immediately');
	
	lMaxYawChange = 5; // degrees per frame
	
	while (true)
	{
		lYawChange = 0 - animscripts_utility.GetYawToEnemy();
		
		if (abs(lYawChange) < 2)
			break;
		
		if (abs(lYawChange) > lMaxYawChange)
			lYawChange = lMaxYawChange * sign(lYawChange);
		
		OrientMode('face angle', angles.yaw + lYawChange);
		
		wait (0.05);
	}
	
	OrientMode('face current');
	
	notify('can_stop_turning');
}
