/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/
class Path_AvoidanceVolumes extends PathConstraint
	native(TGAI);

var TGAI MyTGAI;

var array<AIAvoidanceCylinderComponent> AffectingCylinders;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

static final function bool AvoidThoseVolumes( Pawn P )
{
	local Path_AvoidanceVolumes Con;
	local Array<AIAvoidanceCylinderComponent>  LocalAffectingCylinders;

	local TGAI GAI;
	GAI = TGAI(P.Controller);
	
	if (GAI != none && class'AIAvoidanceCylinderComponent'.static.BuildListOfAffectingCylinders(GAI,LocalAffectingCylinders))
	{
		Con = Path_AvoidanceVolumes(P.CreatePathConstraint(default.class));
		Con.MyTGAI = GAI;
		Con.AffectingCylinders = LocalAffectingCylinders;
		P.AddPathConstraint(Con);
		return TRUE;
	}

	return FALSE;
}

function Recycle()
{
	Super.Recycle();
	AffectingCylinders.length=0;
	MyTGAI=none;
}
