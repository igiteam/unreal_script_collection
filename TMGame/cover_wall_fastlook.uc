class cover_wall_fastlook extends BoolTask within animscripts_cover_wall;

state main
{
Begin:
	setFlaggedAnimKnobAllRestart('look', SetCustomAnim(misc_modern, animscripts_utility.animArrayPickRandom('look')), 'body', 1, 0.1);
	animscripts_shared.DoNoteTracks('look');
	
	_return (true);
}
