class M60_FPGunMesh extends SASFPWeaponMeshActor;


///////////////////////////////////////////////////////////////////////////////
// PlayWeaponAnim
//
// Play a specified weapon animation on this component if the anim tpye exists.
// Else plays the 'resting' anim.
simulated function PlayWeaponAnim(
	SASWeapon.EWeaponAnim		aeWpnAnim,		// Weapon anim type.
	optional float				aRate,			// Playback rate.
	optional float				aBlendTime,		// Tween blend time
	optional float				aStartFrame )	// Start frame to play anim from (0->1.0)
{
	local name	anim;

	if (	(aeWpnAnim == WPNANIM_SightedFire || aeWpnAnim == WPNANIM_UnsightedFire) &&
			SASWeapon( Owner ).mNumInMag < 5 )
	{
		if ( aRate == 0.0 )
		{
			aRate = 1.0;
		}

		if ( SASWeapon( Owner ).mNumInMag == 4 )
		{
			anim = 'Weapon_Fire_Plus3';
		}
		else
		{
			anim = 'Weapon_Fire_Empty';
		}

		if ( anim != 'None' )
		{
			PlayAnim( anim, aRate, aBlendTime );

			if ( aStartFrame > 0.0 )
			{
				SetAnimFrame( aStartFrame );
			}
		}
		else
		{
			TweenToIdle( 0.05 );
		}
	}
	else
	{
		Super.PlayWeaponAnim( aeWpnAnim, aRate, aBlendTime, aStartFrame );
	}
}


///////////////////////////////////////////////////////////////////////////////
// TweenToIdle
//
// Tween to the resting frame animation.
simulated function TweenToIdle(
	float aBlendTime )
{
	local name anim;
	local SASWeapon	wpnOwner;

	wpnOwner = SASWeapon( Owner );
	if ( wpnOwner.mNumInMag > 3 )
	{
		anim = RESTING_FRAME;
	}
	else if ( wpnOwner.mNumInMag < 3 )
	{
		anim = 'WEAPON_Neutral_Empty';
	}
	else
	{
		anim = 'WEAPON_Neutral_Plus3';
	}

	TweenAnim( anim, aBlendTime );
}


// Decompiled with UE Explorer.
defaultproperties
{
    mFireAnim="WEAPON_Fire"
    mReloadAnim="WEAPON_reload"
    Mesh=SkeletalMesh'WpAn.WEAPON_M60'
}