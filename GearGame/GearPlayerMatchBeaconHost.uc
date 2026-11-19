/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class is used to create a network accessible beacon for responding
 * to reservation requests for player matches. It handles all tracking of
 * who has reserved space, how much space is available, and how many parties
 * can reserve space.
 */
class GearPlayerMatchBeaconHost extends GearPartyBeaconHost
	dependson(GearRecentPlayersList)
	native(Online);

cpptext
{
	/** 
	 * Determine if there are any teams that can fit the current party request.
	 * 
	 * @param PartySize number of players in the party making a reservation request
	 * @return TRUE if there are teams available, FALSE otherwise 
	 */
	virtual UBOOL AreTeamsAvailable(INT PartySize);

	/**
	 * Determine if the reservation entry for a disconnected client should be removed.
	 *
	 * @param ClientConn the client connection that is disconnecting
	 * @return TRUE if the reservation for the disconnected client should be removed
	 */
	virtual UBOOL ShouldCancelReservationOnDisconnect(const FClientBeaconConnection& ClientConn);
};

/**
 * Finds the current team assignment of the given player net id.
 * Looks at the reservation entries to find the player.
 *
 * @param PlayerId net id of player to find
 * @return index of team assignment for the given player, -1 if not found
 */
function int GetTeamForCurrentPlayer(UniqueNetId PlayerId)
{
	local int ResIdx, PlayerIdx, TeamNum;
	local UniqueNetId ZeroId;

	TeamNum = -1;
	if (ZeroId != PlayerId)
	{
		for (ResIdx=0; ResIdx < Reservations.Length; ResIdx++)
		{
			for (PlayerIdx=0; PlayerIdx < Reservations[ResIdx].PartyMembers.Length; PlayerIdx++)
			{
				// find the player id in the existing list of reservations
				if (Reservations[ResIdx].PartyMembers[PlayerIdx].NetId == PlayerId)
				{
					TeamNum = Reservations[ResIdx].TeamNum;
					break;
				}
			}
		}
	}

	// default to -1 if reservation entry wasn't found for the player
	`LogBeacon("Assigning player"
		@class'OnlineSubsystem'.static.UniqueNetIdToString(PlayerId)
		@"to team"@TeamNum);
	return TeamNum;
}

/**
 * Calculate the number of players currently active in a given team.
 *
 * @param TeamIdx index of team to count players
 * @return number of party members currently in a given team
 */
function int GetOccupiedTeamSize(int TeamIdx)
{
	local int ResIdx, PlayerIdx, NumTeamMembers;
	local UniqueNetId ZeroId;

	NumTeamMembers = 0;
	for (ResIdx=0; ResIdx < Reservations.Length; ResIdx++)
	{
		if ( Reservations[ResIdx].TeamNum == TeamIdx)
		{
			for (PlayerIdx=0; PlayerIdx < Reservations[ResIdx].PartyMembers.Length; PlayerIdx++)
			{
				// find the player id in the existing list of reservations
				if (Reservations[ResIdx].PartyMembers[PlayerIdx].NetId != ZeroId)
				{
					NumTeamMembers++;
				}
			}
		}		
	}
	return NumTeamMembers;
}

/**
 * Create the beacon reservation for the active party that hosted the session
 *
 * @param PartyLeader player that owns the party
 * @param PartyMembers current players that are active in the party (including party leader)
 * @param bIsGameHost TRUE if the party reservation is hosting the game
 * @return TRUE if the reservation was added successfully 
 */
function bool AddGearPartyReservation(UniqueNetId PartyLeader,const array<GearRecentPlayer> PartyMembers,bool bIsGameHost)
{
	local array<PlayerReservation> ReservationMembers;
	local int CurPlayerIdx;
	local bool bResult;

	bResult = false;
	if (PartyMembers.Length > 0)
	{
		// Recent players list contains the host party members. Assume that they are all on the same team
		// Create a new reservation entry for the members of the game host party
		ReservationMembers.Length = Min(PartyMembers.Length,NumPlayersPerTeam);
		for (CurPlayerIdx=0; CurPlayerIdx < ReservationMembers.Length; CurPlayerIdx++)
		{
			ReservationMembers[CurPlayerIdx].NetId = PartyMembers[CurPlayerIdx].NetId;
			ReservationMembers[CurPlayerIdx].Skill = PartyMembers[CurPlayerIdx].Skill;
			ReservationMembers[CurPlayerIdx].XpLevel = PartyMembers[CurPlayerIdx].Level;
		}		
		// Add the new reservation request
		if (AddPartyReservationEntry(PartyLeader,ReservationMembers,PartyMembers[0].TeamNum,bIsGameHost) == PRR_ReservationAccepted)
		{
			bResult = true;
		} 
	}	
	return bResult;
}

`if(`notdefined(FINAL_RELEASE))
/**
 * Logs the reservation information for this beacon
 */
function DumpReservations()
{
	Super.DumpReservations();
}
`endif

defaultproperties
{
	// auto logout player entries with reservations if they are no longer a party of the session associated with the beacon
	bLogoutOnSessionTimeout=true
	bUpdateElapsedSessionTimes=true

	// auto-balancing of teams enabled on join for new reservation requests 
	bAutoBalanceTeams=true
	WeightPlayerXpLevel=1.0
	WeightPlayerSkill=0.0
}