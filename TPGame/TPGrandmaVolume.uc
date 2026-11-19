
class TPGrandmaVolume extends TriggerVolume
	Native
	ShowCategories(Object)
	ShowCategories(Movement)
	ShowCategories(Display)
	dependson(TPPlayerController);

//***********************************************************************
// INCLUDES
//***********************************************************************

//***********************************************************************
// MACROS
//***********************************************************************

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var ()	Float	LoiterTime;
var		Bool	bPlayerPresent;
var		Bool	bEventTriggered;
var		Float	CurrentTime;
var		TPPlayerController m_CurrentPlayerCon;

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

event TriggerGranny()
{
	// Trigger the starting events
	TriggerEventClass(class'SeqEvent_Granny', m_CurrentPlayerCon.Pawn , 0);
	bEventTriggered = TRUE;
	
	if (m_CurrentPlayerCon != None)
	{
		m_CurrentPlayerCon.m_bGranny = TRUE;
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Overridden from TriggerVolume to catch Pawns entering
//				Defend Area...
//-----------------------------------------------------------------------
event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
	super.Touch(Other, OtherComponent, HitLocation, HitNormal);
	
	if( Other.IsA('PlayerPawn' ) )
	{
		if (!bPlayerPresent)
		{
			m_CurrentPlayerCon = TPPlayerController(PlayerPawn(Other).Controller);
			bPlayerPresent = TRUE;
			bEventTriggered = FALSE;
			CurrentTime = 0.0f;
		}
	}
}

event Untouch(Actor Other)
{
	super.Untouch(Other);

	if( Other.IsA('PlayerPawn' ) )
	{
		if (bEventTriggered)
		{
			// Trigger the exiting events
			TriggerEventClass(class'SeqEvent_Granny', m_CurrentPlayerCon.Pawn , 1);

			//TPPlayerController tpplCon = TPPlayerController(CurrentPlayer.Controller);
			
			if (m_CurrentPlayerCon != None)
			{
				m_CurrentPlayerCon.m_bGranny = FALSE;
			}
			
			m_CurrentPlayerCon = None;
			bEventTriggered = FALSE;
		}
		
		bPlayerPresent = FALSE;
	}
}

//************************ - BEGIN SECTION - ****************************
// <SECTION NAME>
//***********************************************************************

//***********************************************************************
// <SECTION NAME>
//************************ - END SECTION - ******************************

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
