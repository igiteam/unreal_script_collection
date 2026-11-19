/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_RicochetMoonHook extends NanoProj_ThrownWeapon
	config(Weapon);



var NanoPawn OwnerOfThisRicochetMoon;

var Actor Target;
var Vector StuckNormal;

/** How long the target should be knocked down for **/
var config float KnockDownTime;

var config float ImpactDamage;

/** This is the number of wall bounces this RicochetMoon can have before it breaks **/
var config byte NumWallBouncesBeforeBreaks;
var transient byte CurrNumWallBounces;

/** When hitting a pawn play this sound **/
var SoundCue ImpactAPawnSound;

var SoundCue ReturnedToOwnerSound;

var() bool bPullOwner;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// this makes RicochetMoon shoot out in the direction the pawn is facing and then fly towards its target
	SetTimer( 0.500f, FALSE, nameof(FindAndFlyToBestTarget) );

	SetTimer( 3.0f, FALSE, nameof(ReturnToOwner) );
}

simulated function Destroyed()
{
	local NanoPC NPC;
	local NanoPawn NP;

	Super.Destroyed();

	NPC = NanoPC(OwnerOfThisRicochetMoon.Controller);
	NPC.ThrownHook = None;
	NPC.RicochetMoonTargets.Length = 0;
	if( bPullOwner )
	{
		OwnerOfThisRicochetMoon.PulledTowardActor = None;
		OwnerOfThisRicochetMoon.bActivePullTowardActor = FALSE;
	}
	NP = NanoPawn(Base);
	if( NP != None )
	{
		NP.PulledTowardActor = None;
		NP.bActivePullTowardActor = FALSE;
	}
}

function Init( Vector Direction )
{
	Velocity = Speed * Direction;
	// Start it oriented the way its moving
	SetRotation(rotator(Velocity));
}

simulated function FindAndFlyToBestTarget()
{
	local NanoPC NPC;

	NPC = NanoPC(OwnerOfThisRicochetMoon.Controller);
	if( NPC.RicochetMoonTargets.Length > 0 )
	{
		Target = NPC.RicochetMoonTargets[0];
	}
	else
	{
		Target = None;
	}
}

simulated function Tick( float DeltaTime )
{
	local rotator NewRot, NewMeshRot;
	local float DistToTarget, InterpRate, SpinRate;
	local vector TargetLocation;
	local NanoPC PC;
	local NanoAI AI;
	local NanoPawn NP;
	local Actor PullTowardActor;

	// normal proj tick
	Super.Tick( DeltaTime );
	SpinRate = 65535.f;
	// update rotation/vel towards target
	if (Target != None)
	{	
		// use the interface if possible for any custom offsets
		if( NanoInterface_Targetable(Target) != none )
		{
			TargetLocation = NanoInterface_Targetable(Target).GetTargetedLocation();
		}
		else
		{
			TargetLocation = Target.Location;
		}
		// increase interp rate the closer we are to the target
		DistToTarget = VSize(TargetLocation - Location);
		if (DistToTarget > 256.f)
		{
			InterpRate = DistToTarget > 1500.f ? 2.f : 2.f + (1.f - DistToTarget/1500.f) * 8.f;
			NewRot = RInterpTo(Rotation,rotator(TargetLocation - Location),DeltaTime,InterpRate);
			SpinRate *= 2.f - DistToTarget/1500.f;
		}
		else
		{
			// once we're really close just zap on in to guarantee the hit
			NewRot = rotator(TargetLocation - Location);
			SpinRate *= 2.f;
		}
		SetRotation(NewRot);
		// update velocity since physProjectile doesn't bother with rotation
		Velocity = vector(NewRot) * Speed;
	}

	// spin the mesh
	NewMeshRot = MeshComp.Rotation;
	NewMeshRot.Yaw += SpinRate * DeltaTime;
	MeshComp.SetRotation(NewMeshRot);

/*	DrawDebugLine( OwnerOfThisRicochetMoon.Location, Location, 255, 0, 0, FALSE );
	if( Target != None )
	{
		DrawDebugLine( Target.Location, Location, 0, 255, 0, FALSE );
	}*/

	PC = NanoPC(Instigator.Controller);
	if( PC != None && Base != None )
	{
		if( bPullOwner )
		{
			NP = NanoPawn(Instigator);
			PullTowardActor = self;
		}
		else
		{
			NP = NanoPawn(Base);
			PullTowardActor = Instigator;
		}

		if( NP != None )
		{
			NP.PulledTowardActor = PullTowardActor;
			NP.bActivePullTowardActor = PC.IsButtonActive(GB_Y);
			if( NP.bActivePullTowardActor && NP.Physics != PHYS_Falling )
			{
				NP.Velocity = Normal(NP.PulledTowardActor.Location-NP.Location) * 1500;
				NP.SetPhysics( PHYS_Falling );
			}

			AI = NanoAI(NP.Controller);
			if( AI != None && NP.bActivePullTowardActor )
			{
				AI.StunAI(0.5f);
			}
		}
	}
}


/** We have not hit a target so return to owner **/
simulated function ReturnToOwner()
{
	local NanoPawn NP;

	ClearTimer( nameof(ReturnToOwner) );
	Target = OwnerOfThisRicochetMoon;
	SetPhysics(PHYS_Projectile);

	if( !IsZero(StuckNormal) )
	{
		Velocity = StuckNormal * Speed;
	}

	OwnerOfThisRicochetMoon.PulledTowardActor = None;
	OwnerOfThisRicochetMoon.bActivePullTowardActor = FALSE;
	NP = NanoPawn(Base);
	if( NP != None )
	{
		NP.PulledTowardActor = None;
		NP.bActivePullTowardActor = FALSE;
	}

	`log( `location@`showvar(Target)@`showvar(Physics)@`showvar(StuckNormal), bDebug );
}

/** When you hit a wall - try to return owner */
simulated singular event HitWall( vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
	// if we are already returning to our owner and we hit a wall go ahead and destroy ourselves
	if( Target == OwnerOfThisRicochetMoon )
	{
		DestroyedFromHittingAnImmovableObjectEffects();
		Destroy();
		return;
	}
	else
	{
		StickToTarget( Wall, HitNormal );
	}
}

/** When you touch something (like another player) see if we should impale them */
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local NanoPC NPC;
	
	if( Other == OwnerOfThisRicochetMoon ) 
	{
		if( Target == OwnerOfThisRicochetMoon )
		{
			// reclaimed!
			NPC = NanoPC(OwnerOfThisRicochetMoon.Controller);
			NPC.RicochetMoonTargets.length = 0;		
			// sound
			NPC.PlaySound(ReturnedToOwnerSound);
			
			LifeSpan=0.1f;

			// Put back in inventory - do not switch right away
			//CONTENTMOVEBROKE
			//OwnerOfThisRicochetMoon.InvManager.CreateInventory(class'NanoWeap_RicochetMoonHook', TRUE);
		}
	}
	else
	{
		StickToTarget( Other, HitNormal );
	}
}

simulated function StickToTarget( Actor HitTarget, Vector HitNormal )
{
	local NanoInterface_Targetable NTI;

	NTI = NanoInterface_Targetable(HitTarget);
	bPullOwner = (NTI != None) ? !NTI.NotifyStruckByHook( self ) : TRUE;

	`log( `location@`showvar(HitTarget)@`showvar(NTI)@`showvar(bPullOwner), bDebug );

	if( HitTarget != None )
	{
		ClearTimer( nameof(ReturnToOwner) );
		SetPhysics( PHYS_None );
		SetBase( HitTarget );
		StuckNormal = HitNormal ;
	}
	else
	{
		ReturnToOwner();
	}
}

defaultproperties
{
	Begin Object Name=WeaponMeshComp
		//CONTENTMOVEBROKE
		//SkeletalMesh=SkeletalMesh'REB_Ricochetmoon.SK_RicochetMoon_Proto'
		//PhysicsAsset=PhysicsAsset'REB_Ricochetmoon.SK_RicochetMoon_Proto_Physics'
	End Object


	LifeSpan=120.0f

	Speed=1700
	MaxSpeed=3000

	//CONTENTMOVEBROKE
	//ImpactAPawnSound=SoundCue'Weapon_Boomerang.Boomerang.Boomerang_ImpactFlesh_Cue'
	//ShatteringFromHittingAnImmovableObjectSound=SoundCue'Weapon_Boomerang.Boomerang.Boomerang_ImpactSurface_Cue'

	//InFlightSoundTemplate=SoundCue'Weapon_Boomerang.Boomerang.Boomerang_InAirLoop_Cue'
	//ReturnedToOwnerSound=SoundCue'Weapon_Boomerang.Boomerang.Boomerang_Catch_Cue'

	//TrailTemplate=ParticleSystem'Nano_WeaponFX.Moon.Effects.P_Nano_RicochetMoon_Trail'

	bDebug=TRUE
}
