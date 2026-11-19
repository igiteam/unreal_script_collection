class corner_NotifyStopShootingAfterTime extends CoreTask within animscripts_corner;

// parameter
var float iTime;

state main
{
Begin:
	endon('killanimscript');
	endon('stopNotifyStopShootingAfterTime');
	
	wait (iTime);
	
	notify('stopShooting');
}
