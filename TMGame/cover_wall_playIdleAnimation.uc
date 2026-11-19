class cover_wall_playIdleAnimation extends CoreTask within animscripts_cover_wall;

// parameter
var name iIdleAnim;
var bool iNeedsRestart;

state main
{
Begin:
	if (iNeedsRestart)
		setFlaggedAnimKnobAllRestart('idle', iIdleAnim, 'body', 1, 0.1, 1);
	else
		setFlaggedAnimKnobAll       ('idle', iIdleAnim, 'body', 1, 0.1, 1);
	
	a.coverMode = 'hide';
	
	animscripts_shared.DoNoteTracks('idle');
}
