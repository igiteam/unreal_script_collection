class cover_behavior_IdleWait extends CoreTask within animscripts_cover_behavior;

// parameter
var float howLong;

state main
{
Begin:
	endon('end_idle');
	wait (howLong);
}
