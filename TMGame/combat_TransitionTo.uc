class combat_TransitionTo extends CoreTask within animscripts_combat;

// parameter
var name iNewPose;

// output

// local
var name lTransAnim;
var float lRate;
var float lTransTime;
var float lPlayTime;

state main
{
Begin:
	if (iNewPose == a.pose)
		_return();
	
	// no stance change anims when using sidearm!
	assert(!animscripts_utility.usingSidearm());
	
	clearanim('root', 0.3);
	
	notify('kill_idle_thread');
	
	lTransAnim = SetCustomAnim(exposed_modern, animscripts_utility.AnimArray(name(a.pose $ "_2_" $ iNewPose)));
	if (iNewPose == 'stand')
		lRate = 2; // gotta stand up fast!
	else
		lRate = 1;
	
	assert (animHasNoteTrack(lTransAnim, name("anim_pose = " $ iNewPose)));
//	if (!animHasNoteTrack(lTransAnim, name("anim_pose = " $ iNewPose)))
//	{
//		assert (false);
////		println('error: ' + self.a.pose + '_2_' + iNewPose + ' missing notetrack to set pose!');
//	}

	setFlaggedAnimKnobAllRestart('trans', lTransAnim, 'body', 1, 0.2, lRate);
	lTransTime = getAnimLength(lTransAnim) / lRate;
	lPlayTime = lTransTime - 0.3;
	if (lPlayTime < 0.2)
		lPlayTime = 0.2;
	animscripts_shared.DoNoteTracksForTime(lPlayTime, 'trans');
	
	a.pose = iNewPose;

	if (iNewPose == 'stand')
		set_animarray_standing();
	else if (iNewPose == 'crouch')
		set_animarray_crouching();
		
	setAnimKnobAllRestart(animscripts_utility.AnimArray('straight_level'), 'body', 1, 0.25);
	setupAim(0.25);
	
	setAnim('add_idle');
	idleThread(true);
	
	maps__gameskill.didSomethingOtherThanShooting();
}
