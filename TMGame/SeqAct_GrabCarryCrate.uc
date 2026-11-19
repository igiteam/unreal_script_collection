/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_GrabCarryCrate extends SequenceAction;

event Activated()
{
	local array<Object> OutObjs;
	local TGPawn MarcusPawn, DomPawn;
	local TGPawn_CarryCrate_Base CratePawn;

	// Get marcus, dom and crate pawns
	GetObjectVars(OutObjs, "Marcus");
	MarcusPawn = TGPawn(Controller(OutObjs[0]).Pawn);
	OutObjs.length = 0;

	GetObjectVars(OutObjs, "Dom");
	DomPawn = TGPawn(Controller(OutObjs[0]).Pawn);
	OutObjs.length = 0;

	GetObjectVars(OutObjs, "Crate");
	CratePawn = TGPawn_CarryCrate_Base(OutObjs[0]);
	OutObjs.length = 0;

	// Look at inputs to see if we want to grab or drop crate
	if(InputLinks[0].bHasImpulse)
	{
		CratePawn.BeginCarry(MarcusPawn, DomPawn);
	}
	else if(InputLinks[1].bHasImpulse)
	{
		CratePawn.EndCarry();
	}
}

