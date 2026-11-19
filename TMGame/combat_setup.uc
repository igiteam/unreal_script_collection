class combat_setup extends CoreTask within animscripts_combat;

state main
{
Begin:
//	if (usingSidearm())
//		transitionTo('stand');

	if (a.pose == 'stand')
	{
		set_animarray_standing();
	}
	else if (a.pose == 'crouch')
	{
		set_animarray_crouching();
	}
	else if (a.pose == 'prone')
	{
		set_animarray_prone();
	}
	else
	{
		assert (false);
	}
	
	isturning = false;
	stopShortly(true);
	previousPitchDelta = 0.0;
	
	clearAnim('root', 0.2);
	setAnim(animscripts_utility.AnimArray('straight_level'));
	setAnim('add_idle');
	clearanim('aim_4', 0.2);
	clearanim('aim_6', 0.2);
	clearanim('aim_2', 0.2);
	clearanim('aim_8', 0.2);
	
	setupAim(0.2);
	
	idleThread(true);

	a.meleeState = 'aim';
	twitchallowed = true;
}
