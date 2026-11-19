class corner_PeekOut extends BoolTask within animscripts_corner;

// local
var name lPeekAnim;

state main
{
Begin:
	lPeekAnim = SetCustomAnim(misc_modern, animscripts_utility.animArray('hide_to_look'));
	
	if (!mayMoveToPoint(animscripts_utility.getAnimEndPos(lPeekAnim)))
		_return (false);
	
	// not safe to stop peeking in the middle because it will screw up our deltas
//	//self thread _peekStop();
//	//self endon ('stopPeeking');
	
	setflaggedanimknobAll('looking_start', lPeekAnim, 'body', 1, 0.2, 1);
	animscripts_shared.DoNoteTracks('looking_start');
//	//self notify ('stopPeekCheckThread');
	
	_return (true);
}
