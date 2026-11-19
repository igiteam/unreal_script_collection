
class TPTeamInfo extends TeamInfo
	dependson(TPSquad)
	native;

//***********************************************************************
// Include files
//***********************************************************************












 







































#linenumber 9

//`define AILOG(c,t)

//***********************************************************************
// Struct Declarations
//***********************************************************************



//***********************************************************************
// Variable Declarations
//***********************************************************************
var array<Controller> m_teamMembers;	/** List of all players on this team */
var array<TPSquad> m_squads;			/** List of all current squads */
var class<TPSquad> m_squadType;			/** Squad type this team uses */
var class<TPSquad> m_defaultSquadType;	/** Squad type to use if a team member has no squad assigned */
var float m_squadUpdateRate;			/** Rate of squad updates */
// FIXME: This is here for now to allow comparison between good guys and bad guys
var(AI) bool bUsePathSmoothing;

//***********************************************************************
// CPP Text
//***********************************************************************

//***********************************************************************
// Native Function Declarations
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:	Dumps a formatted log statement to the log file associated
//				with this team.
//				@param	logCategory - category of information being dumped
//						(for filtering)
//				@param	logText - string to dump to log file
//-----------------------------------------------------------------------
native final function TPAILog(INT LogDetailLevel, Name logCategory, string logText);

//***********************************************************************
// Functions/States
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description: Overidden so that we can clean ourself up...
//-----------------------------------------------------------------------
simulated function Destroyed()
{
	local int idx;
	local TPSquad spSquad;
	local array<TPSquad> deleteSquad;

	deleteSquad.Length = m_squads.Length;
	for (idx = 0; idx < m_squads.Length; idx++)
	{
		deleteSquad[idx] = m_squads[idx];
	}

	for (idx = 0; idx < m_squads.Length; idx++)
	{
		spSquad = deleteSquad[idx];
		if (spSquad != None && !spSquad.bDeleteMe)
			spSquad.Destroy();
	}

	Super.Destroyed();
}

//-----------------------------------------------------------------------
// Function:
// Description: Each TPTeamInfo sub-class will need to override this to
//				provide pre-defined squad names per team type.
//
//				@param - idx: index into an array of names...
//-----------------------------------------------------------------------
event Name GetPreDefinedSquadName(int idx)
{
	//Only one squad is allowed for Base TPTeamInfo class
	return 'Default';
}

//-----------------------------------------------------------------------
// Function:
// Description: Called by TPSquad when it wants to remove itself.
//-----------------------------------------------------------------------
function RemoveSquad(TPSquad squadToRemove, optional bool bForced)
{
	local TPSquad newSquad;
	local int tempIdx;
	local int squadIdx;

	if (squadToRemove != None)
	{
		squadIdx = GetSquadIndex(squadToRemove.m_squadName);
		if (squadIdx >= 0)
		{
			if (!bForced)
			{
				//see if we have a default squad to remove any squad members to
				newSquad = GetSquadByName('Default', tempIdx, true);
				if (newSquad != None && tempIdx != squadIdx)
				{
					squadToRemove.MoveSquadMembersToNewSquad(newSquad);
				}
			}

			if (squadToRemove.m_team == self)
			{
				squadToRemove.m_team = None;
			}

			m_squads.Remove(squadIdx, 1);
		}
	}
}

//-----------------------------------------------------------------------
// Function:
// Description: Returns TPSquad based on squad name, creating
//				new entries as necessary.
//-----------------------------------------------------------------------
event TPSquad GetSquadByNameNoDefaults(Name squadName)
{
	return GetSquadByName(squadName);
}

//-----------------------------------------------------------------------
// Function:
// Description: Returns TPSquad based on squad name, creating
//				new entries as necessary.
//-----------------------------------------------------------------------
function TPSquad GetSquadByName(Name squadName, optional out int outIdx, optional bool bNoSquadCreate)
{
	local int idx;
	local TPSquad spSquad;
	local TPSquad tempSquad;

	spSquad = None;
	outIdx = -1;
	if (squadName == 'None')
	{
		squadName = 'Default';
	}

	//No squads exist, create a default squad
	if (m_squads.Length == 0 && !bNoSquadCreate)
	{
		;
		tempSquad = spawn(m_defaultSquadType);
		tempSquad.Initialize('Default', self);
		m_squads[m_squads.Length] = tempSquad;
	}

	for (idx = 0; idx < m_squads.Length; idx++)
	{
		if (m_squads[idx] != none && m_squads[idx].m_squadName == squadName)
		{
			spSquad = m_squads[idx];
			break;
		}
	}

	//Already exists???
	if (spSquad != None)
	{
		outIdx = idx;
		return spSquad;
	}

	if (bNoSquadCreate)
	{
		return None;
	}

	;
	spSquad = spawn(m_squadType);
	if (spSquad != None)
	{
		spSquad.Initialize(squadName, self);
		outIdx = m_squads.Length;
		m_squads.AddItem(spSquad);
//		if ( m_squads[m_squads.Length] != none )
//			m_squads[m_squads.Length] = spSquad;
	}
	else
	{
		;
	}

	return spSquad;
}

//-----------------------------------------------------------------------
// Function:
// Description: Returns index to m_squads[] based on squad name, creating
//				new entries as necessary.
//-----------------------------------------------------------------------
function int GetSquadIndex(Name squadName)
{
	local int squadIdx;

	GetSquadByName(squadName, squadIdx);
	return squadIdx;
}

//-----------------------------------------------------------------------
// Function:
// Description:	Returns the squad the player is currently in.
//-----------------------------------------------------------------------
function TPSquad GetMemberSquad(Controller chkMember,optional out int MemberIdx,optional out int SquadIdx)
{
	local int idx, memIdx;
	local TPSquad spSquad;
	local TPAIController spAI;

	spAI = TPAIController(chkMember);
	if (spAI != None && spAI.m_squad != None &&
		spAI.GetTeam() == self)
	{
		spSquad = spAI.m_squad;
		// check to see if they are a member of the squad
		if (spSquad.IsAMember(chkMember, memIdx))
		{
			// write out indices
			MemberIdx = memIdx;
			SquadIdx = GetSquadIndex(spSquad.m_squadName);
			// and return the squad
			return spSquad;
		}
	}
	else
	{
		// search all squads for the member
		for (idx = 0; idx < m_squads.Length; idx++)
		{
			spSquad = m_squads[idx];

			// check to see if they are a member of the squad
			if (spSquad.IsAMember(chkMember, memIdx))
			{
				// write out indices
				MemberIdx = memIdx;
				SquadIdx = idx;
				// and return the squad
				return spSquad;
			}
		}
	}
	// invalidate indices
	MemberIdx = -1;
	SquadIdx = -1;
	return None;
}

//-----------------------------------------------------------------------
// Function:
// Description:	Returns true if there are any other squad members besides
//				the checking player.
//-----------------------------------------------------------------------
function bool HasSquadMembers(Name squadName,Controller chkPlayer)
{
	local TPSquad spSquad;

	if (squadName != 'None')
	{
		spSquad = GetSquadByName(squadName);
		if (spSquad.HasSquadMembers(chkPlayer))
			return true;
	}
	return false;
}

//-----------------------------------------------------------------------
// Function:
// Description:	Copies out a list of squad members.
//-----------------------------------------------------------------------
function bool GetSquadMembers(Name squadName,out array<Controller> squadMembers)
{
	local TPSquad spSquad;

	squadMembers.Length = 0;

	if (squadName != 'None')
	{
		spSquad = GetSquadByName(squadName);
		spSquad.GetSquadMembers(squadMembers);
	}
	return (squadMembers.Length != 0);
}

//-----------------------------------------------------------------------
// Function:
// Description:  Adds the player to the specified squad.
//-----------------------------------------------------------------------
function AddToSquad(Controller newMember, Name squadName)
{
	local TPSquad spSquad;

	spSquad = GetSquadByName(squadName);
	spSquad.AddSquadMember(newMember);

	if (!IsTimerActive('UpdateSquads'))
	{
		UpdateSquads();
		SetTimer(m_squadUpdateRate,true,'UpdateSquads');
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:  Removes the player from their squad (if any).
//-----------------------------------------------------------------------
function RemoveFromSquad(Controller oldMember)
{
	local TPSquad spSquad;

	spSquad = GetMemberSquad(oldMember);
	if (spSquad != None)
	{
		spSquad.RemoveSquadMember(oldMember);
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:  Adds a controller to a team
//-----------------------------------------------------------------------
function bool AddToTeam( Controller Other )
{
	local Controller P;
	local bool bSuccess;
	local TPPlayerReplicationInfo pri;
	if (Other != None ) //MessagingSpectator(Other) == None)
	{
		;
		Size++;
		Other.PlayerReplicationInfo.Team = self;
		//SPARK OCT CODEDROP
		//Other.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - 1;
		
		bSuccess = false;
		if (Other.IsA('PlayerController'))
		{
			Other.PlayerReplicationInfo.TeamID = 0;
		}
		else
		{
			Other.PlayerReplicationInfo.TeamID = 1;
		}
		// get a unique id for this player
		while ( !bSuccess )
		{
			bSuccess = true;
			foreach WorldInfo.AllControllers(class'Controller', P)
			{
				if (P.PlayerReplicationInfo == None)
				{
					;
				}
				else
				if ( P.bIsPlayer && (P != Other)
					&& (P.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team)
					&& (P.PlayerReplicationInfo.TeamId == Other.PlayerReplicationInfo.TeamId) )
				{
					bSuccess = false;
				}
			}
			if ( !bSuccess )
			{
				Other.PlayerReplicationInfo.TeamID = Other.PlayerReplicationInfo.TeamID + 1;
			}
		}
		// add to members list
		m_teamMembers[m_teamMembers.Length] = Other;
		// figure out squad assignement
		pri = TPPlayerReplicationInfo(Other.PlayerReplicationInfo);
		/*
		// force the player squad
		if (Other.IsA('PlayerController') &&
			pri != None)
		{
			pri.SquadName = 'Player';
		}
		*/
		if (pri != None &&
			pri.SquadNameAssignment != 'None')
		{
			// add to specified squad
			AddToSquad(Other,pri.SquadNameAssignment);
		}
		else
		{
			;

			// add to default squad
			AddToSquad(Other,'Default');
			pri.SquadNameAssignment = 'Default';
		}
	}
	return bSuccess;
}


//-----------------------------------------------------------------------
// Function:
// Description:  Does opposite of AddToTeam - clever huh?
//-----------------------------------------------------------------------
function RemoveFromTeam(Controller Other)
{
	local int idx;
	;
	Size--;
	// remove from master member list
	for (idx = 0; idx < m_teamMembers.Length; idx++)
	{
		if (m_teamMembers[idx] == Other)
		{
			RemoveFromSquad(Other);
			if( idx >= 0 && m_teamMembers.Length > idx )
			{
				m_teamMembers.Remove(idx,1);
			}

			break;
		}
	}
}


//-----------------------------------------------------------------------
// Function:
// Description:  Perform update to any squad properties (Damage counter, etc).
//-----------------------------------------------------------------------
function UpdateSquads()
{
	local int squadIdx;
	local TPSquad spSquad;
	local array<TPSquad> deleteSquad;
	local TPSquad defaultSquad;

	defaultSquad = GetSquadByName('Default', squadIdx, true);

	for (squadIdx = 0; squadIdx < m_squads.Length; squadIdx++)
	{
		spSquad = m_squads[squadIdx];

		if ( spSquad != none )
		{
			//Tag squads with 0 members for deletion...
			if (!spSquad.bDeleteMe && spSquad != defaultSquad && spSquad.m_members.Length == 0 &&
				spSquad.m_squadCommand == ETPSC_SquadCommand_None)
			{
				deleteSquad[deleteSquad.Length] = spSquad;
			}
			else
			{
				spSquad.Update(m_squadUpdateRate);
			}
		}
	}

	//Delete squads with 0 members...
	for (squadIdx = 0; squadIdx < deleteSquad.Length; squadIdx++)
	{
		spSquad = deleteSquad[squadIdx];
		if (spSquad != None && !spSquad.bDeleteMe)
			spSquad.Destroy();
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Called by AI controller upon noticing new potential enmy
//-----------------------------------------------------------------------
function BroadcastNotifyEnemy(TPAIController notifier, Controller newEnemy)
{
	local TPSquad spSquad;
	spSquad = GetMemberSquad(notifier);
	if (spSquad != None)
	{
		spSquad.BroadcastNotifyEnemy(notifier, newEnemy);
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Sends AI event along to squad members.
//-----------------------------------------------------------------------
function BroadcastSquadAIEvent(TPAIController notifier, Controller eventTarget, Name squadEvent)
{
	local TPSquad spSquad;
	spSquad = GetMemberSquad(notifier);
	if (spSquad != None)
	{
		spSquad.BroadcastSquadAIEvent(notifier, eventTarget, squadEvent);
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Adjusts squad morale by specified amount.
//-----------------------------------------------------------------------
function AdjustMorale(Name squadName, float adjustment)
{
	local TPSquad spSquad;

	spSquad = GetSquadByName(squadName);
	if (spSquad != None)
	{
		spSquad.AdjustMorale(adjustment);
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Our squad member sucked!  Removed him!
//-----------------------------------------------------------------------
function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
	if (Killed != None && Killed.PlayerReplicationInfo != None && Killed.PlayerReplicationInfo.Team == self)
	{
		RemoveFromSquad(Killed);
	}
	//TPAITodo - morale adjustments, etc
}

//-----------------------------------------------------------------------
// Function:
// Description:	Called by individual pawns upon being damaged.  Allows team to track damage,
//				specifically for morale modifiers.
//-----------------------------------------------------------------------
function NotifyTakeDamage(Controller Victim, Controller cInstigator)
{
	local TPSquad spSquad;

	spSquad = GetMemberSquad(Victim);
	if (spSquad != None)
		spSquad.NotifyDamagedReceived(Victim, cInstigator);

	spSquad = GetMemberSquad(cInstigator);
	if (spSquad != None)
		spSquad.NotifyDamageGiven(Victim, cInstigator);
}

//************************ - BEGIN SECTION - ****************************
// SQUAD COMMANDS
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function bool CanIssueCommandsToSquad(Name squadName)
{
	if (squadName == 'Default')
	{
		//cannot issue commands to default squad!
		return false;
	}

	return true;
}

//-----------------------------------------------------------------------
// Function:
// Description: Clears any commands to the squad...
//-----------------------------------------------------------------------
function ClearSquadCommand(Name squadName)
{
	local TPSquad spSquad;
    local int tmpIdx;

	//`AILOG(0, 'ClearSquadCommand',"");
	if (!CanIssueCommandsToSquad(squadName))
	{
		;
		return;
	}

	spSquad = GetSquadByName(squadName, tmpIdx, true);
	if (spSquad != None)
	{
		spSquad.ClearSquadCommandToAllMembers();
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function IssueCommandDefendAreaToSquad(Name squadName, SquadCommandDefendArea_Params param)
{
	local TPSquad spSquad;

	//`AILOG(0, 'IssueCommandDefendAreaToSquad',"");
	if (!CanIssueCommandsToSquad(squadName))
	{
		;
		return;
	}

	spSquad = GetSquadByName(squadName); //OK to create new squad...
	if (spSquad != None)
	{
		spSquad.SetDefendAreaSquadCommand(param);
	}
}

simulated function color GetTextColor()
{
	local color ResultColor;
	if (TeamIndex == 0)
	{
		ResultColor = MakeColor(0,255,255,255);
	}
	else if (TeamIndex == 1)
	{
		ResultColor = MakeColor(220,220,220,255);
	}

	return ResultColor;
}

//***********************************************************************
// SQUAD COMMANDS
//************************ - END SECTION - ******************************

//***********************************************************************
// Default Properties
//***********************************************************************
