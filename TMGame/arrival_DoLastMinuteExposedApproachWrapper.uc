class arrival_DoLastMinuteExposedApproachWrapper extends CoreTask within animscripts_cover_arrival;

// parameter

// output

// local
var array<name> waited_notifes;

state main
{
Begin:
	endon('killanimscript');

	notify('doing_last_minute_exposed_approach');
	endon ('doing_last_minute_exposed_approach');

	watchGoalChanged(true);

	while (true)
	{
		doLastMinuteExposedApproach();

		// try again when our goal pos changes
		while (true)
		{
			waited_notifes.Add(2);
			waited_notifes[0] = 'goal_changed';
			waited_notifes[1] = 'goal_changed_previous_frame';
			waittill_any(waited_notifes);

			// our goal didn't *really* change if it only changed because we called setRunToPos
			if (coverEnterPos != invalid_vector && pathGoalPos != invalid_vector && distanceSquared(coverEnterPos, pathGoalPos) < 1 * FInchSq)
				continue;
			break;
		}
	}
}
