class corner_changeStepOutPos extends BoolTask within animscripts_corner;

// local
var name lPositionToSwitchTo;
var name lAnimName;
var name lSwitchanim;
var vector lMidpoint;
var name lprev_anim_pose;

state main
{
Begin:
	endon ('killanimscript');

	lPositionToSwitchTo = getBestStepOutPos();
	
	if (lPositionToSwitchTo == a.cornerMode)
		_return (false);
	
	// can't switch between lean and other stepoutposes
	// so if this assert fails then getBestStepOutPos gave us a bad return value
	assert(a.cornerMode != 'lean' && lPositionToSwitchTo != 'lean');
	
	changingCoverPos = true; 
	notify('done_changing_cover_pos');
	
	lAnimName = name(a.cornerMode $ "_to_" $ lPositionToSwitchTo);
	assert(animscripts_utility.animArrayAnyExist(lAnimName));
	lSwitchanim = SetCustomAnim(corner, animscripts_utility.animArrayPickRandom(lAnimName));
	
	lMidpoint = getPredictedPathMidpoint();
	if (!mayMoveToPoint(lMidpoint))
		_return (false);
	if (!mayMoveFromPointToPoint(lMidpoint, animscripts_utility.getAnimEndPos(lSwitchanim)))
		_return (false);
	
	endStandIdleThread();
	
	// turn off aiming while we move.
	StopAiming(0.3);
	
	lprev_anim_pose = a.pose;
	
	setanimlimited(animscripts_utility.animarray('straight_level'), 0, 0.2);
	
	setFlaggedAnimKnob('changeStepOutPos', lSwitchanim, 1, 0.2, 1);
	DoNoteTracksWithEndon('changeStepOutPos', true);
	
	if (animHasNotetrack(lSwitchanim, 'start_aim'))
	{
		waittillmatch('changeStepOutPos', 'start_aim');
	}
	else
	{
//		/#println('^1Corner position switch animation \'' + lAnimName + '\' in corner_' + self.cornerDirection + ' ' + self.a.pose + ' didn't have \'start_aim\' notetrack');#/
		waittillmatch('changeStepOutPos', 'end');
	}
	
	StartAiming('', false, 0.3, true);

	waittillmatch('changeStepOutPos', 'end');
	clearanim(lSwitchanim, 0.1);
	a.cornerMode = lPositionToSwitchTo;
	
	changingCoverPos = false;
	coverPosEstablishedTime = gettime();

	assert(a.pose == 'stand' || a.pose == 'crouch');
	if (a.pose != lprev_anim_pose)
		set_anim_array(a.pose); // don't call this if we don't have to, because we don't want to reset %exposed_aiming
	
	ChangeAiming('', true, 0.3, true);
	
	_return (true);
}
