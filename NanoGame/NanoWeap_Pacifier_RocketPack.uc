/**
 * Pacifier Bot Minigun Weapon
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Pacifier_RocketPack extends NanoWeap_Pacifier_Base
	config(Weapon);

var PacifierLimb_RocketPack_Wrapper Wrapper;
var Pacifier_LimbBase	RightPack, LeftPack;

var array<NanoDecal_PacifierRocketArea> DecalActors;

/** Amount of time to allow decals to track before lockon */
var config	float	WarmupTime;

var SoundCue FinishedFireSound;

function InitWeapon( Pacifier_LimbBase L, Pawn NewInstigator )
{
	Super.InitWeapon( L, NewInstigator );

	Wrapper = PacifierLimb_RocketPack_Wrapper(L);
	if( Wrapper != None )
	{
		RightPack = Wrapper.RightPack;
		LeftPack = Wrapper.LeftPack;
		Limb = RightPack;
	}
}

simulated function SwitchActivePack()
{
	if( Limb == None )
	{
		if( RightPack != None && RightPack.AbleToFire() )
		{
			Limb = RightPack;
		}
		else if( LeftPack != None && LeftPack.AbleToFire() )
		{
			Limb = LeftPack;
		}
	}
	else
	if( Limb == RightPack )
	{
		if( LeftPack != None && LeftPack.AbleToFire() )
		{
			Limb = LeftPack;
		}
	}
	else if( Limb == LeftPack )
	{
		if( RightPack != None && RightPack.AbleToFire() )
		{
			Limb = RightPack;
		}
	}
	else
	{
		Limb = None;
	}
	if( Limb != None )
	{
		MuzzleSocketName = Limb.MuzzleSocketName;
		SkeletalMeshComponent(Mesh).AttachComponentToSocket(MuzFlashEmitter, MuzzleSocketName);
	}
}

// Alternate rocket packs
simulated function IncrementFlashCount()
{
	Super.IncrementFlashCount();
	SwitchActivePack();
}

simulated function Actor GetTargetActor()
{
	return Limb.FireTarget;
}

simulated function SpawnDecalActor()
{
	local int Idx;

	Idx = DecalActors.Length;
	if( Idx < NumShotsPerBurst )
	{
		DecalActors[Idx] = Spawn( class'NanoDecal_PacifierRocketArea', self,, Instigator.Location, Rotator(vect(0,0,-1)) );
		DecalActors[Idx].TimeToDest = WarmupTime * 0.97f;
		DecalActors[Idx].Target = GetTargetActor();
		DecalActors[Idx].Init();
		SetTimer( GetFireInterval(0), FALSE, nameof(SpawnDecalActor) );
	}	
}

simulated function DestroyDecalActors()
{
	local int Idx;

	for( Idx = 0; Idx < DecalActors.Length; Idx++ )
	{
		DecalActors[Idx].Destroy();
	}
	DecalActors.Length = 0;
	ClearTimer( nameof(SpawnDecalActor) );
}

simulated state WeaponFiring
{
	simulated event BeginState( Name PreviousStateName )
	{
		Limb = RightPack;
		SetTimer( WarmupTime, FALSE, nameof(WarmupTimeExpired) );
		SpawnDecalActor();
	}

	simulated function WarmupTimeExpired()
	{
		if( ShouldRefire() )
		{
			// Fire the first
			FireAmmunition();
			TimeWeaponFiring( CurrentFireMode );
		}
		else
		{
			HandleFinishedFiring();
		}
	}

	simulated function DelayedBurstFire()
	{
		DestroyDecalActors();
		if( ShouldRefire() )
		{
			SetTimer( WarmupTime, FALSE, nameof(WarmupTimeExpired) );
			SpawnDecalActor();
		}
		else
		{
			// Otherwise we're done firing
			HandleFinishedFiring();
		}
	}

	simulated event EndState( Name NextStateName )
	{
		DestroyDecalActors();
		ClearTimer( nameof(WarmupTimeExpired) );

		Limb = None;
		Super.EndState( NextStateName );
		
		Wrapper.StopFire();

		NanoWeaponPlaySoundLocal( FinishedFireSound );
	}
}

defaultproperties
{
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Projectile
	Spread(0)=0.f
	WeaponProjectiles(0)=class'NanoProj_Pacifier_Rocket'
	FireInterval(0)=+0.2f


	// muzzle flash emitter
	Begin Object Name=PSC_WeaponMuzzleMuzFlashComp
		Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_MP5_MuzzleEffect'
		Scale3D=(X=10.f,Y=10.f,Z=10.f)
	End Object
	MuzFlashEmitter=PSC_WeaponMuzzleMuzFlashComp

	FireSound=SoundCue'Weapon_Pistol.Pistol.Pistol_FirePlayer_Cue'
	FinishedFireSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Rocket_Reload_Cue'
}
