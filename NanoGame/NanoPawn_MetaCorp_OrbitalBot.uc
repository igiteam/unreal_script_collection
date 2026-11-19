/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_OrbitalBot extends NanoPawn_MetaCorp_OrbitalBotBase;



function Init()
{
	local Weapon Wpn;

	Super.Init();

	Wpn = Weapon(InvManager.CreateInventory(class'NanoWeap_Orbital_Laser'));
	InvManager.SetCurrentWeapon( Wpn );
}


event TakeDamage( int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	Damage = 0; // for now no damage to the mek
	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );
}

function FirePrimaryLaser( Vector StartLoc, Vector EndLoc, float FireDuration )
{
	if( !bPrimaryLaserFiring )
	{
		bPrimaryLaserFiring			  = TRUE;
		PrimaryLaserStartOffset		  = ((StartLoc-Location) << Rotation);
		PrimaryLaserEndOffset		  = ((EndLoc-Location)   << Rotation);
		PrimaryLaserFireTime		  = Max( FireDuration, 0.1f );
		PrimaryLaserFireTimeRemaining = PrimaryLaserFireTime;

		`log( `location@`showvar(PrimaryLaserStartOffset)@`showvar(PrimaryLaserEndOffset)@`showvar(PrimaryLaserFireTime) );
	}
	else
	{
		`log( "ERROR:"@self@"Fired primary laser when it was already active" );
		ScriptTrace();
	}
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	// Update primary laser timer
	if( bPrimaryLaserFiring )
	{
		PrimaryLaserFireTimeRemaining -= DeltaTime;
		if( PrimaryLaserFireTimeRemaining <= 0.f )
		{
			bPrimaryLaserFiring = FALSE;
		}
	}
}

simulated function bool GetCurrentPrimaryLaserImpactLocation( out Vector out_ImpactLoc, out Vector out_ImpactNorm )
{
	local float Alpha;
	local Actor HitActor;
	local Vector HitLocation, HitNormal, StartTrace, EndTrace;

	if( bPrimaryLaserFiring )
	{
		Alpha = 1.f - (PrimaryLaserFireTimeRemaining/PrimaryLaserFireTime);
		StartTrace = GetPrimaryLaserStartLocation();
		EndTrace = StartTrace + Normal( VLerp( Location + (PrimaryLaserStartOffset>>Rotation), Location + (PrimaryLaserEndOffset>>Rotation), Alpha ) - StartTrace ) * 2048.f;
		HitActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace, FALSE, vect(0,0,0) );
		if( HitActor != None )
		{
			out_ImpactLoc  = HitLocation;
			out_ImpactNorm = HitNormal;
		}
		else
		{
			out_ImpactLoc  = EndTrace;
			out_ImpactNorm = vect(0,0,1);
		}
		return TRUE;
	}
	return FALSE;
}

simulated function Vector GetPrimaryLaserStartLocation()
{
	return Mesh.GetBoneLocation(PrimaryLaserBoneName);
}

function bool Died( Controller Killer, class<DamageType> DamageType, vector HitLocation )
{
	bPrimaryLaserFiring = FALSE;
	return Super.Died( Killer, DamageType, HitLocation );
}

defaultproperties
{
	ControllerClass=class'NanoAI_OrbitalBot'

	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'MET_OrbitalMech.SK_MET_OrbitalMech'
		PhysicsAsset=PhysicsAsset'MET_OrbitalMech.SK_MET_OrbitalMech_Physics'
		AnimTreeTemplate=AnimTree'MET_OrbitalMech.AT_OrbitalMech'
		AnimSets.Empty()
//		AnimSets.Add(AnimSet'MET_PacifierMechProto.AS_MET_PacifierMechProto')
		Translation=(Z=-88.0)
		Scale3D=(X=1.0f,Y=1.0f,Z=1.0f)
		RBCollideWithChannels=(Default=TRUE,Pawn=TRUE,DeadPawn=TRUE,BlockingVolume=TRUE,EffectPhysics=TRUE,GameplayPhysics=TRUE,FracturedMeshPart=TRUE,SoftBody=TRUE)
		bNotifyRigidBodyCollision=TRUE
		bTickAnimNodesWhenNotRendered=FALSE
	End Object

	Begin Object Name=CollisionCylinder
		CollisionRadius=128.f
		CollisionHeight=78.f
	End Object

	PrimaryLaserBoneName=b_Head
}