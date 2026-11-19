/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_RoadieRunComet extends GSM_RoadieRun;

/** FX references */
var ParticleSystemComponent CometParticles;

/** whether we're currently in fiery death mode (velocity based) */
var bool bFlamesActive;

/** time after using before it can be used again */
var config float CooldownTime;

var float LastEndTime;

protected function bool InternalCanDoSpecialMove()
{
	return (PawnOwner.WorldInfo.TimeSeconds - LastEndTime >= CooldownTime && Super.InternalCanDoSpecialMove());
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	PawnOwner.AttachComponent(CometParticles);

	Super.SpecialMoveStarted(bForced, PrevMove);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.DetachComponent(CometParticles);

	Super.SpecialMoveEnded(PrevMove, NextMove);

	LastEndTime = PawnOwner.WorldInfo.TimeSeconds;
}

function NotifyBump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
	if (Other.Role == ROLE_Authority && bFlamesActive && Other.IsA('GearPawn'))
	{
		Other.TakeDamage(1000, PawnOwner.Controller, PawnOwner.Location, Normal(Other.Location - PawnOwner.Location), class'GDT_RoadieRunComet',, PawnOwner);
	}
}

function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	bFlamesActive = VSize(PawnOwner.Velocity) > PawnOwner.DefaultGroundSpeed;
	CometParticles.SetActive(bFlamesActive);
}

defaultproperties
{
	Begin Object Class=ParticleSystemComponent Name=ParticleComp0
		Template=ParticleSystem'Effects_Transfer.Effects.P_Liquid_Fire'
		Scale=9.0
		Translation=(X=71.0,Y=2.0,Z=27.0)
		Rotation=(Pitch=-2937,Yaw=-29571,Roll=-918)
		bAutoActivate=false
	End Object
	CometParticles=ParticleComp0
}
