class trans_CrouchToStand extends CoreTask within animscripts_trans;

// parameter

// output

// local
var float standSpeed;

state main
{
Begin:
	standSpeed = 1;
	if (fastStand)
	{
		standSpeed = 1.8;
		fastStand = false;
	}

	//if ((self animscripts\utility::weaponAnims() == 'pistol') || (self animscripts\utility::weaponAnims() == 'none'))
	//{
	//	PlayTransitionAnimation('pistol_crouchaimstraight2stand', 'stand', 'stop', standSpeed);
	//}
	//else
	//{
		// Decide which idle animation to do
		animscripts_utility.randomizeIdleSet();

		PlayTransitionAnimation(SetCustomAnim(stand_and_crouch, 'casual_crouch_2_stand'), 'stand', 'stop', , , standSpeed);
	//}
	//clearanim('shoot', 0);	// This stops the residue from crouch aiming from showing up when we stand aim.
}
