//=============================================================================
// SASCoopSquadManager.uc
//
// Squad management functions
//
//=============================================================================

class SASCoopSquadManager extends SASMPSquadManager;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions
/*
///////////////////////////////////////////////////////////////////////////////
// AddPlayerMember
//
// Add a human player to the squad.
simulated function AddPlayerMember( 
	SASSoldier	aNewPlayer )
{
	local int i;

	if ( aNewPlayer == None )
	{
		return;
	}

	if ( mNumPlayers >= MAX_SQUAD_MEMBERS )
	{
		return;
	}

	for ( i = 0; i < mNumPlayers; i++ )
	{
		if ( mPlayers[i] == aNewPlayer )
		{
			Warn( "Attempting to add player to SASSquadManager when already assigned." );
			return;
		}
	}

	mPlayers[mNumPlayers]			= aNewPlayer;
	mPlayers[mNumPlayers].mSquadIdx = mNumPlayers;

	mNumPlayers++;
}

///////////////////////////////////////////////////////////////////////////////
// PlayerDied
//
function PlayerDied(
	SASSoldier aDeadPlayer )
{
	local int			playerIdx;
	local SASSoldier	wingman;

	Log ( "PlayerDied: " @aDeadPlayer );

	if ( aDeadPlayer == None )
	{
		return;
	}

	playerIdx = GetPlayerSlotIdx( aDeadPlayer );
	if ( playerIdx == -1 )
	{
		return;
	}

	// Release wingman.
	if ( mWingmanIndices[playerIdx] != -1 )
	{
		wingman = mAISquadMembers[mWingmanIndices[playerIdx]];
		if ( wingman != None && wingman.Controller != None )
		{
			SASSoldierController( wingman.Controller ).UnassignWingman();
		}

		mWingmanIndices[playerIdx] = -1;
	}

	mPlayers[playerIdx] = None;
}

////////////////////////////////////////////////////////////////////////////////
// IsAWingman 
//
function bool IsAWingman ( SASSoldier soldier )
{
	local int	i;

	for ( i = 0; i < 3; i++ )
	{
		if ( ( mWingmanIndices[i] != -1 ) && ( soldier == mAISquadMembers[mWingmanIndices[i]] ) )
		{
			// Soldier is player i's wingman
			return true;
		}
	}

	return false;
}

///////////////////////////////////////////////////////////////////////////////
// CanAllocateWingman
//
simulated function bool CanAllocateWingman (SASSoldier player)
{
	local int			i;
	local int			numAis;
	local SASSoldier	soldier;

	for ( i = 0; i < mNumAISquadMembers; i++ )
	{
		soldier = mAISquadMembers[i];
		if ( ( soldier != None ) && !IsAWingman ( soldier ) )
		{
			numAis++;
		}
	}
	return numAis > 0;
}
*/
//-----------------------------------------------------------------------------
// Default properties

