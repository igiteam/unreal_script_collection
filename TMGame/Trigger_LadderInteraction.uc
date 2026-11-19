/*
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class Trigger_LadderInteraction extends Trigger
	native(TG)
	placeable;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


/** Indicates if this trigger is hooked up to the top of the ladder */
var()	bool			bIsTopOfLadder;
/** Pointer to Ladder StaticMesh Actor */
var()	StaticMeshActor	LadderSMActor;

var()	vector			BottomLocOffset;
var()	Rotator			BottomRotOffset;

var()	vector			TopLocOffset;
var()	Rotator			TopRotOffset;

/** Top and Bottom Ladder Markers for AI movement */
var()	editconst LadderMarker	TopMarker, BottomMarker;

/** Option to override the animation used */
var() Name ClimbDownAnim, ClimbUpAnim;

simulated function OnToggle(SeqAct_Toggle Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		SetCollision(TRUE,FALSE);
	}
	else
	if (Action.InputLinks[1].bHasImpulse)
	{
		SetCollision(FALSE,FALSE);
	}
	else
	{
		SetCollision(!bCollideActors,FALSE);
	}
}


























simulated native function GetTopEntryPoint( out vector out_Loc, out rotator out_Rot );
simulated native function GetBottomEntryPoint( out vector out_Loc, out rotator out_Rot );

