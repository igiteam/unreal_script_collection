class cover_wall_flinch extends BoolTask within animscripts_cover_wall;

// parameter

// output

// local
var vector lForward;
var vector lStepTo;
var name lFlinchAnim;

state main
{
Begin:
	if (!animscripts_utility.animArrayAnyExist('hide_idle_flinch'))
		_return (false);
	
	lForward = anglesToForward(angles);
	lStepTo = origin + vectorScale(lForward, -16);
	
	if (!mayMoveToPoint(lStepTo))
		_return (false);
	
	animmode('zonly_physics');
	keepClaimedNodeInGoal = true;
	
	lFlinchAnim = SetCustomAnim(misc_modern, animscripts_utility.animArrayPickRandom('hide_idle_flinch'));
	playIdleAnimation(lFlinchAnim, true);
	
	keepClaimedNodeInGoal = false;
	
	_return (true);
}
