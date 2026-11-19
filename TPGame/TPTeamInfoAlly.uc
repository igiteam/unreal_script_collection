
class TPTeamInfoAlly extends TPTeamInfo;

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
// NOTE: this must be in-sync with m_alliesSquadNames in the default section
enum eTPSquad_Allies
{
	ETPSquad_Allies_None,
	ETPSquad_Allies_01,
	ETPSquad_Allies_02,
	ETPSquad_Allies_03,
	ETPSquad_Allies_04,
	ETPSquad_Allies_05,
	ETPSquad_Allies_06,
	ETPSquad_Allies_07,
	ETPSquad_Allies_08,
	ETPSquad_Allies_09,
	ETPSquad_Allies_10,
	ETPSquad_Allies_11,
	ETPSquad_Allies_12,
	ETPSquad_Allies_13,
	ETPSquad_Allies_14,
	ETPSquad_Allies_15,
	ETPSquad_Allies_16,
	//***ADD NEW SQUADS HERE

	ETPSquad_Allies_Maximus
};

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var array<Name> m_alliesSquadNames;

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
	if (idx > 0 && idx < m_alliesSquadNames.Length)
	{
		return m_alliesSquadNames[idx];
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
