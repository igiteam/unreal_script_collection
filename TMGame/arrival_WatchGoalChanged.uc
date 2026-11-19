class arrival_WatchGoalChanged extends CoreTask within animscripts_cover_arrival;

// parameter

// output

// local

state main
{
Begin:
	endon ('killanimscript');
	endon ('doing_last_minute_exposed_approach');

	while (true)
	{
		waittill ('goal_changed');
		wait (0.05);
		notify ('goal_changed_previous_frame');
	}
}
