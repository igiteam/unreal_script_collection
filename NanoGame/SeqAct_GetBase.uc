/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Outputs the base of the specified target actor
 */
class SeqAct_GetBase extends SequenceAction;

var Actor   Base;
	
event Activated()
{
	local Actor TargetActor;

	// For now, just use the first actor in the target list
	TargetActor = Actor(Targets[0]);

	// If the target is a player controller, get the pawn's base
	if( PlayerController(TargetActor) != None )
	{
		TargetActor = PlayerController(TargetActor).Pawn;
	}

	if( TargetActor != None )
	{
		Base = TargetActor.Base;
		PopulateLinkedVariableValues();
	}
}


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	bCallHandler=FALSE

	ObjName="Get Base"
	ObjCategory="Nano"
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Base",bWriteable=true,PropertyName=Base)
}
