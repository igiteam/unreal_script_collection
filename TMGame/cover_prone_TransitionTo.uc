class cover_prone_TransitionTo extends CoreTask within animscripts_cover_prone;

// parameter
var name iNewPose;

// output

// local
var name lTransAnim;

state main
{
Begin:
	clearanim('root', 0.3);
	
	notify('kill_idle_thread');
	
	if (shouldFireWhileChangingPose())
		lTransAnim = animscripts_utility.animArray(name(a.pose $ "_2_" $ iNewPose $ "_firing"));
	else
		lTransAnim = animscripts_utility.animArray(name(a.pose $ "_2_" $ iNewPose));
	
	if (iNewPose == 'prone')
	{
		// this is crucial. if it doesn't have this notetrack, we won't call enterProneWrapper!
		assert(animHasNotetrack(lTransAnim, name("anim_pose = prone")));
	}
	
	setFlaggedAnimKnobAllRestart('trans', lTransAnim, 'body', 1, 0.2, 1.0);
	animscripts_shared.DoNoteTracks('trans');

	assert(a.pose == iNewPose);

	setAnimKnobAllRestart(animscripts_utility.animarray('straight_level'), 'body', 1, 0.25);
	setupAim(0.25);
}
