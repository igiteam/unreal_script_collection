/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_ThrownRicochetMoon extends NanoProj_ThrownWeapon
	config(Weapon);



var NanoPawn OwnerOfThisRicochetMoon;

var Actor Target;

/** How long the target should be knocked down for **/
var config float KnockDownTime;

var config float ImpactDamage;

/** This is the number of wall bounces this RicochetMoon can have before it breaks **/
var config byte NumWallBouncesBeforeBreaks;
var transient byte CurrNumWallBounces;

/** When hitting a pawn play this sound **/
var protected SoundCue ImpactAPawnSound;

var protected SoundCue ReturnedToOwnerSound;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// this makes RicochetMoon shoot out in the direction the pawn is facing and then fly towards its target
	SetTimer( 0.500f, FALSE, nameof(FindAndFlyToBestTarget) );

	SetTimer( 3.0f, FALSE, nameof(ReturnToOwnerIfNoHit) );
}

function Init( Vector Direction )
{
	Velocity = Speed * Direction;
	// Start it oriented the way its moving
	SetRotation(rotator(Velocity));
}

function ResetPCViewTarget(optional NanoPC PC)
{
	if (PC == None && OwnerOfThisRicochetMoon != None)
	{
		PC = NanoPC(OwnerOfThisRicochetMoon.Controller);
	}
	if (PC != None && PC.FollowedThrownWeapon == self)
	{
		PC.FollowedThrownWeapon = None;
		PC.SetViewTargetWithBlend(PC.Pawn,0.1f);
	}
}

/** When you touch something (like another player) see if we should impale them */
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local NanoPawn_MetaCorpBase NP;
	local NanoPC NPC;
	//local SpawnedNanoEmitter Emitter;
	local NanoPawn_RebelsBase Rebel;

	Rebel = NanoPawn_RebelsBase(Other);
	if( Rebel != None ) 
	{
		// reclaimed!
		NPC = NanoPC(OwnerOfThisRicochetMoon.Controller);
		NPC.RicochetMoonTargets.length = 0;		
		// sound
		NPC.PlaySound(ReturnedToOwnerSound);
		
		ResetPCViewTarget(NPC);

		LifeSpan=0.1f;

		// Put back in inventory - do not switch right away
		Rebel.InvManager.CreateInventory(class'NanoWeap_RicochetMoon', TRUE);
	}
	else
	{
		NP = NanoPawn_MetaCorpBase(Other);

		// we want to check all the special cases before we check pawn as some things are NanoPawns and somethings will probably be turned into NPs
		// TODO: probably make a RicochetMoonImpactable Interface
		if( TeslaCoil(Other) != None )
		{
			TeslaCoil(Other).RicochetMoonImpact();
		}
		else if( NanoPawn_MetaCorp_SentryBotBase(Other) != None )
		{
			Other.TakeDamage(100000, Instigator.Controller, HitLocation, Velocity, class'NanoGame.NDT_RicochetMoonThrown',,self);
		}
		else if( (NP != None) && (NP.Health > 0) )
		{
			PlaySound( ImpactAPawnSound, TRUE, TRUE, FALSE, HitLocation );
			//CONTENTMOVEBROKE 
			//Emitter = Spawn(class'SpawnedNanoEmitter',,,HitLocation);
			//Emitter.SetTemplate(ParticleSystem'Nano_WeaponFX.Moon.Effects.P_FX_Moon_ImpactEffect',TRUE);
			NP.TakeDamage(ImpactDamage, Instigator.Controller, HitLocation, Velocity, class'NanoGame.NDT_RicochetMoonThrown',,self);
			NP.DropShield();
			NP.Knockdown( KnockDownTime );
		}
	
		// so now that we have hit something we need to find our next target
		RemoveTargetAndContinue(Other);
   }
}

function RemoveTargetAndContinue(Actor TargetToRemove)
{
	local int TargetIndex;
	local NanoPC NPC;
	SetTimer( 3.0f, FALSE, nameof(ReturnToOwnerIfNoHit) );
	NPC = NanoPC(OwnerOfThisRicochetMoon.Controller);
	TargetIndex = NPC.RicochetMoonTargets.Find( TargetToRemove );
	if( TargetIndex != INDEX_NONE )
	{
		NPC.RicochetMoonTargets.Remove( TargetIndex, 1 );
	}
	// if this was our current target
	if (TargetToRemove == Target)
	{
		// pick a new target
		FindAndFlyToBestTarget();
	}
}


/** This will find the best target in the list and then head for it! **/
simulated function FindAndFlyToBestTarget()
{
	local float Rating, BestRating;
	local int Idx, BestIdx;
	local NanoPC NPC;
	local Actor TempTarget;

	local float DistToTarget;

	NPC = NanoPC(OwnerOfThisRicochetMoon.Controller);

	BestIdx = INDEX_NONE;
	BestRating = 9999999.f;
	if( NPC.RicochetMoonTargets.Length > 0 )
	{
		for (Idx = 0; Idx < NPC.RicochetMoonTargets.Length; Idx++)
		{
			TempTarget = NPC.RicochetMoonTargets[Idx];

			DistToTarget = VSize(TempTarget.Location - Location);

			if( NanoInterface_Targetable(TempTarget) != none )
			{
				// higher priority targets have a higher value so dividing makes the dist seem smaller (which is rated higher)
				DistToTarget /= NanoInterface_Targetable(TempTarget).GetBasePriority( NPC );
			}

			Rating = DistToTarget * (1.f - (Normal(TempTarget.Location - Location) dot Normal(Velocity)));
			

			//`log( "RicochetMoon" @ `showvar(TempTarget) @ `showvar(Rating) @ `showvar(BestRating) );
			//`log("RicochetMoon"@`showvar(Rating)@`showvar(Idx)@"Dist:"@VSize(TempTarget.Location - Location)@"Dot:"@(Normal(TempTarget.Location - Location) dot Normal(Velocity)));
			if (BestIdx == INDEX_NONE || Rating < BestRating)
			{
				BestIdx = Idx;
				BestRating = Rating;
				Target = TempTarget;
			}
		}

	}
	else
	{
		Target = OwnerOfThisRicochetMoon;
	}

	//`log( " WINNER: " @ Target );
}


simulated function Destroyed()
{
	local NanoPC NPC;

	Super.Destroyed();

	NPC = NanoPC(OwnerOfThisRicochetMoon.Controller);
	NPC.ThrownMoon = None;
	NPC.RicochetMoonTargets.length = 0;
}


simulated function Tick( float DeltaTime )
{
	local rotator NewRot, NewMeshRot;
	local float DistToTarget, InterpRate, SpinRate;
	local vector TargetLocation;

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
			if (DistToTarget < 64.f)
			{
				RemoveTargetAndContinue(Target);
			}
		}
		SetRotation(NewRot);
		// update velocity since physProjectile doesn't bother with rotation
		Velocity = vector(NewRot) * Speed;

		if (Target == OwnerOfThisRicochetMoon && DistToTarget < 256.f)
		{
			ResetPCViewTarget();
		}
	}

	// spin the mesh
	NewMeshRot = MeshComp.Rotation;
	NewMeshRot.Yaw += SpinRate * DeltaTime;
	MeshComp.SetRotation(NewMeshRot);
}


/** We have not hit a target so return to owner **/
simulated function ReturnToOwnerIfNoHit()
{
	ClearTimer( nameof(ReturnToOwnerIfNoHit) );
	Target = OwnerOfThisRicochetMoon;
}



/** When you hit a wall - try to return owner */
simulated singular event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local NanoPC NPC;

	NPC = NanoPC(OwnerOfThisRicochetMoon.Controller);

	// if we are already returning to our owner and we hit a wall go ahead and destroy ourselves
	if( Target == OwnerOfThisRicochetMoon )
	{
		DestroyedFromHittingAnImmovableObjectEffects();
		Destroy();
		return;
	}
	// else we bounced off a wall and we should look for next best target
	else if( NPC.RicochetMoonTargets.length > 0 )
	{
		FindAndFlyToBestTarget();
	}
	else
	{
		ReturnToOwnerIfNoHit();
	}

	// here we increment the number of wall bounces and check to see if we should destroy selves
	CurrNumWallBounces++;

	if ( CurrNumWallBounces > NumWallBouncesBeforeBreaks )
	{
		DestroyedFromHittingAnImmovableObjectEffects();
		Destroy();
		return;
	}
}


simulated event GetActorEyesViewPoint( out vector out_Location, out Rotator out_Rotation )
{
	out_Location = Location + (FollowCameraOffset >> Rotation);
	out_Rotation = Rotation;
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
}
