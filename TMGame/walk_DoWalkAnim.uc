class walk_DoWalkAnim extends CoreTask within animscripts_walk;

// parameter
var name iWalkAnim;

// output

// local

state main
{
Begin:
	endon('movemode');
	
	setFlaggedAnimKnobAll('walkanim', iWalkAnim, 'body', 1, 1.2, 1);
	if (a.pose != 'prone')
	{
		animscripts_run.UpdateRunWeightsOnce(
			'combatrun_forward',
			'stand_walk_B',
			'stand_walk_L',
			'stand_walk_R'
		);
	}
	
	animscripts_shared.DoNoteTracksForTime(0.2, 'walkanim');
}
