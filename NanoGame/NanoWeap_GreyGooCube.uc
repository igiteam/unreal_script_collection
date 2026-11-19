/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_GreyGooCube extends NanoWeap_GreyGooCubeBase;


var protected FracturedStaticMesh FSMToCreate;
var transient protected NanoBustableActor_Dynamic CurrSpawnedGreyGoo;

var transient protected vector SpawnHitLocation;


/** This is the time the weapon was first fired.  We use this for determing if we should**/
var transient float TimeFirstFired;



//
// Network replication
//

replication
{
	if( Role==ROLE_Authority )
		CurrSpawnedGreyGoo;
}


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

	local Rotator SpawnRot;

	local NanoInterface_GreyGooAffect GreyGooableActor;


	Instigator.GetActorEyesViewPoint( Start, Rot );
	End = Start + (vector(Instigator.Controller.Rotation) * 10000.0f);

	HitActor = Trace( HitLoc, HitNorm, End, Start, TRUE );

	if( FiringMode == 0 )
	{
		//`log( "FIRE FIRE FIRE" @ Instigator @ HitLoc );

		// we don't want to be able to make grey goo floating in space so make certain we have a HitActor
		if( HitActor != none )
		{
			if( PayNanoPowerCost() == FALSE )
			{
				return;
			}

			// First, see if the thing we hit implements the grey goo interface
			GreyGooableActor = NanoInterface_GreyGooAffect(HitActor);
			if(GreyGooableActor != None)
			{
				// If it does, let it do its thing, and go on no further
				GreyGooableActor.OnGreyGoo(self);
				return;
			}			

			TimeFirstFired = WorldInfo.TimeSeconds;

			SpawnHitLocation = HitLoc;
			// so to figure out rotation we want to do:
			// X = direction of start.X - end.X
			// Y = cross product of X and 0,1,0
			// Z = cross product of Y and 0,0,1
			// this will give us a nice "flatly" oriented shape on the ground

			//SpawnRot = Instigator.Controller.Rotation-Rot(0,16384,0);

			SpawnRot = GetGooRotation( (Instigator.Location - HitLoc) );

			//`log( HitLoc @ SpawnRot );

			// only spawn this on the server and have it replicated out to the clients
			if( Role == ROLE_Authority )
			{
				
				CurrSpawnedGreyGoo = Spawn( class'NanoBustableActor_Dynamic',,, HitLoc, SpawnRot );

				if( CurrSpawnedGreyGoo != none )
				{
					CurrSpawnedGreyGoo.SetCollision( FALSE, FALSE, TRUE );
					CurrSpawnedGreyGoo.FracturedStaticMeshComponent.SetStaticMesh( FSMToCreate );
					//CurrSpawnedGreyGoo.FracturedStaticMeshComponent.SetRotation( Rot(0,16384,0) );
					CurrSpawnedGreyGoo.SetRotation( SpawnRot );
					CurrSpawnedGreyGoo.FracturedStaticMeshComponent.SetScale3D(vect(1.0f,1.0f,1.0f));
				}
			}
		}
	}
}


/**
* Called when weapon stops firing.
* @NOTE:	this is not a state scoped function (remote clients ignore the state the weapon is in)
* Network: ALL
*
* @param	FireModeNum.
*/
simulated event WeaponStoppedFiring(byte FiringMode)
{
	// just dirty hack for now
	local vector Start, End, HitLoc, HitNorm;
	local rotator Rot;
	local Actor				HitActor;
	//local TraceHitInfo		HitInfo;

	local rotator SavedRotation;
	local vector SavedLocation;


	Instigator.GetActorEyesViewPoint( Start, Rot );
	End = Start + (vector(Instigator.Controller.Rotation) * 10000.0f);

	HitActor = Trace( HitLoc, HitNorm, End, Start, TRUE );


	Super.WeaponStoppedFiring( FiringMode );


	if( HitActor == none )
	{
		HitLoc = End;
	}

	if( ( FiringMode == 0 ) && ( ShouldScale() == TRUE ) )
	{
		//`log( "RELEASE RELEASE RELEASE WeaponStoppedFiring" @ HitLoc @ TimeFirstFired @ CurrSpawnedGreyGoo @ WorldInfo.TimeSeconds @ TimeFirstFired @ ( WorldInfo.TimeSeconds - TimeFirstFired ) );

		DoScaling();

		if( CurrSpawnedGreyGoo != none )
		{
			SavedRotation = GetGooRotation( ( CurrSpawnedGreyGoo.Location - HitLoc ) );
			SavedLocation = CurrSpawnedGreyGoo.Location;
			SavedLocation = SavedLocation + (VSize2D(SavedLocation - HitLoc)/100.0f * (HitLoc - SavedLocation ));

			// CurrSpawnedGreyGoo.FracturedStaticMeshComponent.SetStaticMesh( FSMToCreate );
			CurrSpawnedGreyGoo.SetRotation( SavedRotation );
			CurrSpawnedGreyGoo.FracturedStaticMeshComponent.SetScale3D( GetGooScale3D( VSize2D(SavedLocation - HitLoc) ) );
		}
	}

	if( FiringMode == 0 ) 
	{
		//`log( "RESET CurrSpawnedGreyGoo = none" @ HitLoc @ TimeFirstFired @ CurrSpawnedGreyGoo );

		if( CurrSpawnedGreyGoo != none )
		{
			CurrSpawnedGreyGoo.SetCollision( TRUE, TRUE, FALSE );
			// reset the curr spawned goo as we only deal with it during a single fire
			CurrSpawnedGreyGoo = none;
		}
	}
}


/** 
 * This will do the correct scaling of the spawned piece.
 *
 * NOTE: this is just proto as we want to do marching cubes or something similar to that.  Also with scaling the fracture pieces do not break correctly
 **/
simulated function DoScaling()
{
	// just dirty hack for now
	local vector Start, End, HitLoc, HitNorm;
	local rotator Rot;
	local Actor				HitActor;
	//local TraceHitInfo		HitInfo;

	local vector SavedLocation;


	Instigator.GetActorEyesViewPoint( Start, Rot );
	End = Start + (vector(Instigator.Controller.Rotation) * 10000.0f);

	HitActor = Trace( HitLoc, HitNorm, End, Start, TRUE );
	
	if( HitActor == none )
	{
		HitLoc = End;
	}

	if( CurrSpawnedGreyGoo != none )
	{
		// this will orient the "goo" from where you spawned to where you are pointing
		CurrSpawnedGreyGoo.SetRotation( GetGooRotation((CurrSpawnedGreyGoo.Location - HitLoc ))) ;

		//DrawDebugLine( CurrSpawnedGreyGoo.Location, HitLoc, 255, 0, 0, FALSE );


		SavedLocation = CurrSpawnedGreyGoo.Location;
		// hack
		SavedLocation = SavedLocation + (VSize2D(SavedLocation - HitLoc)/100.0f * (HitLoc - SavedLocation ));

//		DrawDebugSphere( SavedLocation, 10, 10, 255, 0, 0 );
//		CurrSpawnedGreyGoo.SetDrawScale3D( (vect(1,0,0) * ScaleX) + (vect(0,1,0) * ScaleY) + (vect(0,0,1) * ScaleZ));
		CurrSpawnedGreyGoo.FracturedStaticMeshComponent.SetScale3D( GetGooScale3D( VSize2D(SavedLocation - HitLoc) ) );
		

		DrawDebugCoordinateSystem( HitLoc, CurrSpawnedGreyGoo.Rotation, 50.0f, FALSE );

		//`log( X @ Y @ Z @ ScaleX @ ScaleY @ ScaleZ );
	}	
}


/** This will correctly orient the "goo" mesh along the ground and facing the direction the player is looking **/
protected simulated function rotator GetGooRotation( const vector RotationToSpawn )
{
	//local vector RotationToSpawn;
	local vector GooX, GooY, GooZ, SurfaceFwd, SurfaceRight, SurfaceUp;
	local rotator Retval;

	if( ShouldScale() == FALSE )
	{
		GetAxes( Rotator(RotationToSpawn), GooX, GooY, GooZ );
		SurfaceUp = vect(0,0,-1); // to flip the rotation :-/
		SurfaceRight = SurfaceUp cross GooX;
		SurfaceFwd = SurfaceUp cross SurfaceRight;
		Retval = OrthoRotation(SurfaceFwd, SurfaceRight, SurfaceUp);
	}
	else
	{
		Retval = Rotator(RotationToSpawn);
	}

	return Retval;
}


/** Proto: this will do the scaling to match where we are scaling from to end point. **/
protected simulated function vector GetGooScale3D( const float DistanceToPoint )
{
	local vector Retval;
	local float ScaleX,ScaleY,ScaleZ;

	if( CurrSpawnedGreyGoo != none )
	{
		ScaleX = 1.0f;
		// this needs to be capped at some number around say 20-30. otherwise you can make just long spikes
		ScaleY = Max( Min(35.0f,DistanceToPoint/10.0f), 1.0f );
		ScaleZ = 0.5f;
		//`log( "Scale3D:" @ ScaleX @ ScaleY @ ScaleZ );

		Retval = (vect(1,0,0) * ScaleX) + (vect(0,1,0) * ScaleY) + (vect(0,0,1) * ScaleZ);
	}

	return Retval;
}


simulated event Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( ( CurrSpawnedGreyGoo != none )
		&& ( ShouldScale() == TRUE )
		)
	{
		`log( WorldInfo.TimeSeconds @ TimeFirstFired @ ( WorldInfo.TimeSeconds - TimeFirstFired ) );
		DoScaling();
	}
}


/** If we should scale or not.  Based on if we are holding down the trigger for longer than 1 second **/
simulated function bool ShouldScale()
{
	return ( ( WorldInfo.TimeSeconds - TimeFirstFired ) > 1.1f );
}



defaultproperties
{
	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Locust_PoisonGrenade.Locust_Poison_Grenade'
		PhysicsAsset=PhysicsAsset'Locust_PoisonGrenade.Poison_Grenade_Physics'
		AnimTreeTemplate=AnimTree'COG_Bolo_Grenade.Animations.AT_BoloGrenade'
		AnimSets(0)=AnimSet'COG_Bolo_Grenade.GrenadeAnims'
		Rotation=(Pitch=0,Yaw=0,Roll=-16384)
		Scale=0.3f
	End Object
	Mesh=WeaponMeshComp

	bAllowTracers=FALSE
	FSMToCreate=FracturedStaticMesh'Nano_ProtoFrac_A.SM.S_GOW_Buildings_SM_TypeB_Wall_256_Brick_FRACTURED'
}