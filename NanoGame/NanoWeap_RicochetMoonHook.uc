/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_RicochetMoonHook extends NanoWeapon;


/** Used for displaying debug info - toggle with 'DEBUGRICOCHETMOON' console command */
var bool bRicochetMoonDebug;

var SoundCue    MoonThrowSound;

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	Super.AttachWeaponTo(MeshCpnt, SocketName);
}

simulated function DetachWeapon()
{
	Super.DetachWeapon();
}

simulated state WeaponFiring
{
	/** This is empty, as we don't want auto-refire */
	simulated function RefireCheckTimer()
	{
	}

	/** Called from FireAmmunition - only once when state begins, because RefireCheckTimer is empty (see above) */
	simulated function CustomFire()
	{
		`loginfo( 'Nano_Melee', WorldInfo.TimeSeconds@`location@GetStateName() );
		WeaponFired(CurrentFireMode);
	}

	/** Custom BeginFire function - called when a fire button is pressed during an attack */
	simulated function BeginFire(byte FireModeNum)
	{
		//`log( "RM: " @ FireModeNum );

		if( FireModeNum == 0 )
		{
			ThrowRicochetMoon();
		}
		else if( FireModeNum == 1 )
		{
		}
	}

}


/** State used for throwing the sword */
simulated state RicochetMoonThrow extends WeaponFiring
{
	simulated function Projectile ProjectileFire()
	{
		//`log( "SwordThrow ProjectileFire " );
		return ThrowRicochetMoon();
	}
}


simulated function Projectile ThrowRicochetMoon()
{
	local NanoPawn NP;

	NP = NanoPawn(Instigator);

	NP.RunningFullBodySlot.PlayCustomAnim('Attack_Sword_Throw_1st', 1.0, 0.05, 0.05, FALSE, TRUE);

	PlayerController(NP.Controller).PlaySound(MoonThrowSound);

	// Delay before actually spawning projectile as the anim above lasts this long
	SetTimer(0.72f, FALSE, nameof(SpawnThrownMoon));

	//`log( "Throwing sword" );
	return None;
}




/** Spawn actual hook projectile and also have pawn drop this weapon */
simulated function SpawnThrownMoon()
{
	local NanoPC NPC;
	local NanoPawn NP;
	local NanoProj_RicochetMoonHook SpawnedProjectile;
	local vector FireLoc, AimDir;


	NP = NanoPawn(Instigator);
	if( NP == None )
	{
		return;
	}

	NPC = NanoPC(NP.Controller);
	if (NPC != None)
	{
		// Get where projectile should come from
		FireLoc = Instigator.GetWeaponStartTraceLocation();

		// throw out from where we are looking at and then the projectile will fly toward what we have in the TargetList
		AimDir = vector(NPC.Rotation);
		
		// Spawn thrown sword
		SpawnedProjectile = Spawn(class'NanoGame.NanoProj_RicochetMoonHook', Self,, FireLoc);
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.OwnerOfThisRicochetMoon = NP;
			SpawnedProjectile.Init(AimDir);
			NPC.ThrownHook = SpawnedProjectile;
		}

		// Destroy weapon!
		NP.DiscardCurrentWeapon();
	}
}





defaultproperties
{
	WeaponUIName="RicochetMoonHook"

	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'REB_Ricochetmoon.SK_RicochetMoon_Proto'
		PhysicsAsset=PhysicsAsset'REB_Ricochetmoon.SK_RicochetMoon_Proto_Physics'
		//AnimTreeTemplate=AnimTree'COG_AssaultRifle.AT_COG_AssaultRifle'
		//AnimSets(0)=AnimSet'COG_AssaultRifle.Animations.COG_AssaultRifle'
	End Object
	Mesh=WeaponMeshComp

	bAllowTracers=FALSE

	FiringStatesArray(0)=RicochetMoonThrow//WeaponFiring
	WeaponFireTypes(0)=EWFT_Projectile
	FireInterval(0)=0.100

	bRicochetMoonDebug=TRUE

	SummonEffect=ParticleSystem'Nano_WeaponFX.Moon.Effects.P_Nano_RicochetMoonSpawn'
	SummonEffectSocketName="RightHand"
	SummonAnimName="NW_Summon_RicochetMoon"
	ThrowAwayAnimName="SMG_Throw_Away"
	TimeToSummonWeapon=0.050
	SummonCue=SoundCue'Weapon_Sword.Sword.Sword_Summon_Cue'
	DismissCue=SoundCue'Weapon_Sword.Sword.Sword_Dismiss_Cue'
	UnholsterCue=SoundCue'Weapon_Sword.Sword.Sword_UnStow_Cue'
	

	MoonThrowSound=SoundCue'Weapon_Boomerang.Boomerang.Boomerang_Throw_Cue'
}