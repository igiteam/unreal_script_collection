class corner_ShootUntilShootBehaviorChangeForTime extends CoreTask within animscripts_corner;

// parameter
var float iTime;

// local
var float lStartTime;
var float lTimePassed;

state main
{
Begin:
	notifyStopShootingAfterTime(iTime, true);
	
	lStartTime = gettime();
	
	shootUntilShootBehaviorChange_corner(false);
	notify('stopNotifyStopShootingAfterTime');

	lTimePassed = (gettime() - lStartTime) / 1000;
	if (lTimePassed < iTime)
		wait (iTime - lTimePassed);
}
