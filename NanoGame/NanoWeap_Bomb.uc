/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoWeap_Bomb extends NanoWeapon;


simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	Super.AttachWeaponTo(MeshCpnt, 'LeftHand');
}


simulated function DetachWeapon()
{
	Super.DetachWeapon();
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
	// just dirty hack for now
	local vector Start, End, HitLoc, HitNorm;
	local rotator Rot;
	local Actor				HitActor;
	//local TraceHitInfo		HitInfo;
	local Actor SpawnedActor;

	Instigator.GetActorEyesViewPoint( Start, Rot );
	End = Start + (vector(Instigator.Controller.Rotation) * 512.0f);

	HitActor = Trace( HitLoc, HitNorm, End, Start, TRUE );

	if( FiringMode == 0 )
	{
		// we don't want to be able to make grey goo floating in space so make certain we have a HitActor
		if( HitActor != none )
		{
			if( PayNanoPowerCost() == FALSE )
			{
				return;
			}

			// only spawn this on the server and have it replicated out to the clients
			if( Role == ROLE_Authority )
			{
				// so here we want to spawn a slickify "area" which is just a cylinder
				SpawnedActor = Spawn( class'NanoBomb',,, HitLoc+vect(0,0,8) );
				SpawnedActor.SetBase( HitActor );
				NanoPawn(Instigator).NanoBombsInFlight.AddItem( NanoBomb(SpawnedActor) );

				//`log( "NanoPawn(Instigator).NanoBombsInFlight.Length" @ NanoPawn(Instigator).NanoBombsInFlight.length );
			}
		}
	}
}




defaultproperties
{
	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'COG_Mortar.Mesh.Mortar_Shell'
		PhysicsAsset=PhysicsAsset'COG_Mortar.Mesh.Mortar_Shell_Physics'
		Rotation=(Pitch=0,Yaw=0,Roll=-16384)
		Scale=1.0f
	End Object
	Mesh=WeaponMeshComp

	bAllowTracers=FALSE

	WeaponRange=512.0f // only can place these bombs near you
}