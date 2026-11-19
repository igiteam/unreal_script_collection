
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearProj_BabyCorpserUndergroundBase extends GearProj_DiggerGrenadeBase
	native(Weapon)
	config(Weapon)
	abstract;

/** AnimNodeSlot used to play melee attack animation */
var transient AnimNodeSlot	SlotNode;

/** Animation played when bursting out of the ground. */
enum ECorpserBurstAnim
{
	ECBA_None,
	ECBA_SingleClaw,
	ECBA_ThreeClaw
};
var transient repnotify ECorpserBurstAnim   BurstAnim;

/** DestructibleObject Target */
var transient GearDestructibleObject TargetDestructible;
var transient GearFortification TargetFortification;
var transient GearPawn_LocustCorpserLarvaUndergroundBase CorpserPawn;

/** Sounds */
var const SoundCue BurrowStartSound, BurrowStartSound2, BurrowAmbientSound, BurrowStopSound;

var() protected ParticleSystemComponent PSC_GroundTrail;

/** Keep track of last good NavMesh Normal */
var transient vector LastGoodNavMeshNormal;

cpptext
{
protected:
	virtual UBOOL InternalDoTraces();
}

replication
{
	if( bNetDirty )
		BurstAnim;
}

simulated function ReplicatedEvent(name VarName)
{
	if( VarName == nameof(BurstAnim) )
	{
		PlayBurstAnim();
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
}

simulated protected function StartBurrowingFX()
{
	Super.StartBurrowingFX();

	// Start sound
	if( BurrowStartSound != None )
	{
		PlaySound(BurrowStartSound, TRUE);
	}
	if( BurrowStartSound2 != None )
	{
		PlaySound(BurrowStartSound2, TRUE);
	}

	// Looping ambient sound.
	StopInFlightAudio();
	if( BurrowAmbientSound != None )
	{
		InFlightSoundTemplate = BurrowAmbientSound;
		StartInFlightAudio();
	}

	if( Mesh != None )
	{
		Mesh.SetHidden(TRUE);
	}

	if( TrailEmitter != None && TrailEmitter.ParticleSystemComponent != None )
	{
		TrailEmitter.ParticleSystemComponent.SetActive(TRUE);
	}

	SetTimer(0.1, true, nameof(DoBurrowForceFeedback));
}

/** This is called when we failed to find a spot for the Corpser to emerge */
simulated protected function ExitGroundAndExplode()
{
	// See if we exit ground because time ran out
	if( CorpserPawn != None && ElapsedBurrowTime == BurrowTime )
	{
		CorpserPawn.bUndergroundChargeTimedOut = TRUE;
	}

	Super.ExitGroundAndExplode();

	// turn off ground trail
	if( TrailEmitter != None && TrailEmitter.ParticleSystemComponent != None )
	{
		TrailEmitter.ParticleSystemComponent.SetActive(FALSE);
	}

	if( BurrowStopSound != None )
	{
		PlaySound(BurrowStopSound, true);
	}

	StopInFlightAudio();

	ClearTimer(nameof(DoBurrowForceFeedback));
}


simulated function Init(vector Direction)
{
	Super.Init(Direction);

	CorpserPawn = GearPawn_LocustCorpserLarvaUndergroundBase(Instigator);
	if( CorpserPawn != None )
	{
		// Initialize these to FALSE, they will be set to TRUE where appropriate.
		CorpserPawn.bUndergroundChargeReachedTarget = FALSE;
		CorpserPawn.bUndergroundChargeTimedOut = FALSE;
	}
}

simulated function InitForDestructible(vector Direction, GearDestructibleObject Destructible)
{
	TargetDestructible = Destructible;
	Init(Direction);
}

simulated function InitForFortification(vector Direction, GearFortification Fortification)
{
	TargetFortification = Fortification;
	Init(Direction);
}


/** Set Burst animation to play when coming out of the ground. */
function SetBurstAnim(ECorpserBurstAnim NewBurstAnim)
{
	BurstAnim = NewBurstAnim;
	bForceNetUpdate = TRUE;
}

simulated function PlayBurstAnim()
{
	local SkeletalMeshComponent	SkelMeshComp;
	local FLOAT AnimTime;
	local GearAI AI;

	SkelMeshComp = SkeletalMeshComponent(Mesh);

	// Cache slot node if needed
	if( SlotNode == None )
	{
		SlotNode = AnimNodeSlot(SkelMeshComp.FindAnimNode('Custom_FullBody'));
	}

	switch( BurstAnim )
	{
		case ECBA_ThreeClaw : AnimTime = SlotNode.PlayCustomAnim('three_claw_attack', 1.f); break;
		case ECBA_SingleClaw : AnimTime = SlotNode.PlayCustomAnim('single_claw_attack', 1.f); break;
	}

	if( AnimTime > 0.f )
	{
		SetTimer(AnimTime, FALSE, 'BurstAnimEnded');
	}
	else
	{
		`warn(class @ GetFuncName() @ "AnimTime == 0!!!");
		BurstAnimEnded();
	}

	foreach WorldInfo.AllControllers( class'GearAI', AI )
	{
		AI.ReactionManager.NudgeChannel( self, 'WarnProjExplode' );
	}
}

simulated function BurstAnimEnded()
{
	// Kill projectile now, we're done.
	Destroy();
}

/*
 * Called when traces hit an obstacle.
 * Return FALSE to abort movement
 */
simulated event bool ValidateHitObstacle(Actor Obstacle)
{
	// If hit our target, trigger destruction right away.
	if( Obstacle == TargetDestructible )
	{
		DestroyDestructible();
		return FALSE;
	}
	else if( Obstacle == TargetFortification )
	{
		DestroyFortification();
		return FALSE;
	}

	return TRUE;
}

simulated function DestroyDestructible()
{
	local Vector NudgeLocation;

	// Deal full damage to completely destroy it.
	TargetDestructible.TakeRadiusDamage(Instigator.Controller, 100000, 500, class'GearDamageType', 1000, TargetDestructible.Location, TRUE, Self);

	// Nudge projectile to center of destructible. Since they're so close, assume it's same height.
	NudgeLocation.X = TargetDestructible.Location.X;
	NudgeLocation.Y = TargetDestructible.Location.Y;
	NudgeLocation.Z = Location.Z;
	SetLocation(NudgeLocation);

	// We are successful!
	if( CorpserPawn != None )
	{
		CorpserPawn.bUndergroundChargeReachedTarget = TRUE;
	}

	// Use three claw animation to burst through and destroy destructible.
	SetBurstAnim(ECBA_ThreeClaw);

	// just blow up.  nothing more to do here
	ExitGroundAndExplode();
}

simulated function DestroyFortification()
{
	local Vector NudgeLocation;

	// Deal full damage to completely destroy it.
	TargetFortification.TakeRadiusDamage(Instigator.Controller, 100000, 500, class'GearDamageType', 1000, TargetFortification.Location, TRUE, Self);

	// Nudge projectile to center of destructible. Since they're so close, assume it's same height.
	NudgeLocation.X = TargetFortification.Location.X;
	NudgeLocation.Y = TargetFortification.Location.Y;
	NudgeLocation.Z = Location.Z;
	SetLocation(NudgeLocation);

	// We are successful!
	if( CorpserPawn != None )
	{
		CorpserPawn.bUndergroundChargeReachedTarget = TRUE;
	}

	// Use three claw animation to burst through and destroy destructible.
	SetBurstAnim(ECBA_ThreeClaw);

	// just blow up.  nothing more to do here
	ExitGroundAndExplode();
}

/** Things we want to do only for the digger grenade, but not for the Mini Corpser */
simulated function DiggerGrenadeSpecialTick();

protected function bool ValidatePawnForSteering(Pawn TestPawn)
{
	return ( Super.ValidatePawnForSteering(TestPawn) &&
		class'GearPawn_LocustCorpserLarvaUndergroundBase'.static.IsLocationBabyCorpserSafe(WorldInfo, TestPawn.Location) );
}

/** Internal. Homes grenade on our targets. Server only. */
protected function DoSteering(float DeltaTime)
{
	local float ColRadius, ColHeight;

	// Track Destructible Object
	if( CorpserPawn != None && CorpserPawn.IsValidDestructibleTarget(TargetDestructible) )
	{
		TargetDestructible.GetBoundingCylinder(ColRadius, ColHeight);

		// If we're close enough, come out and destroy it
		if( VSizeSq(TargetDestructible.Location - Location) < (ColRadius * ColRadius + EnemyAutoEmergeRadius) )
		{
			DestroyDestructible();
			return;
		}

		SteerTowardsTarget(TargetDestructible.Location, DeltaTime);
	}
	// Track Fortification Object
	else if( CorpserPawn != None && CorpserPawn.IsValidFortificationTarget(TargetFortification) )
	{
		TargetFortification.GetBoundingCylinder(ColRadius, ColHeight);

		// If we're close enough, come out and destroy it
		if( VSizeSq(TargetFortification.Location - Location) < (ColRadius * ColRadius + EnemyAutoEmergeRadius) )
		{
			DestroyFortification();
			return;
		}

		SteerTowardsTarget(TargetFortification.Location, DeltaTime);
	}
	else
	{
		Super.DoSteering(DeltaTime);
	}
}

/**
 * Called by the steering code to do checks against nearby Pawns.
 */
simulated protected function CloseEnoughToPawn()
{
	// We are successful!
	if( CorpserPawn != None )
	{
		CorpserPawn.bUndergroundChargeReachedTarget = TRUE;
	}

	// That needs to happen after bUndergroundChargeReachedTarget has been set.
	Super.CloseEnoughToPawn();
}

simulated protected function SpawnTrail()
{
	Super.SpawnTrail();

	// Don't kill for as long as corpser is digging.
	TrailEmitter.LifeSpan = 0.f;
}

/** Script hook to teleport corpser along the trail */
event TeleportCorpser(vector EmergeLocation, rotator EmergeRotation)
{
	GearAI(Instigator.Controller).TeleportToLocation(EmergeLocation, EmergeRotation);
}

defaultproperties
{
	bAutoDestroyOnExplosion=false
	bAIReactWithoutLOS=true
	EnemyAttractRadius=3000
	TurnScaleRange=(X=1200.f,Y=2000.f)
	BurrowDistRangeUntargeted=(X=4000.f,Y=3000.f)
	MaxBurrowUnderDist=300
}
