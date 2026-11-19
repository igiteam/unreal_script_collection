class corner_transitionToStance extends CoreTask within animscripts_corner;

// parameter
var name iStance;

state main
{
Begin:
	if (a.pose == iStance)
	{
		set_anim_array(iStance);
		_return();
	}

////	self ExitProneWrapper(0.5);
	setFlaggedAnimKnobAllRestart('changeStance', SetCustomAnim(misc_modern, animscripts_utility.animarray('stance_change')), 'body');

	set_anim_array(iStance); // (sets anim_pose to stance)

	animscripts_shared.DoNoteTracks('changeStance');
	assert(a.pose == iStance);
	wait (0.2);
}
