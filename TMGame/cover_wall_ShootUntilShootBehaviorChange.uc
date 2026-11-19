class cover_wall_ShootUntilShootBehaviorChange extends CoreTask within animscripts_cover_wall;

state main
{
Begin:
	if (coverType == 'crouch')
		angleRangeThread(true); // gives stopShooting notify when shootPosOutsideLegalYawRange returns true
	standIdleThread(true);
	
	animscripts_combat_utility.shootUntilShootBehaviorChange();
}
