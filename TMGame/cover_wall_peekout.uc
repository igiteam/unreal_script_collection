class cover_wall_peekout extends BoolTask within animscripts_cover_wall;

state main
{
Begin:
	// assuming no delta, so no maymovetopoint check
	
	setFlaggedAnimKnobAll('looking_start', SetCustomAnim(misc_modern, animscripts_utility.animArray('hide_to_look')), 'body', 1, 0.2);
	animscripts_shared.DoNoteTracks('looking_start');
	
	_return (true);
}
