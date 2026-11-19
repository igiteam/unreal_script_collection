//===============================================================================
//  [ABSTRACT_WeapGrenade]  
//===============================================================================

class ABSTRACT_WeapGrenade extends ZombieWeapon abstract;

var(WeapHandAnimations) name xSingleFireThrow;

var bool bCookingOff;
var bool bCookoffInHand;
var float CookoffStartTime;
var float CookoffDuration;
var float MinProjectileInterval;
var float TimeOfLastProjectile;
var bool bFireAfterReload;

var Sound PinPullSound;
var Sound ThrowSound;

var name xNoHandsAnim;

var float TimeOfLast3rdPersonHide;
var float ThirdPersonHideInterval;


// Pawn animations
var name PawnHoldAnim;		// first stage of throwing - players have the ability to hold the grenade (cook it)

replication
{
	reliable if( Role == ROLE_Authority )
		ClientBlewUpInHand;
	reliable if( Role < ROLE_Authority )
		ServerStartCookoff, ServerSpawnProjectile, ServerReloadGrenade;
}

simulated function Fire( float Value )
{
//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.Fire   ##  state:"$ GetStateName() );
//GRENSPAM	Log( FormatTime(Level.Hour*3600+Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.Fire   ##  state:"$ GetStateName() $"  bReleasedFireSinceLastShot:"$ bReleasedFireSinceLastShot );
	if ( !HasAmmo() )
		return;
	else if( GetReloadCount() == 0 )
	{
	//	ReloadGrenade();
	//	PlaySelect();
		bFireAfterReload=true;
		GotoState('Reloading');
		return;
	}

	bReleasedFireSinceLastShot = false;
	GotoState('CookingOff');
}


/* BotFire()
called by NPC firing weapon.
bFinished should only be true if called from the Finished() function
FiringMode can be passed in to specify a firing mode (used by scripted sequences)
*/
event bool BotFire(bool bFinished, optional float BotAccuracy, optional name FiringMode)
{
	if ( !bFinished && !IsIdle() )
		return false;
	
	Instigator.Controller.bFire = 1;
	Instigator.Controller.bAltFire = 0;

	GotoState('CookingOff');
	bReleasedFireSinceLastShot = true;

	return true;
}

simulated function ClientBlewUpInHand();

state CookingOff
{
	ignores Fire;

	simulated function BeginState()
	{
	//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.CookingOff.BeginState ");
		// Play pull pin and pull back arm anim
		if( HasAnim( xSingleFire ) )
			PlayAnim( xSingleFire );
		if (UseAttachAnims && UseWeapAttachment && (AttachFireAnim != ''))
		{
			WeapAttachment.PlayAnim(AttachFireAnim, 1.0f, 0.02f);
		}

		if( PinPullSound != None )
			Instigator.PlaySound(PinPullSound,SLOT_Interface,,,);  // arg 2: slot, arg 5: radius

		if( SFRMPlayerController( Instigator.Controller ) != None )
		{
			SFRMPlayerController( Instigator.Controller ).ServerPullNade( );
		}
	}

	simulated function AnimEnd(int Channel)
	{
	//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.CookingOff.AnimEnd ");
		if( bReleasedFireSinceLastShot )
			GotoState('Throwing');
		else
		{
			ServerStartCookoff();
			if( Role < ROLE_Authority )
				ClientStartCookoff();
		}
	}

	simulated function ReleaseFire( optional float F )
	{
	//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.CookingOff.ReleaseFire ##");
	//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.CookingOff.ReleaseFire ##  state:"$ GetStateName() );

		bReleasedFireSinceLastShot = true;

	//GRENSPAM	Log( FormatTime(Level.Hour*3600+Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.CookingOff.ReleaseFire ##  state:"$ GetStateName() $"  just set:  bReleasedFireSinceLastShot:"$ bReleasedFireSinceLastShot );
	//	GotoState('Throwing');
		ServerReleaseFire();
	}

	simulated function ClientBlewUpInHand()
	{
	//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.CookingOff.ClientBlewUpInHand ##  state:"$ GetStateName() );
		bReleasedFireSinceLastShot = true;
		ReloadCount=0;
		GotoState('Reloading');

	//	GotoState('Throwing');

	//	ReloadCount=0;
	//	GotoState('Idle');
	}

	simulated function Tick( float TimeDelta )
	{
		if( bReleasedFireSinceLastShot && bCookingOff )
			GotoState('Throwing');
		Global.Tick( TimeDelta );
	}
}

function ServerStartCookoff()
{
//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.ServerStartCookoff ");
	if( HasAmmo() )
	{
		bCookingOff = true;
		CookoffStartTime = Level.TimeSeconds;
	}
}

simulated function ClientStartCookoff()
{
	if( HasAmmo() )
	{
		bCookingOff = true;
	}
}

simulated function LocalEndCookoff()
{
//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.ClientEndCookoff ");
	bCookingOff = false;
}

function Tick( float TimeDelta )
{
	if( bCookoffInHand && bCookingOff && Level.TimeSeconds > CookoffStartTime + CookoffDuration && ReloadCount > 0 )
	{
		// Spawn projectile with very little velocity or lifespan
		ServerSpawnProjectile( true );

		ClientBlewUpInHand();
	}

	///DEBUG!!!!
	if (DEBUG_WeapAttachment && UseWeapAttachment)
	{
		MakeWeapAttachment();
	}

	if( PVOTransitionTime > 0 )
	{
		InterpolatePVO( TimeDelta );
	}

	if( ThirdPersonActor != None && ThirdPersonActor.bHidden && Level.TimeSeconds > TimeOfLast3rdPersonHide + ThirdPersonHideInterval 
		&& HasAmmo() && Role==ROLE_Authority )
	{
		UnHideThirdPersonActor();
	}
}

// Client-side state
state Throwing
{
	ignores Fire;

	simulated function BeginState()
	{
	//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.Throwing.BeginState ");
		// Play throw anim
		if( HasAnim( xSingleFireThrow ) )
			PlayAnim( xSingleFireThrow );
		Instigator.PlaySound(ThrowSound,SLOT_Interface,,,);  // arg 2: slot, arg 5: radius

		if( SFRMPlayerController( Instigator.Controller ) != None )
		{
			SFRMPlayerController( Instigator.Controller ).ServerReleaseNade( );
		}

	}

	simulated function AnimEnd(int Channel)
	{
	//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.Throwing.AnimEnd ");
		if( GetReloadCount() > 0 )
		{
		//	Log("          AnimEnd is spawning projectile!!!");
			SpawnProjectile();
		}

		GotoState('Reloading');
	}

// Might want to add simulated function Tick that will throw grenade if the AnimEnd
// hasn't been hit after a certain period of time?  (3 seconds?)  Or might not.
}

// Anim notify function
simulated function SpawnProjectile()
{
//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.SpawnProjectile ");
	LocalHideWeapAttachment( true );
	ServerSpawnProjectile(false);

	// Decrement ReloadCount if this is client
	if( Role < ROLE_Authority )
		ReloadCount = 0;
}

function ServerSpawnProjectile( bool bCookoffExpired )
{
	local vector X, Y, Z, Start;
	local rotator AdjustedAim;
	local float SpeedModifier;
	local Projectile P;
	local float GrenadeLifespan;

//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.ServerSpawnProjectile   bCookoffExpired:"$ bCookoffExpired $"  RC:"$ ReloadCount );
	// Prevent weird loops where you get stuck throwing infinite grenades
	if( ReloadCount == 0 )
		return;

	if( Level.TimeSeconds < TimeOfLastProjectile + MinProjectileInterval )
		return;
	else
		TimeOfLastProjectile = Level.TimeSeconds;

	// Get start point
	Owner.MakeNoise(fNoiseFactor);
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	Start = GetFireStart(X,Y,Z); 
	//Log(" WeapGrenade.SpawnGrenadeProjectile   Start: "$Start $"   ### ");

	// Set launch direction
	AdjustedAim = Instigator.AdjustAim(AmmoType, Start, AimError, true);	
	AdjustedAim.Pitch += PitchAdjustment( AdjustedAim.Pitch );

	if( bCookoffExpired )
	{
		SpeedModifier = 0.01;
	}
	else
	{
		SpeedModifier = 1.05;
	}

	// Figure out how much time the grenade has left
	if( bCookoffInHand && bCookoffExpired )
	{
		GrenadeLifespan = 0.1;
	}
	else if( bCookoffInHand && bCookingOff )
	{
		GrenadeLifespan  = CookoffDuration - (Level.TimeSeconds-CookoffStartTime);
	}
	else
	{
		GrenadeLifespan  = CookoffDuration;
	}
	//if( Level.NetMode != NM_Standalone )
	//	ClientSetGrenadeLifespan( GrenadeLifespan );

	P = SFRMAmmunition(AmmoType).SpawnProjectileEx(Start,AdjustedAim, SpeedModifier, Level.TimeSeconds);
	P.RandSpin(5000); 

	HideThirdPersonActor();

	// Set projectile lifespan on server.
	// Client-side projectile will grab lifespan when able.
	P.LifeSpan = GrenadeLifespan;
	GrenadeProjectile(P).bGotLifeSpan = true;
	GrenadeProjectile(P).DPLifespan = GrenadeLifespan;

//	Log("           P:"$ P $"  P loc:"$ P.Location $"  dloc:"$ P.Location - Location $"  P.Velocity:"$ P.Velocity );
//	Log("           SM:"$ SpeedModifier $"  CookoffDuration:"$ CookoffDuration $"  Level.TimeSeconds:"$ Level.TimeSeconds $"  CookoffStartTime:"$ CookoffStartTime $"  L.TS-CST:"$ (Level.TimeSeconds-CookoffStartTime) $"  P.Ls:"$ P.LifeSpan );

	LocalEndCookoff();

	// Decrement ReloadCount
	ReloadCount = 0;

	if( Level.bMPWeapLogs )
		Log( Level.TimeSeconds $" MPLog: #### Thrown projectile thrown by "$ instigator.PlayerReplicationInfo.PlayerName $"  weap:"$ self.class $"  lifespan remaining:"$ GrenadeLifespan );
}

simulated function int PitchAdjustment( int pitchIn )
{
	local int pitchDelta;

	if( pitchIn >= 0 && pitchIn < 8192 ) // 8192 = 45 deg
	{
		// From 0 to 45 deg, add 25 degrees
		pitchDelta = 4551; // 4551 = 25 deg
	}
	else if( pitchIn >= 8192 && pitchIn < 14564 ) // 14564 = 80 deg
	{
		// From 45 to 80 deg pitch, scale down pitch adjustment to 0
		pitchDelta = 4551*(14564-pitchIn)/(14564-8192);
	}
	else if( pitchIn > 54613 && pitchIn <= 65536 ) // 54613 = 300 deg = -60 deg
	{
		// From 0 to -60 deg pitch, scale down pitch adjustment to 0
		pitchDelta = 4551*(pitchIn-54613)/(65536-54613);
	}
	else
	{
		pitchDelta = 0;
	}
//GRENSPAM	Log("  PitchAdjustment:  pitchIn:"$ pitchIn $"  pitchDelta:"$ pitchDelta );

	return pitchDelta;
}

simulated function UnHideThirdPersonActor()
{
	ThirdPersonActor.bHidden = false;
//	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.UnHideThirdPersonActor  GRC():"$ GetReloadCount() $"  TPA.bHidden:"$ ThirdPersonActor.bHidden );
}

simulated function HideThirdPersonActor()
{
	ThirdPersonActor.bHidden = true;
	TimeOfLast3rdPersonHide = Level.TimeSeconds;
//	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.HideThirdPersonActor    GRC():"$ GetReloadCount() $"  TPA.bHidden:"$ ThirdPersonActor.bHidden );
}

simulated function ReloadGrenade()
{
//	ThirdPersonActor.bHidden = false;
//	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.ReloadGrenade  GRC():"$ GetReloadCount() $"  TPA.bHidden:"$ ThirdPersonActor.bHidden );

	if( Role < ROLE_Authority )
	{
		// Tell server to reload grenade
		ServerReloadGrenade();

		// If it has ammo, it will reload soon, so increment ReloadCount on the client
		// (just in case the server's update to ReloadCount is slow to arrive).
		ReloadCount++;
	}
	else
	{
		// Otherwise, we're single-player, or player on a listen server
		ReloadCount += AmmoType.RequestReloadAmmo(GetDefaultReloadCount() - GetReloadCount());
	}
}

state Reloading
{
	simulated function BeginState()
	{
	//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.Reloading.BeginState ");
		if( Role < ROLE_Authority )
			LocalEndCookoff();

		if( HasAmmo() )
		{
		//GRENSPAM	Log("           GDRC():"$ GetDefaultReloadCount() $"  GRC():"$ GetReloadCount() );
			ReloadGrenade();
		//GRENSPAM	Log("           RC:"$ ReloadCount );
			Instigator.PlaySound(ReloadSound,SLOT_Interface,,,240.0);  // arg 2: slot, arg 5: radius
		}
		else
			bFireAfterReload=false;

		PlaySelect();
	}

	simulated function AnimEnd( int Channel )
	{
	//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.Reloading.AnimEnd ");
		GotoState('Idle');
		if( bFireAfterReload )
		{
			bFireAfterReload=false;
			GotoState('CookingOff');
		}
	}
}

simulated function HandleWeapAttachmentVisibility()
{
	if( GetReloadCount() > 0 )
	{
		LocalHideWeapAttachment(false);
	}
	else
	{
		LocalHideWeapAttachment(true);
	}
}

simulated function PlaySelect()
{
//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.PlaySelect  GRC():"$ GetReloadCount() );
	HandleWeapAttachmentVisibility();

//GRENSPAM	Log("           WeapAttachment.bHidden:"$ WeapAttachment.bHidden );
	if( ReloadCount == 0 && AmmoType.AmmoAmount == 0 && xNoHandsAnim != '' )
	{
		PlayAnim(xNoHandsAnim);
	}
	else
	{
		PlayAnim(xSelectAnim);
		if (UseAttachAnims && UseWeapAttachment && (AttachReloadAnim != ''))
		{
			WeapAttachment.PlayAnim(AttachReloadAnim, 1.0f, 0.02f);
		}
	}
}

function ServerReloadGrenade()
{
//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.ServerReloadGrenade ");
	ReloadCount += AmmoType.RequestReloadAmmo(GetDefaultReloadCount() - GetReloadCount());
	ClientUpdateReloadCount(ReloadCount);

//	ThirdPersonActor.bHidden = false;
//	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.ServerReloadGrenade  GRC():"$ GetReloadCount() $"  TPA.bHidden:"$ ThirdPersonActor.bHidden );
}

simulated function LocalHideWeapAttachment( bool bHiddenNew )
{
	if ( WeapAttachment != None )
	{
//GRENSPAM	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  WG.LocalHideWeapAttachment   bHiddenNew:"$ bHiddenNew );
		WeapAttachment.bHidden = bHiddenNew;
	}
}

simulated function PlayIdleAnim(optional bool bForceSubtle)
{
	if( ReloadCount == 0 && AmmoType.AmmoAmount == 0 && xNoHandsAnim != '' )
	{
		xSubtleIdle    = xNoHandsAnim;
		xNonSubtleIdle = xNoHandsAnim;
	}
	else
	{
		// If we were previously playing no-ammo anim,
		// make sure attachment is visible again.
		if( xSubtleIdle != default.xSubtleIdle )
		{
			ServerReloadGrenade();
			LocalHideWeapAttachment( false );
			PlaySelect();
			xSubtleIdle    = default.xSubtleIdle;
			xNonSubtleIdle = default.xNonSubtleIdle;
			return;
		}
	}

	Super.PlayIdleAnim(bForceSubtle);
}

//state Idle
//{
//	simulated function Tick( float TimeDelta )
//	{
//		// If we were empty and we just got more ammo,
//		// then "reload" the grenade
//		if( WeapAttachment.bHidden && HasAmmo() )
//		{
//			ServerReloadGrenade();
//			PlaySelect();
//		}
//		Super.Tick( TimeDelta );
//	}
//}

state Active
{
	simulated function BeginState()
	{
		if( HasAmmo() )
		{
			// If we were empty the last time we were active,
			// and we now have ammo, then "reload" the grenade.
			if( WeapAttachment == None || WeapAttachment.bHidden )
			{
				ReloadGrenade();
			}

			// If we have ammo, play the reload/select sound
		//	if( ReloadSound != None )
		//		Instigator.PlaySound(ReloadSound,SLOT_Interface,,,240.0);  // arg 2: slot, arg 5: radius
		//	Log("Active.BeginState  PlaySound ReloadSound ===================");
		}

		PlaySelect();

		Super.BeginState();
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    CookoffDuration=2.0000000
    ThirdPersonHideInterval=0.3000000
    PawnHoldAnim="aim_grenade_shoot_pull"
    BurstLength=1
    bCanZoom=false
    ZoomPlayerViewOffset=(X=8.0000000,Y=0.0000000,Z=0.5000000)
    ZoomRotationOffset=(Pitch=0,Yaw=0,Roll=0)
    LeanPlayerViewOffset=(X=-0.5000000,Y=-5.0000000,Z=-1.0000000)
    LeanRotationOffset=(Pitch=0,Yaw=-240,Roll=0)
    ZoomLeanPlayerViewOffset=(X=8.0000000,Y=-3.0000000,Z=0.0000000)
    ZoomLeanRotationOffset=(Pitch=0,Yaw=-240,Roll=0)
    TakeOutAnim[0]="aim_grenade_select"
    TakeOutAnim[1]="aim_grenade_select"
    PutAwayAnim[0]="aim_grenade_deselect"
    PutAwayAnim[1]="aim_grenade_deselect"
    PoseAnim[0]="aim_grenade_pose"
    PoseAnim[1]="aim_grenade_pose"
    PawnFireAnim="aim_grenade_shoot_throw"
    CrosshairIndex=-1
    AmmoName=Class'GrenadeAmmo'
    PickupAmmoCount=24
    ReloadCount=1
    FireOffset=(X=20.0000000,Y=20.0000000,Z=0.0000000)
    AIRating=0.4100000
    DisplayFOV=60.0000000
    InventoryGroup=110
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    BobDamping=0.9750000
    ItemName="Grenade"
    DrawScale=1.0000000
}