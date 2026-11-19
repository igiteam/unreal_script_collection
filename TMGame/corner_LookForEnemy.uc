class corner_LookForEnemy extends BoolTask within animscripts_corner;

// parameter
var float iLookTime;

// local
var name lLookAnim;
var bool lBoolReturn;

function OnReturn(CoreTask task)
{
	if (task.isa('BoolTask'))
		lBoolReturn = true;
}

state main
{
Begin:
	if (!animscripts_utility.animArrayAnyExist('hide_to_look'))
		_return (false);
	
	animMode('zonly_physics'); // Unlatch the feet
	keepClaimedNodeInGoal = true;
	
	// look out from alert
	lBoolReturn = false;
	peekOut();
	if (!lBoolReturn)
		_return (false);
	
	animscripts_shared.playLookAnimation(SetCustomAnim(misc_modern, animscripts_utility.animarray('look_idle')), iLookTime, CanStop_CanStopPeeking);
	
	lLookAnim = '';
	if (animscripts_utility.isSuppressedWrapper())
		lLookAnim = animscripts_utility.animArray('look_to_hide_fast');
	else
		lLookAnim = animscripts_utility.animArray('look_to_hide');
	
	setflaggedanimknoballrestart('looking_end', SetCustomAnim(misc_modern, lLookAnim), 'body', 1, 0.1, 1.0);
	animscripts_shared.DoNoteTracks('looking_end');
	
	animMode ('zonly_physics'); // Unlatch the feet
	
	keepClaimedNodeInGoal = false;
	
	_return (true);
}
