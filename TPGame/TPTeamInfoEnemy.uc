
class TPTeamInfoEnemy extends TPTeamInfo;

//***********************************************************************
// INCLUDES
//***********************************************************************












 







































#linenumber 7

//***********************************************************************
// MACROS
//***********************************************************************

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

// enum for HumanAlly squad names to be used by TPPawn subclass to select
// pre-defined squad names...
// NOTE: this must be in-sync with m_enemySquadNames in the default section
enum eTPSquad_Enemy
{
	ETPSquad_Enemy_None,
	ETPSquad_Enemy_01,
	ETPSquad_Enemy_02,
	ETPSquad_Enemy_03,
	ETPSquad_Enemy_04,
	ETPSquad_Enemy_05,
	ETPSquad_Enemy_06,
	ETPSquad_Enemy_07,
	ETPSquad_Enemy_08,
	ETPSquad_Enemy_09,
	ETPSquad_Enemy_10,
	ETPSquad_Enemy_11,
	ETPSquad_Enemy_12,
	ETPSquad_Enemy_13,
	ETPSquad_Enemy_14,
	ETPSquad_Enemy_15,
	ETPSquad_Enemy_16,
	//***ADD NEW SQUADS HERE

	ETPSquad_Enemy_Maximus
};

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var array<Name> m_enemySquadNames;

//***********************************************************************
// CPP TEXT
//***********************************************************************

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
// Description: Overridden from TPTeamInfo
//
//				@param - idx: index into an array of names...
//-----------------------------------------------------------------------
event Name GetPreDefinedSquadName(int idx)
{
	if (idx > 0 && idx < m_enemySquadNames.Length)
	{
		return m_enemySquadNames[idx];
	}
	
	;
	return 'Default';
}

//-----------------------------------------------------------------------
// Function:	 
// Description:	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
// State:	 
// Description:	
//-----------------------------------------------------------------------



//***********************************************************************
// Default Properties
//***********************************************************************
