/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCrowdAgent_ChickenBase extends GearCrowdAgent
	native;

/** Cap the damage per attack done to these guys, so the freakout attack isn't triggered too easily */
var() int MaxDamagePerAttack;
/** Amount of remaining health where the chicken will begin a chicken attack */
var() int FreakoutHealthThreshold;
/** Max freakout speed */
var() float FreakoutSpeed;
/** Set to true if this chicken has freaked out */
var transient bool bFreakedOut;
/** Behaviors to choose from when agent panicks. */
var() array<BehaviorEntry>  FreakoutBehaviors;

/** Sound to play when attack begins */
var() SoundCue AttackVocal;
/** Sound to play when taking damage from chicken */
var() SoundCue BiteSound;
/** Alternate sound to play when taking damage from chicken */
var() SoundCue AltBiteSound;

cpptext
{
	virtual FVector CalcPathForce();
}

function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	DamageAmount = Clamp(DamageAmount, 0, MaxDamagePerAttack);

	// Don't take damage from lambent explosions, or we'll freakout almost immediately
	if( ClassIsChildOf(DamageType, class'GDT_LambentExplosion') )
	{
		DamageAmount = 0;
	}

	Super(GameCrowdAgentSkeletal).TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	if( !bFreakedOut && EventInstigator.Pawn != None && 
		FreakoutHealthThreshold > 0 && Health < FreakoutHealthThreshold )
	{
		SetFreakout(EventInstigator.Pawn);
	}
}

/** Set maximum movement speed */
function SetMaxSpeed()
{
	if( bFreakedOut )
	{
		MaxSpeed = FreakoutSpeed;
	}
	else
	{
		Super.SetMaxSpeed();
	}
}

function SetPanic(actor PanicActor, bool bNewPanic)
{
	if( !bFreakedOut )
	{
		Super.SetPanic(PanicActor, bNewPanic);
	}
}

function SetFreakout(Pawn FreakoutInstigator)
{
	if ( !bFreakedOut )
	{
		bFreakedOut = true;
		PickBehaviorFrom(FreakoutBehaviors);
	}
	if( CurrentBehavior != none )
	{
		CurrentBehavior.ActivatedBy(FreakoutInstigator);
	}
}

defaultproperties
{
	Health=10000
	MaxDamagePerAttack=500
	FreakoutHealthThreshold=7000

	CrowdTeam=TEAM_COG

	bPreferVisibleDestination=true
	bCountForSeriouslyAchievement=false

	MaxWalkingSpeed=50.0
	MaxRunningSpeed=250.0
	FreakoutSpeed=500.0

	RotateToTargetSpeed=20000.0
	MaxYawRate=20000.0

	MeshMinScale3D=(X=1.3,Y=1.3,Z=1.3)
	MeshMaxScale3D=(X=1.7,Y=1.7,Z=1.7)
	bUniformScale=TRUE
}



