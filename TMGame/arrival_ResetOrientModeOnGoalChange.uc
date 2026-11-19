class arrival_ResetOrientModeOnGoalChange extends CoreTask within animscripts_cover_arrival;

// parameter

// output

// local
var array<name> waited_notifes;

state main
{
Begin:
	endon('killanimscript');
	waited_notifes.Add(2);
	waited_notifes[0] = 'goal_changed';
	waited_notifes[1] = 'dont_align_to_node_angles';
	waittill_any(waited_notifes);

	orientMode('face default');
}
