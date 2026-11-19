
class TPDefendAreaVolume extends TriggerVolume
	ShowCategories(Object)
	ShowCategories(Movement)
	ShowCategories(Display);

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
var() eUniformResponse CivilianResponse;
var() eUniformResponse PeonResponse;
var() eUniformResponse SoldierResponse;
var() eUniformResponse OfficerResponse;
var() eUniformResponse CommandantResponse;
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
// Description:	Overridden from TriggerVolume to catch Pawns entering
//				Defend Area...
//-----------------------------------------------------------------------
event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
//	local TPPawn spPawnage;
//	local TPAIController spAI;

	local TPPlayerController pc;
	

	super.Touch(Other, OtherComponent, HitLocation, HitNormal);
	
	
	
	if( Other.IsA('PlayerPawn' ) )
	{
		//Register this as the player's restricted area
		pc = TPPlayerController( PlayerPawn(Other).Controller );
		pc.SetRestrictedAreaVolume( self );
	}
	
	
	
//Defend area stuff
//	spPawnage = TPPawn(Other);
//	if (spPawnage != none && spPawnage.Controller != none)
//	{
//		spAI = TPAIController(spPawnage.Controller);
//	}
//
//	if (spAI != none)
//	{
//		//Log("SPPawn:"@spPawnage@"touching vol:"@self);
//		if (spAI.IsDefendingTriggerVolume(self))
//		{
//			spAI.SetHasBeenInDefendArea(true);
//		}
//	}
}

event Untouch(Actor Other)
{
	local TPPlayerController pc;


	super.Untouch(Other);

	
	if( Other.IsA('PlayerPawn' ) )
	{
		//Unregister this as the player's restricted area
		pc = TPPlayerController( PlayerPawn(Other).Controller );
		pc.SetRestrictedAreaVolume( None );
	}
	
}


function eUniformResponse GetResponseForEnemy( Controller EnemyController )
{
	local TPPawn tppawn;
	local eUniform enemyUniform;
	
	tppawn = TPPawn(EnemyController.Pawn);
	if( tppawn != None )
	{
		//quick out for civilians
		if( tppawn.IsA('CivilianPawn') )
		{
			return CivilianResponse;
		}		
		
		enemyUniform = tppawn.Uniform;
	}
	else
	{
		return UniformResponse_Ignore;
		
	}
		
		
		
	switch( enemyUniform )
	{
		case Uniform_Peon:
			return PeonResponse;
			break;
			
		case Uniform_Soldier:
			return SoldierResponse;	
			break;
			
		case Uniform_Officer:
			return OfficerResponse;
			break;
			
		case Uniform_Commandant:
			return CommandantResponse;
			break;
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
