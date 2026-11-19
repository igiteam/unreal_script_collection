class cover_wall_go_to_hide extends CoreTask within animscripts_cover_wall;

state main
{
Begin:
	notify('return_to_cover');
	
	changingCoverPos = true;
	notify('done_changing_cover_pos');
	
	endStandIdleThread();
	
	setFlaggedAnimKnobAll('go_to_hide' , SetCustomAnim(misc_modern, animscripts_utility.animArray(name(a.coverMode $ "_2_hide"))), 'body', 1, 0.2);
	clearAnim('exposed_modern', 0.2);
	
	animscripts_shared.DoNoteTracks('go_to_hide');
	
	notify('stop tracking');
	
	a.coverMode = 'hide';
	
	if (coverType == 'stand')
		a.special = 'cover_stand';
	else
		a.special = 'cover_crouch';
	
	changingCoverPos = false;
}
