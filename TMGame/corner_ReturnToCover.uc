class corner_ReturnToCover extends CoreTask within animscripts_corner;

// parameter
var bool lSuppressed;
var float lRate;
var name lAnimName;
var name lSwitchAnim;
var bool lReloading;

state main
{
Begin:
	assert(canReturnToCover(a.cornerMode != 'lean'));
	
	endStandIdleThread();
	
	// Go back into hiding.
	lSuppressed = animscripts_utility.issuppressedWrapper();
	notify ('take_cover_at_corner'); // Stop doing the adjust-stance transition thread
	
	resetAnimSpecial(0.3, true);
	
	if (lSuppressed)
		lRate = 1.5;
	else
		lRate = 1;
	
	changingCoverPos = true;
	notify('done_changing_cover_pos');
	
	lAnimName = name(a.cornerMode $ '_to_hide');
	assert(animscripts_utility.animArrayAnyExist(lAnimName));
	lSwitchAnim = animscripts_utility.animArrayPickRandom(lAnimName);

	StopAiming(0.3);
	clearAnim('add_fire', 0.2);
	
	lReloading = false;
	if (a.cornerMode != 'lean' && lSuppressed && animscripts_utility.animArrayAnyExist(name(lAnimName $ "_reload")) && randomfloat(100) < 75)
	{
		lSwitchAnim = animscripts_utility.animArrayPickRandom(name(lAnimName $ "_reload"));
		lRate = 1;
		lReloading = true;
	}
	// turn off the standing anim
	setanimlimited(animscripts_utility.animarray('straight_level'), 0, 0.1);
	
	lSwitchAnim = SetCustomAnim(corner, lSwitchAnim);
	// as we turn on the hiding anim
	setFlaggedAnimKnobAllRestart('hide', lSwitchAnim, 'body', 1, 0.1, lRate);
	animscripts_shared.DoNoteTracks('hide');
	a.alertness = 'alert';	// Should be set in the aim2alert animation but sometimes isn't.
	
	if (lReloading)
		animscripts_weaponList.RefillClip();
	
	notify ('stop updating angles');
	notify ('stop EyesAtEnemy');
	notify ('stop tracking');
	
	changingCoverPos = false;
	if (cornerDirection == 'left')
		a.special = 'cover_left';
	else
		a.special = 'cover_right';
	
	keepClaimedNodeInGoal = false;
	keepclaimednode = false;
	
	clearAnim(lSwitchAnim, 0.2);
}
