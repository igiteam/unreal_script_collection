/**
 * GearWeap_IncendiaryGrenade
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_IncendiaryGrenadeBase extends GearWeap_GrenadeBase
	abstract;

/** projectile behavior upgrade */
var()	TWeaponParam	PRM_Behavior;

var MeshComponent PickupMeshComp;

/** Particle to play when spinning */
var ParticleSystemComponent PSC_SpinEffect;

/**
 * ThrowGrenade Projectile
 */
function GearProj_Grenade ThrowGrenade()
{
	if ( WorldInfo.NetMode != NM_Client )
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_ThrowingIncendiaryGrenade, Instigator);
	}
	return super.ThrowGrenade();
}

static function PrimitiveComponent GetPickupMesh(PickupFactory Factory)
{
	return default.PickupMeshComp;
}

/** 
 * Called by AttachWeaponTo to perform weapon attachment after we're sure it's ok to do so. 
 * Attach the spin effect particle if it's already setup, needed for mirroring
 * 
 * @param   MeshCpnt    SkeletalMeshComponent where to attach weapon
 * @param	SocketName  Name of Socket to use in provided SkeletalMeshComponent
 */
simulated function PerformWeaponAttachment(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	Super.PerformWeaponAttachment(MeshCpnt, SocketName);

	if (PSC_SpinEffect != None)
	{	
		SkeletalMeshComponent(Mesh).AttachComponentToSocket(PSC_SpinEffect, 'SpinEffect');

		if( ShouldWeaponBeMirrored(GearPawn(Instigator)) )
		{
			// the PSCs don't like that the mesh is scaled, so apply inverse scaling to get back to normal
			PSC_SpinEffect.SetScale3D(vect(1,-1,1));
		}
		else
		{
			PSC_SpinEffect.SetScale3D(vect(1,1,1));			
		}
	}
}


/** This will return the COG Emissive Color for this weapon for this map **/
// Incendiarys are always this color
static simulated function LinearColor GetWeaponEmisColor_COG( WorldInfo TheWorldInfo, EWeaponClass WeapID )
{
	local LinearColor LC;
//
// 	LC.R = 3;
// 	LC.G = 4;
// 	LC.B = 8;
// 	LC.A = 1;

	LC.R = 30;
	LC.G = 2;
	LC.B = 1.5;
	LC.A = 1;

	return LC;
}

/** This will return the Locust Emissive Color for this weapon for this map **/
// Incendiarys are always this color
static simulated function LinearColor GetWeaponEmisColor_Locust( WorldInfo TheWorldInfo, EWeaponClass WeapID )
{
	local LinearColor LC;

// 	LC.R = 3;
// 	LC.G = 4;
// 	LC.B = 8;
// 	LC.A = 1;

	LC.R = 30;
	LC.G = 2;
	LC.B = 1.5;
	LC.A = 1;

	return LC;
}

state Active
{
	/**
	 * Turn on the spin effect particle
	 * 
	 * @param PreviousStateName - the last state we were in
	 */
	simulated function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		PSC_SpinEffect.ActivateSystem();
	}
	
	/**
	 * Turn off the spin effect particle if we're not throwing it
	 * 
	 * @param NextStateName - the next state we are going to
	 */
	simulated function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		
		if (NextStateName != 'ThrowingGrenade')
		{
			PSC_SpinEffect.DeactivateSystem();
		}
	}
}

state ThrowingGrenade
{
	/**
	 * Turn off the spin effect particle
	 * 
	 * @param NextStateName - the next state we are going to
	 */
	simulated function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		
		PSC_SpinEffect.DeactivateSystem();
	}
}

defaultproperties
{
	WeaponStatName="IncendiaryGrenade"

	DamageTypeClassForUI=class'GDT_IncendiaryGrenade'

	// weapon parameters
	PRM_Behavior=(Value=(0,1,2),Name="Level")

	InstantHitDamageTypes(0)=class'GDT_IncendiaryGrenade'
	AmmoTypeClass=class'GearAmmoType_GrenadeSmoke'


	LC_EmisDefaultCOG=(R=1.0,G=3.0,B=8.0,A=1.0)
	LC_EmisDefaultLocust=(R=15.0,G=2.0,B=0.0,A=1.0)

	WeaponID=WC_IncendiaryGrenade

}
