/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoWeap_BombDetonator extends NanoWeapon;


/** Time when we first pulled the trigger**/
var transient float TimePulledTrigger;

/** How long to hold the trigger to blow all bombs up **/
var config float DurationToHoldTriggerToBlowAllBombsUp;


simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	Super.AttachWeaponTo(MeshCpnt, 'LeftHand');
}


simulated function DetachWeapon()
{
	Super.DetachWeapon();
}


simulated function bool ShouldRefire()
{
	return FALSE;
}



simulated function SpawnImpactFX(const class<NanoDamageType> NanoDmgType, const out ImpactInfo Impact, bool bFatalShot, bool bMeleeHit, bool bPlayExplosiveRadialDamageEffects)
{

}


/**
* Called when the weapon has fired, to trigger any effects.
* Network: ALL
*/
simulated event WeaponFired(byte FiringMode, optional vector HitLocation)
{
	TimePulledTrigger = WorldInfo.TimeSeconds;

	//`log( self @ "WeaponFired" );
}


/**
* Called when the weapon has fired, to trigger any effects.
* Network: ALL
*/
simulated event WeaponStoppedFiring( byte FiringMode )
{
	//local int Idx;
	local NanoPawn NP;

	NP = NanoPawn(Instigator);


	//`log( self @ "WeaponStoppedFiring" @ (WorldInfo.TimeSeconds - TimePulledTrigger) @ DurationToHoldTriggerToBlowAllBombsUp @ NP.NanoBombsInFlight.Length );


	`log( "SINGLE BOMB GOING BOOM" );
	if( NP.NanoBombsInFlight[0] != none )
	{
		NP.NanoBombsInFlight[0].Explode();
		NP.NanoBombsInFlight.RemoveItem( NP.NanoBombsInFlight[0] );
	}


// 	// if we should blow up all bombs then bring the pain!
// 	if( (WorldInfo.TimeSeconds - TimePulledTrigger) > DurationToHoldTriggerToBlowAllBombsUp )
// 	{
// 		`log( "ALLLL BOMBS GOING BOOM" );
// 		for( Idx = 0; Idx < NP.NanoBombsInFlight.Length; ++Idx )
// 		{
// 			NP.NanoBombsInFlight[Idx].Explode();
// 		}
// 
// 		NP.NanoBombsInFlight.Length = 0;
// 	}
// 	// jut blow up the first one in the list
// 	else
// 	{
//
//	}

}




defaultproperties
{
	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'COG_Mortar.Mesh.Mortar_Shell'
		PhysicsAsset=PhysicsAsset'COG_Mortar.Mesh.Mortar_Shell_Physics'
		Rotation=(Pitch=0,Yaw=0,Roll=-16384)
		Scale=-1.0f
	End Object
	Mesh=WeaponMeshComp

	bAllowTracers=FALSE

}