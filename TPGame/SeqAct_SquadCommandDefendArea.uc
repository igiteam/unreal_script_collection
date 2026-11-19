//***********************************************************************
// Class:		SeqAct_SquadCommandDefendArea
// Description:
// Created By:  <Ike Macoco>, Spark Unlimited 2005
//***********************************************************************

class SeqAct_SquadCommandDefendArea extends SequenceAction
	dependson(WorldInfo)
	native;

//***********************************************************************
// INCLUDES
//***********************************************************************
//`include( Core\LoggingUPPMacros.uci ) // to use logging preprocessor macros























































































































 



#linenumber 15

//***********************************************************************
// MACROS
//***********************************************************************

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var() export editinline TPSquadSelector SquadType; /** Type of squad to select name from */
var() ETPSquadCommandPriority CommandPriority;
var() ETPDefendAreaDestAssignment DestinationAssignment;
var() float AttackDistWhileDefendingArea;

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

//***********************************************************************
// FUNCTION DECLARATIONS
//***********************************************************************

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:	Called from native Activated() function defined above
//				in cpptext{}
//-----------------------------------------------------------------------
function bool ScriptActivated()
{
	local int idx;
	local TPTeamInfo tpTeamInfo;
	local Name squadName;
	local TPSinglePlayerGameInfo  tpGameInfo;
	local TPDefendAreaVolume tpDefendAreaVolume;
	local Trigger_Dynamic trigDynamicVolume;
	local ETPSquadCommandPriority priority;
	local SquadCommandDefendArea_Params params;
	local array<Object> objVars;

	//run through the gauntlet of checks...
	if (SquadType == None)
	{
		;
		return true;
	}
	tpGameInfo = TPSinglePlayerGameInfo(GetWorldInfo().Game);
	if (tpGameInfo == None)
	{
		;
		return true;
	}

	GetObjectVars(ObjVars,"DefendArea Volume");
	if (objVars.Length <= 0)
	{
		;
		return true;
	}
	if (objVars.Length > 1)
	{
		;
	}

	tpDefendAreaVolume = TPDefendAreaVolume(objVars[0]);
	trigDynamicVolume = Trigger_Dynamic(objVars[0]);
	if (tpDefendAreaVolume == none && trigDynamicVolume == none)
	{
		;
		return true;
	}

	priority = ETPCP_SquadCommandPriority_Low; //default to low priority...
	if (CommandPriority != ETPCP_SquadCommandPriority_None)
	{
		priority = CommandPriority;
	}

	//create our param struct...
	params.defendAreaVolume = tpDefendAreaVolume;
	params.defendAreaDynamicVolume = trigDynamicVolume;
	params.commandPriority = priority;
	params.destAssignment = DestinationAssignment;
	params.attackDistWhileDefendingArea = AttackDistWhileDefendingArea;

	for (idx = 0; idx < tpGameInfo.m_teams.Length; idx++)
	{
		tpTeamInfo = tpGameInfo.m_teams[idx];
		if (tpTeamInfo != None && SquadType.IsAssociatedWithTeam(tpTeamInfo))
		{
			squadName = tpTeamInfo.GetPreDefinedSquadName(SquadType.GetSelectedSquadIdx());
			tpTeamInfo.IssueCommandDefendAreaToSquad(squadName, params);
		}
	}

	return true;
}

//************************ - BEGIN SECTION - ****************************
// <SECTION NAME>
//***********************************************************************

//***********************************************************************
// <SECTION NAME>
//************************ - END SECTION - ******************************


//-----------------------------------------------------------------------
// State:
// Description:
//-----------------------------------------------------------------------



//***********************************************************************
// Default Properties
//***********************************************************************
