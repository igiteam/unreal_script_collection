class cover_wall_pop_up extends BoolTask within animscripts_cover_wall;

// local
var name lNewCoverMode;
var name lPopupAnim;
var float lTimeLeft;

state main
{
Begin:
	assert(a.coverMode == 'hide');
	
	lNewCoverMode = getBestCoverMode();
	
	lPopupAnim = SetCustomAnim(misc_modern, animscripts_utility.animArray(name("hide_2_" $ lNewCoverMode)));
	
	if (!mayMoveToPoint(animscripts_utility.getAnimEndPos(lPopupAnim)))
		_return (false);
	
	if (coverType == 'crouch')
		setup_cover_crouch(lNewCoverMode);
	else
		setup_cover_stand();

	a.special = 'none';
	a.coverMode = lNewCoverMode;
	changingCoverPos = true;
	notify('done_changing_cover_pos');
	
	animmode('zonly_physics');
	
	setFlaggedAnimKnobAllRestart('pop_up', lPopupAnim, 'body', 1, 0.1, 1.0);
	DoNoteTracksForPopup('pop_up', true);

	if (animHasNoteTrack(lPopupAnim, 'start_aim'))
	{
		waittillmatch('pop_up', 'start_aim');
		lTimeLeft = getAnimLength(lPopupAnim) * (1 - getAnimTime(lPopupAnim));
	}
	else
	{
		waittillmatch('pop_up', 'end');
		lTimeLeft = 0.1;
	}
	
	setup_additive_aim(lTimeLeft);
	animscripts_shared.trackShootEntOrPos(true);
	clearAnim(lPopupAnim, lTimeLeft + 0.05);
	
	wait (lTimeLeft);
	
	changingCoverPos = false;
	coverPosEstablishedTime = gettime();
	
	notify('stop_popup_donotetracks');
	
	_return (true);
}
