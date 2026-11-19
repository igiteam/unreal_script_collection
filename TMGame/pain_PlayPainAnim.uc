class pain_PlayPainAnim extends CoreTask within animscripts_pain;

// parameter
var name iPainAnim;

// output

// local
var float lRate;

state main
{
Begin:
	if (magic_bullet_shield)
		lRate = 1.5;
	else
		lRate = animPlayBackRate;
	
	iPainAnim = SetCustomAnim(misc_modern, iPainAnim);
	setFlaggedAnimKnobAllRestart('painanim', iPainAnim, 'body', 1, 0.1, lRate);
	
	if (a.pose == 'prone')
		UpdateProne('prone_legs_up', 'prone_legs_down', 1, 0.1, 1);
	
	if (animHasNotetrack(iPainAnim, 'start_aim'))
	{
		notifyStartAim('painanim', true);
		endon('start_aim');
	}
	
	animscripts_shared.DoNoteTracks('painanim');
}
