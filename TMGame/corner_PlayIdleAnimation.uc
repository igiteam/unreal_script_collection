class corner_PlayIdleAnimation extends CoreTask within animscripts_corner;

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
	
	animscripts_shared.DoNoteTracks('idle');
}
