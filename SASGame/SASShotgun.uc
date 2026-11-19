class SASShotgun extends SASWeapon;

var int				mReloadNumShellsAdded;
var array<Sound>	mReloadShellSounds;


simulated function DecrementAmmo( 
	int aAmount )
{
	// SAS AI don't decrement ammo on shotgun. They only use it for door breaches and 
	// we don't want to worry about reloading issues during that procedure.
	if ( Instigator.Controller.mType == CONTROLLER_AISoldier )
	{
		return;
	}

	Super.DecrementAmmo( aAmount );
}

simulated event AnimNotifyPlayReloadShellSound()
{
	local Sound	reloadSound;

	if ( mReloadShellSounds.Length > 0 )
	{
		reloadSound = mReloadShellSounds[Rand(mReloadShellSounds.Length)];
		if ( reloadSound != None )
		{
			PlayOwnedSound( 
				reloadSound, 
				SLOT_None,
				0.5,
				false,
				mAudibleRadius,
				1,
				true );
		}
	}
}


// Reload state for shotgun is just the barrel opening phase.
state Reloading
{
	ignores ServerForceReload,
			ClientForceReload,
			Fire,
			AltFire,
			ToggleMode,
			Reload;

	simulated event BeginState()
	{
		local int	oldNumInMag;

		// HACK: Super.BeginState removes remaining ammo from clip which is not what we want
		// to happen for shotgun. So remember what is remaining and re-add it.
		oldNumInMag = mNumInMag;
		Super.BeginState();
		AmmoType.AmmoAmount += oldNumInMag;
		mNumInMag = oldNumInMag;
	}

	simulated event EndState();

	simulated function AnimEnd(
		int aChannel )
	{
		GotoState( 'ReloadSingleShell' );
	}
}


state ShotgunReloadBase extends Reloading
{
	simulated event BeginState()
	{
		SetUnaimedView();
		mbSighted = false;
		bForceReload = false;
	}

	///////////////////////////////////////////////////////////////////////////////
	// Fire
	//
	simulated function Fire(
		float	aValue )			// Unused
	{
		if ( mNumInMag > 0 )
		{
			Global.Fire( aValue );
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// AltFire
	//
	simulated function AltFire(
		float	aValue )			// Unused
	{
		if ( mNumInMag > 0 )
		{
			Global.AltFire( aValue );
		}
	}

	function ServerFire()
	{
		if ( mNumInMag > 0 )
		{
			Global.ServerFire();
		}
		else
		{
			bForceFire = true;
		}
	}

	function ServerAltFire()
	{
		if ( mNumInMag > 0 )
		{
			Global.ServerAltFire();
		}
		else
		{
			bForceAltFire = true;
		}
	}
}


simulated function PlayReloadLoop();

state ReloadSingleShell extends ShotgunReloadBase
{
	ignores ServerForceReload,
			ClientForceReload,
			ToggleMode,
			Reload;

	simulated event BeginState()
	{
		Super.BeginState();
		mReloadNumShellsAdded = 0;

		PlayReloadLoop();
	}

	simulated event EndState();


	simulated function PlayReloadLoop()
	{
		PlayWeaponAnim( WPNANIM_ShotGunReloadLoop );
		SASPawn( Instigator ).PlayShotgunReloadSingleShell();
	}


	simulated function AnimEnd(
		int aChannel )
	{
		if (	(mNumInMag == mMagSize) || 
				(mNumInMag >= AmmoType.AmmoAmount) ||
				!HasAmmo() ||
				(mReloadNumShellsAdded >= AmmoType.AmmoAmount) )
		{
			GotoState( 'ReloadEnd' );
			return;
		}

		// Add single shell to gun.
		mReloadNumShellsAdded++;

		if ( Role == ROLE_Authority )
		{
			mNumInMag++;
		}

		if (	(mNumInMag == mMagSize) || 
				(mNumInMag >= AmmoType.AmmoAmount) ||
				!HasAmmo() ||
				(mReloadNumShellsAdded >= AmmoType.AmmoAmount) )
		{
			GotoState( 'ReloadEnd' );
			return;
		}

		PlayReloadLoop();
	}
}

state ReloadEnd extends ShotgunReloadBase
{
	ignores ServerForceReload,
			ClientForceReload,
			ToggleMode,
			Reload;

	simulated event BeginState()
	{
		Super.BeginState();

		PlayWeaponAnim( WPNANIM_ShotGunReloadEnd );
		SASPawn( Instigator ).PlayShotgunReloadEnd();
	}

	simulated function AnimEnd(
		int aChannel )
	{
		if ( Role < ROLE_Authority )
		{
			ClientFinish();
		}
		else
		{
			Finish();
		}
		CheckAnimating();
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    mReloadShellSounds[0]=Sound'MM_Weapons.Reloads.WD_M60_RL_1'
    mCategory=3
    me3PAnimSet=3
}