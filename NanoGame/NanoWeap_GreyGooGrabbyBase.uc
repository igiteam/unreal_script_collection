/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_GreyGooGrabbyBase extends NanoWeapon
	abstract;

/** What to spawn when this weapon is fired **/
var class<Actor> GrabbyAreaClass;


simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	Super.AttachWeaponTo(MeshCpnt, 'LeftHand');
}


simulated function DetachWeapon()
{
	Super.DetachWeapon();
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

	Instigator.GetActorEyesViewPoint( Start, Rot );
	End = Start + (vector(Instigator.Controller.Rotation) * 10000.0f);

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
				Spawn( GrabbyAreaClass,,, HitLoc+vect(0,0,8) );
			}
		}
	}
}




defaultproperties
{

}