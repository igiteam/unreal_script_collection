/**
 * Base class for behavior of Brumak
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */ 
class AICmd_Base_Brumak extends AIcmd_Base_UtilActionSelector
	within GearAI_Brumak;

var transient array<CoverInfo> DisabledCoverList;

function float PrePickBestCommand()
{
	if( !SelectEnemy() )
	{
		//debug
		`AILog("Unable to select an enemy");

		return 1.f;
	}

	Focus = Enemy;

	return 0.f;
}

function int PickBestCommand()
{
	RefreshDisabledCoverList();

	return Super.PickBestCommand();
}

function RefreshDisabledCoverList()
{
	local Vector SearchLoc;
	local int CoverIdx;

	// Clean up our previous list
	for( CoverIdx = 0; CoverIdx < DisabledCoverList.Length; CoverIdx++ )
	{
		if( DisabledCoverList[CoverIdx].Link != None )
		{
			DisabledCoverList[CoverIdx].Link.SetSlotPlayerOnly( DisabledCoverList[CoverIdx].SlotIdx, FALSE );
		}		
	}
	DisabledCoverList.Length = 0;

	// Repopulate and toggle players only
	SearchLoc = Pawn.Location;
	SearchLoc.Z -= Pawn.GetCollisionHeight();
	NavigationHandle.GetAllCoverSlotsInRadius( SearchLoc, EnemyDistance_Melee, DisabledCoverList );

	for( CoverIdx = 0; CoverIdx < DisabledCoverList.Length; CoverIdx++ )
	{
		if( DisabledCoverList[CoverIdx].Link != None )
		{
			DisabledCoverList[CoverIdx].Link.SetSlotPlayerOnly( DisabledCoverList[CoverIdx].SlotIdx, TRUE );
		}		
	}
}


defaultproperties
{
	Begin Object Class=UtilBasedAICmdMetaDataPacket Name=StandGround0
		CommandClass=class'AICmd_Brumak_Action_StandGround'
	End Object
	Begin Object Class=UtilBasedAICmdMetaDataPacket Name=Reposition0
		CommandClass=class'AICmd_Brumak_Action_Reposition'
	End Object
	Begin Object Class=UtilBasedAICmdMetaDataPacket Name=Melee0
		CommandClass=class'AICmd_Brumak_Action_Melee'
	End Object

	PossibleCommands.Add(StandGround0)
	PossibleCommands.Add(Reposition0)
	PossibleCommands.Add(Melee0)

}
