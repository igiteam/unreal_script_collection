/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ClearPlayerSlot extends SequenceAction;

/** player slot to clear */
var() array<int> PlayerSlotIdx;

event Activated()
{
	local GearGameSP_Base SPGame;
	local Controller C;
	local GearPC PC;
	local Pawn OldPawn;
	local int RealPlayerIdx;
	local int i;

	SPGame = GearGameSP_Base(GetWorldInfo().Game);
	if (SPGame != None)
	{
		for (i = 0; i < PlayerSlotIdx.length; i++)
		{
			RealPlayerIdx = PlayerSlotIdx[i] - 1; // since the LDs wanted 1-4
			SPGame.PlayerSlots[RealPlayerIdx].PawnClass = None;
			C = SPGame.PlayerSlots[RealPlayerIdx].Owner;
			if (AIController(C) != None)
			{
				// just destroy AI completely
				if (C.Pawn != None)
				{
					C.Pawn.Destroy();
				}
				C.Destroy();
				SPGame.PlayerSlots[RealPlayerIdx].Owner = None;
			}
			else
			{
				PC = GearPC(C);
				if (PC != None)
				{
					// get rid of old pawn
					OldPawn = PC.Pawn;
					if (OldPawn != None)
					{
						PC.UnPossess();
						OldPawn.Destroy();
					}
					// act as if player just joined and hasn't spawned in yet
					PC.GotoState('PlayerWaiting');
					PC.ClientGotoState('PlayerWaiting');
					PC.SetViewTarget(SPGame.PlayerSlots[0].Owner.Pawn);
					PC.ClientSetViewTarget(SPGame.PlayerSlots[0].Owner.Pawn);
					PC.SetTimer(0.5, false, nameof(PC.ServerRestartPlayer));
				}
			}
		}
	}
}

defaultproperties
{
	ObjName="Clear Player Slot"
	ObjCategory="Gear"
	VariableLinks.Empty()
	VariableLinks[0]=(ExpectedType=class'SeqVar_Int',LinkDesc="Player Slot",PropertyName=PlayerSlotIdx)
}
