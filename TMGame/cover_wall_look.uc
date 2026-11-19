class cover_wall_look extends BoolTask within animscripts_cover_wall;

// parameter
var float iLookTime;

// output

// local
var bool lBoolReturn;
var name lLookAnim;

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
	
	lBoolReturn = false;
	peekOut();
	if (!lBoolReturn)
		_return (false);
	
	animscripts_shared.playLookAnimation(SetCustomAnim(misc_modern, animscripts_utility.animArray('look_idle')), iLookTime); // TODO: replace
	
	if (animscripts_utility.isSuppressedWrapper())
		lLookAnim = animscripts_utility.animArray('look_to_hide_fast');
	else
		lLookAnim = animscripts_utility.animArray('look_to_hide');
	
	setflaggedanimknoballrestart('looking_end', SetCustomAnim(misc_modern, lLookAnim), 'body', 1, 0.1);
	animscripts_shared.DoNoteTracks('looking_end');
	
	_return (true);
}
