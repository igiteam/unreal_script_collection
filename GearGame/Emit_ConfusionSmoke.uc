/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_ConfusionSmoke extends Emit_SmokeGrenade
	config(Weapon)
	notplaceable;

/** Radius within which to apply the confusion affect */
var() config float ConfuseRadius;
/** Amount of time AI should stay confused */
var() config float ConfuseDuration;
/** Avoidance cylinder */
var protected transient AIAvoidanceCylinder AvoidanceCylinder;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetConfuseRadius(ConfuseRadius);
}

function SetConfuseRadius(float Radius)
{
	local CylinderComponent C;

	ConfuseRadius = Radius;

	// Setup collision and avoidance cylinder
	C = CylinderComponent(CollisionComponent);
	C.SetCylinderSize(ConfuseRadius, ConfuseRadius*2.0f);
	SetupAvoidanceCylinder();
}

simulated protected function TurnOffSmokeEmitter()
{
	Super.TurnOffSmokeEmitter();
	if (AvoidanceCylinder != None)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = None;
	}
}

simulated function Destroyed()
{
	Super.Destroyed();

	if(AvoidanceCylinder != None)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = None;
	}
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local GearPawn P;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	if ( !WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.GRI.IsCoopMultiplayerGame() )
	{
		P = GearPawn(Other);
		if (P != None && P.GetTeamNum() != 0)
		{
			P.GoBerzerk(ConfuseDuration);
		}
	}
}

function SetupAvoidanceCylinder()
{
	if( !bDeleteMe && AvoidanceCylinder == None )
	{
		if( AvoidanceCylinder == None )
		{
			AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder',self,,Location,,,TRUE);
		}

		if( AvoidanceCylinder != None )
		{
			AvoidanceCylinder.SetBase(self);
			AvoidanceCylinder.SetCylinderSize(ConfuseRadius, ConfuseRadius*2.0f);
			AvoidanceCylinder.SetEnabled(true);
		}

		//DrawDebugSphere(Location,ConfuseRadius,16,255,0,0,TRUE);
	}

}

defaultproperties
{
	bCollideActors=true
	Begin Object Class=CylinderComponent Name=CollisionCylinder0
		CollisionRadius=+0032.000000
		CollisionHeight=+0032.00000
		CollideActors=TRUE
	End Object
	CollisionComponent=CollisionCylinder0
	Components.Add(CollisionCylinder0)

	CoughRadius=512
}
