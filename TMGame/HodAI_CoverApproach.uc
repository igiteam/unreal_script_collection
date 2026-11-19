class HodAI_CoverApproach extends CoreTask within HodAI;

// parameter

// output

// local
var HodNotify_CornerApproach lNotify;

function OnEndon(name note)
{
	;
}

state main
{
Begin:
	wait (0);
	endon ('killanimscript');
	notify ('stop_CoverApproach');
	endon ('stop_CoverApproach');

	while (!requestArrivalNotify)
	{
		wait (0.05);
	}
	lNotify = new class'HodNotify_CornerApproach';
	lNotify.approach_dir = vectornormalize(pathGoalPos - origin);
	requestArrivalNotify = false;
	notify ('corner_approach', lNotify);
}
