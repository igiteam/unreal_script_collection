/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawnFX_Former extends GearPawnFX_Lambent;

simulated function SpawnChainsawCameraBlood(PlayerController PC)
{
	if (SpecialMove == SM_ChainsawVictim)
	{
		PC.ClientSpawnCameraLensEffect(class'Emit_CameraBlood_Chainsaw_Former');
	}
}

defaultproperties
{
	ChainsawBloodFadeCurve=(Points=((InVal=0.0,OutVal=1.0),(InVal=10.0,OutVal=1.0),(InVal=15.0,OutVal=0.0)))
}
