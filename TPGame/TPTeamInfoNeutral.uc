
class TPTeamInfoNeutral extends TPTeamInfo
	native;

//***********************************************************************
// INCLUDES
//***********************************************************************












 







































#linenumber 8

//***********************************************************************
// MACROS
//***********************************************************************

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

// enum for HumanAlly squad names to be used by TPPawn subclass to select
// pre-defined squad names...
// NOTE: this must be in-sync with m_neutralSquadNames in the default section
enum eTPSquad_Neutral
{
	ETPSquad_Neutral_None,
	ETPSquad_Neutral_01,
	ETPSquad_Neutral_02,
	ETPSquad_Neutral_03,
	ETPSquad_Neutral_04,
	ETPSquad_Neutral_05,
	ETPSquad_Neutral_06,
	ETPSquad_Neutral_07,
	ETPSquad_Neutral_08,
	ETPSquad_Neutral_09,
	ETPSquad_Neutral_10,
	ETPSquad_Neutral_11,
	ETPSquad_Neutral_12,
	ETPSquad_Neutral_13,
	ETPSquad_Neutral_14,
	ETPSquad_Neutral_15,
	ETPSquad_Neutral_16,
	//***ADD NEW SQUADS HERE

	ETPSquad_Neutral_Maximus
};

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var array<Name> m_neutralSquadNames;

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
	if (idx > 0 && idx < m_neutralSquadNames.Length)
	{
		return m_neutralSquadNames[idx];
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
