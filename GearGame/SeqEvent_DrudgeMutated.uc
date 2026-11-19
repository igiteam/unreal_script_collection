/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvent_DrudgeMutated extends SequenceEvent;

/** Polyp spawner for variable link */
var Actor PolypSpawner;

final function Mutated(GearPawn_LambentDroneMutatable DrudgePawn, int TransformFlags)
{
	local array<int> ActivateIndices;

	if( DrudgePawn != None )
	{
		ActivateIndices.AddItem(0);
		if( DrudgePawn.IsHeadMutation(TransformFlags) )
		{
			ActivateIndices.AddItem(1);
		}
		if( DrudgePawn.IsArmMutation(TransformFlags) )
		{
			ActivateIndices.AddItem(2);
		}
		if( DrudgePawn.IsLegMutation(TransformFlags) )
		{
			ActivateIndices.AddItem(3);
			PolypSpawner = DrudgePawn.PolypSpawner;
		}
		CheckActivate(DrudgePawn, DrudgePawn, false, ActivateIndices);
	}
}

defaultproperties
{
	ObjName="Drudge Mutated"
	ObjCategory="Gear"

	OutputLinks(0)=(LinkDesc="Mutated")
	OutputLinks(1)=(LinkDesc="Mutated Head")
	OutputLinks(2)=(LinkDesc="Mutated Arms")
	OutputLinks(3)=(LinkDesc="Mutated Legs")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Polyp Spawner",bWriteable=true,PropertyName=PolypSpawner)

	bPlayerOnly=false
}
