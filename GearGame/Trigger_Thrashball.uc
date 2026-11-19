/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Trigger_Thrashball extends Trigger;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local GearPawn_COGGear GP;
	local float TargDotY;
	local Vector X, Y, Z;
	local Vector VectToTarg;
	local array<ESpecialMove> AvailableMoves;
	local int Idx;
	

	GP = GearPawn_COGGear(Other);
	if( GP != None && GP.IsDoingSpecialMove( SM_RoadieRun ) )
	{
		GetAxes( GP.Rotation, X, Y, Z );
		VectToTarg = Normal(Location - GP.Location);

		TargDotY = VectToTarg DOT Y;

		//`log( `location@`showvar(TargDotY));
		if( TargDotY < -0.2f )
		{
			AvailableMoves[AvailableMoves.Length] = GSM_SwipeAttack;    // STIFF ARM
		}
		if( TargDotY < 0.3f )
		{
			AvailableMoves[AvailableMoves.Length] = GSM_PounceAttack;   // SHOULDER CHARGE
		}
		if( TargDotY > -0.1f )
		{
			AvailableMoves[AvailableMoves.Length] = GSM_Scream;         // SPIN
		}

		Idx = Rand(AvailableMoves.Length);
		GP.ServerDoSpecialMove( AvailableMoves[Idx], TRUE, GearPawn(Base) );


		SetCollision( FALSE, FALSE );

		Base.TriggerEventClass( class'SeqEvent_Touch', Other, 0 );
	}

	Super.Touch( Other, OtherComp, HitLocation, HitNormal );
}

defaultproperties
{
	bStatic=FALSE
	bNoDelete=FALSE

	Begin Object Name=CollisionCylinder
		CollisionRadius=80.f
		CollisionHeight=40.f
	End Object
}
