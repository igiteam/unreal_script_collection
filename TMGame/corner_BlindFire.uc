class corner_BlindFire extends BoolTask within animscripts_corner;

state main
{
Begin:
	if (!animscripts_utility.animArrayAnyExist('blind_fire'))
		_return (false);
	
	animMode ('zonly_physics');
	keepClaimedNodeInGoal = true;

	setFlaggedAnimKnobAllRestart('blindfire', SetCustomAnim(misc_modern, animscripts_utility.animArrayPickRandom('blind_fire')), 'body', 1, 0.2, 1);
	animscripts_shared.DoNoteTracks('blindfire');

	keepClaimedNodeInGoal = false;
	
	_return (true);
}
