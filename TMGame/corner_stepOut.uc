class corner_stepOut extends BoolTask within animscripts_corner;

// parameter
var name lthisNodePose;
var name lnewCornerMode;
var name lanimname;
var name lswitchanim;
var bool lhasStartAim;

state main
{
Begin:
	a.cornerMode = 'alert';
	
	animMode ('zonly_physics');
	
	if (a.pose == 'stand')
	{
		ABangleCutoff = 38;
	}
	else
	{
		assert(a.pose == 'crouch');
		ABangleCutoff = 31;
	}
	
	lthisNodePose = a.pose;
	set_anim_array(lthisNodePose);
	
	lnewCornerMode = 'none';
	if (animscripts_utility.hasEnemySightPos())
		lnewCornerMode = getCornerMode(coverNode, animscripts_utility.getEnemySightPos());
	else
		lnewCornerMode = getCornerMode(coverNode);
	if (lnewCornerMode == 'none')
		_return (false);
	
	lanimname = name('hide_to_' $ lnewCornerMode);
	assert(animscripts_utility.animArrayAnyExist(lanimname));
	lswitchanim = SetCustomAnim(corner, animscripts_utility.animArrayPickRandom(lanimname));
	
	if (!isPathClear(lswitchanim, lnewCornerMode != 'lean'))
		_return (false);
	
	a.cornerMode = lnewCornerMode;
	
	set_aiming_limits();
	if (a.cornerMode == 'lean')
	{
		if (cornerDirection == 'left')
			rightaimlimit = 0;
		else
			leftaimlimit = 0;
	}

	a.special = 'none';

	keepclaimednode = true;
	keepClaimedNodeInGoal = true;
	
	changingCoverPos = true;
	notify('done_changing_cover_pos');
	
	setFlaggedAnimKnobAllRestart('stepout', lswitchanim, 'root', 1, 0.2, 1.0);
	DoNoteTracksWithEndon('stepout', true);
	
	lhasStartAim = animHasNotetrack(lswitchanim, 'start_aim');
	if (lhasStartAim)
	{
		waittillmatch('stepout','start_aim');
	}
	else
	{
//		/#println('^1Corner stepout animation \'' + lanimname + '\' in corner_' + self.cornerDirection + ' ' + self.a.pose + ' didn't have \'start_aim\' notetrack');#/
		waittillmatch('stepout', 'end');
	}
	
	
	if (lnewCornerMode == 'B' && cornerDirection == 'right')
		a.special = 'corner_right_mode_b';
	
	set_anim_array_aiming(lthisNodePose);

	StartAiming('', false, 0.3);
	animscripts_shared.trackShootEntOrPos(true);
	
	if (lhasStartAim)
		waittillmatch('stepout','end');
	
	ChangeAiming('', true, 0.2);
	//clearAnim('cover', 0.2);
	clearAnim('corner', 0.2);
	
	changingCoverPos = false;
	coverPosEstablishedTime = gettime();
	
	_return (true);
}
