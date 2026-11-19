//=============================================================================
// SASFPWeaponMeshActor.uc
//
// Abstract base class of 1st person weapon attached components. SASWeapons 
// have a first person empty hands model as their mesh. The gun/clip etc 
// are SASFPWeaponMeshActor objects attached to a node on the hands mesh.
// These attached components can have a number of weapon animations (reload, fire
// etc) which, if they exist within the meshes anim set, will be played in
// synch with the matching animation on the hands.
//=============================================================================

class SASFPWeaponMeshActor extends Actor
	native
	notplaceable
	abstract
	dependson(SASWeapon);


//-----------------------------------------------------------------------------
// Constants

// Single frame animation 'resting pose' anim played when no other anims
// are being played.
const RESTING_FRAME	= 'Weapon_Neutral';


//-----------------------------------------------------------------------------
// Member variables

var name	mSelectAnim;		// Select weapon anim
var name	mFireAnim;			// Fire weapon anim
var name	mFireEmptyAnim;		// Fire with empty clip anim
var name	mReloadAnim;		// Reload anim
var name	mReloadEndAnim;		// Reload end (used by shotgun)
var name	mPullPinAnim;		// Pull pin anim on grenade weapons
var name	mThrowGrenadeAnim;	// Throwing grenade anim

//-----------------------------------------------------------------------------
// Replication Expressions
/*
replication
{
	reliable if ( bNetDirty && ( Role == ROLE_Authority ) )
		mSelectAnim,
		mFireAnim,
		mFireEmptyAnim,
		mReloadAnim,
		mPullPinAnim,
		mThrowGrenadeAnim;
}
*/
//-----------------------------------------------------------------------------
// Native Functions


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// FixupAnims
//
// Fix up the animations which can be played in synch with the weapon.
simulated function FixupAnims(
	SASWeapon	aRefWeapon )
{
	if ( aRefWeapon == None )
	{
		return;
	}
	
	// Select weapon anim.
	if ( (mSelectAnim == 'None') || !HasAnim( mSelectAnim ) )
	{
		mSelectAnim = 'None';
		if ( HasAnim( aRefWeapon.ANIMNAME_Select ) )
		{
			mSelectAnim = aRefWeapon.ANIMNAME_Select;
		}
	}

	// Firing anim.
	if ( (mFireAnim == 'None') || !HasAnim( mFireAnim ) )
	{
		mFireAnim = 'None';
		if ( HasAnim( aRefWeapon.mSightedFireAnim ) )
		{
			mFireAnim = aRefWeapon.mSightedFireAnim;
		}
		else if ( HasAnim( aRefWeapon.mUnsightedFireAnim ) )
		{
			mFireAnim = aRefWeapon.mUnsightedFireAnim;
		}
	}

	// Firing empty anim.
	if ( (mFireEmptyAnim == 'None') || !HasAnim( mFireEmptyAnim ) )
	{
		mFireEmptyAnim = 'None';
		if ( HasAnim( aRefWeapon.ANIMNAME_SightedEmpty ) )
		{
			mFireEmptyAnim = aRefWeapon.ANIMNAME_SightedEmpty;
		}
		else if ( HasAnim( aRefWeapon.ANIMNAME_UnsightedEmpty ) )
		{
			mFireEmptyAnim = aRefWeapon.ANIMNAME_UnsightedEmpty;
		}
	}

	// Reload anim.
	if ( (mReloadAnim == 'None') || !HasAnim( mReloadAnim ) )
	{
		mReloadAnim = 'None';
		if ( HasAnim( aRefWeapon.ANIMNAME_Reload ) )
		{
			mReloadAnim = aRefWeapon.ANIMNAME_Reload;
		}
	}

	// Reload anim.
	if ( (mReloadEndAnim == 'None') || !HasAnim( mReloadEndAnim ) )
	{
		mReloadEndAnim = 'None';
		if ( HasAnim( aRefWeapon.ANIMNAME_ShotGunReloadEnd ) )
		{
			mReloadEndAnim = aRefWeapon.ANIMNAME_ShotGunReloadEnd;
		}
	}

	// Pull pin anim.
	if ( (mPullPinAnim == 'None') || !HasAnim( mPullPinAnim ) )
	{
		mPullPinAnim = 'None';
		if ( HasAnim( aRefWeapon.ANIMNAME_PullPin ) )
		{
			mPullPinAnim = aRefWeapon.ANIMNAME_PullPin;
		}
	}

	// Throw grenade anim.
	if ( (mThrowGrenadeAnim == 'None') || !HasAnim( mThrowGrenadeAnim ) )
	{
		mThrowGrenadeAnim = 'None';
		if ( HasAnim( aRefWeapon.ANIMNAME_ThrowGrenade ) )
		{
			mThrowGrenadeAnim = aRefWeapon.ANIMNAME_PullPin;
		}
	}
}


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
	
	if ( aRate == 0.0 )
	{
		aRate = 1.0;
	}

	switch ( aeWpnAnim )
	{
	case WPNANIM_SightedFire:
	case WPNANIM_UnsightedFire:
		anim = mFireAnim;
		break;

	case WPNANIM_SightedEmpty:
	case WPNANIM_UnsightedEmpty:
		anim = mFireEmptyAnim;
		break;

	case WPNANIM_Reload:
		anim = mReloadAnim;
		break;

	case WPNANIM_ShotgunReloadEnd:
		anim = mReloadEndAnim;
		break;

	case WPNANIM_PullPin:
		anim = mPullPinAnim;
		break;

	case WPNANIM_ThrowGrenade:
		anim = mThrowGrenadeAnim;
		break;
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
		// Don't tween to idle when playing down weapon anim on a grenade weapon as this 
		// results in the pin being seen to fly back into the grenade.
		if (	aeWpnAnim == WPNANIM_Deselect &&
				Owner != None ||
				SASGrenadeWeapon( Owner ) != None )
		{
			StopAnimating();
		}
		else
		{
			TweenToIdle( 0.05 );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// TweenToIdle
//
// Tween to the resting frame animation.
simulated function TweenToIdle(
	float aBlendTime )
{
	TweenAnim( RESTING_FRAME, aBlendTime );
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    DrawType=2
    RemoteRole=0
}