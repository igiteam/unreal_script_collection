class corner_ShootUntilShootBehaviorChange_corner extends CoreTask within animscripts_corner;

// parameter
var bool iRunAngleRangeThread;

state main
{
Begin:
	endon('return_to_cover');
	
	if (iRunAngleRangeThread)
		angleRangeThread(true); // gives stopShooting notify when shootPosOutsideLegalYawRange returns true
	standIdleThread(true);
	
	animscripts_combat_utility.shootUntilShootBehaviorChange();
}
