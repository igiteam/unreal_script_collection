class combat_MakeSureTurnWorks extends CoreTask within animscripts_combat;

// parameter

// output

// local
var float lStartAngle;

state main
{
Begin:
	endon('killanimscript');
	endon('done turning');
	
	lStartAngle = angles.yaw;
	
	wait (0.3);
	
	if (angles.yaw == lStartAngle)
	{
		notify('turning_isnt_working');
		turnLastResort = true;
	}
}
