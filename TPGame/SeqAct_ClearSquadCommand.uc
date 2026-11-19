//***********************************************************************
// Class:		SeqAct_ClearSquadCommand
// Description:
// Created By:  <Ike Macoco>, Spark Unlimited 2005
//***********************************************************************

class SeqAct_ClearSquadCommand extends SequenceAction
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

	for (idx = 0; idx < tpGameInfo.m_teams.Length; idx++)
	{
		tpTeamInfo = tpGameInfo.m_teams[idx];
		if (tpTeamInfo != None && SquadType.IsAssociatedWithTeam(tpTeamInfo))
		{
			squadName = tpTeamInfo.GetPreDefinedSquadName(SquadType.GetSelectedSquadIdx());
			tpTeamInfo.ClearSquadCommand(squadName);
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
