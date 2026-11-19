class corner_mainLoopStart extends CoreTask within animscripts_corner;

// parameter

// output

// local
var name lDesiredStance;
var name lStanceChangeAnim;

state main
{
Begin:
	lDesiredStance = 'stand';
	if (!coverNode.doesNodeAllowStance('stand') && coverNode.doesNodeAllowStance('crouch'))
		lDesiredStance = 'crouch';
	if (lDesiredStance == 'stand')
	{
		if (!IsStanceAllowed('stand'))
			lDesiredStance = 'crouch';
	}
	
	if (haveGoneToCover)
	{
		transitionToStance(lDesiredStance);
	}
	else
	{
		if (a.pose == lDesiredStance)
		{
			GoToCover(SetCustomAnim(misc_modern, animscripts_utility.animArray('hide_idle')), 0.4, 0.4);
		}
		else
		{
			lStanceChangeAnim = SetCustomAnim(misc_modern, animscripts_utility.animarray('stance_change'));
			GoToCover(lStanceChangeAnim, 0.4, getAnimLength(lStanceChangeAnim));
			set_anim_array(lDesiredStance); // (sets anim_pose to stance)
		}
		assert(a.pose == lDesiredStance);
		haveGoneToCover = true;
	}
}
