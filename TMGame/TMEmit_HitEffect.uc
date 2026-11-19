/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMEmit_HitEffect extends TMEmitter;

simulated function AttachTo(Pawn P, name NewBoneName)
{
	if (NewBoneName == '')
	{
		SetBase(P);
	}
	else
	{
		SetBase(P,, P.Mesh, NewBoneName);
	}
}

simulated function PawnBaseDied()
{
	if (ParticleSystemComponent != None)
	{
		ParticleSystemComponent.DeactivateSystem();
	}
}

