class death_PlayDeathAnim extends CoreTask within animscripts_death;

// parameter
var name iDeathAnim;

// output

// local

state main
{
Begin:
	iDeathAnim = SetCustomAnim(misc_modern, iDeathAnim);
	if (!animHasNoteTrack(iDeathAnim, 'dropgun') && !animHasNoteTrack(iDeathAnim, 'fire_spray')) // && !animHasNotetrack(iDeathAnim, 'gun keep')
		animscripts_shared.DropAllAIWeapons();
	
	setFlaggedAnimKnobAllRestart('deathanim', iDeathAnim, 'body', 1, 0.1);
	
	if (skipDeathAnim)
	{
		startRagDoll();
		_return();
	}
	else if (!animHasNotetrack(iDeathAnim, 'start_ragdoll'))
	{
		waitForRagdoll(getanimlength(iDeathAnim) * 0.35, true);
	}
	
//	// do we really need this anymore?
	
	animscripts_shared.DoNoteTracks('deathanim');
	animscripts_shared.DropAllAIWeapons();
}
