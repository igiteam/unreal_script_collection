/** 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAbsorbOrb_Crate extends NanoAbsorbOrb;



simulated function bool CanInteract( NanoPawn NP, ENanoInteractType Type )
{
	local NanoPC PC;
	local Vector Loc;
	local Rotator Rot;
	local vector CanSeeOffset;

	// grab camera location/rotation
	PC = NanoPC(NP.Controller);
	PC.GetPlayerViewPoint( Loc, Rot );

	CanSeeOffset = (vect(0,0,1) >> Rotation) * 32;  // push out the can see point to be in the middle of the tick

	if( ( PC.CanSeeByPoints( Loc, (Location+CanSeeOffset), Rot ) == FALSE ))
	{
		return FALSE;
	}

	return Super.CanInteract( NP, Type );
}



defaultproperties
{
	Begin Object Name=ParticleSystemComponent0
		Template=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_NanoCollectible_01'
		Scale=2.0f
	End Object
	Components.Add(ParticleSystemComponent0)
	//ColorForOrb=(X=1.0f,Y=0,Z=0)
}






