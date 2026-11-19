/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_DropTheHammer_Victim extends NanoSpecialMove;

var config protected float DropTheHammerThrowSpeed;
var config protected float DropTheHammerThrowZ;

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local Vector ThrowDir;
	local float ThrowSpeed, ThrowZ;

	Super.SpecialMoveStarted( bForced, PrevMove );

	MyNP.SetPhysics(PHYS_Falling);

	InitThrowVars( ThrowSpeed, ThrowZ );

	// Set velocity away from landing location
	ThrowDir = Normal(MyNP.Location - MyNP.InteractionActor.Location);
	ThrowDir.Z = 0.0;
	MyNP.Velocity = (ThrowDir * ThrowSpeed) + (vect(0,0,1) * ThrowZ);

	// When they land after this they will be knocked down
	MyNP.bKnockDownOnLanding = TRUE;
}

function InitThrowVars( out float out_ThrowSpeed, out float out_ThrowZ )
{
	out_ThrowSpeed = DropTheHammerThrowSpeed;
	out_ThrowZ = DropTheHammerThrowZ;
}

function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( MyNP.Physics == PHYS_Walking && !MyNP.bKnockDownOnLanding && !MyNP.bKnockedDown )
	{
		MyNP.EndSpecialMove();
	}
}

defaultproperties
{

}