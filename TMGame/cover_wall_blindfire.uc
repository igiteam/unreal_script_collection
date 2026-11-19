class cover_wall_blindfire extends BoolTask within animscripts_cover_wall;

// parameter

// output

// local

state main
{
Begin:
	if (!animscripts_utility.animArrayAnyExist('blind_fire'))
		_return (false);
	
	animMode ('zonly_physics');
	keepClaimedNodeInGoal = true;

	setflaggedanimknobAll('blindfire', SetCustomAnim(misc_modern, animscripts_utility.animArrayPickRandom('blind_fire')), 'body', 1, 0.2, 1);
	animscripts_shared.DoNoteTracks('blindfire');

	keepClaimedNodeInGoal = false;
	
	_return (true);
}
