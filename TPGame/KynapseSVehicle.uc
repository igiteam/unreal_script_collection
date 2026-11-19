//***********************************************************************
// Class:		KynapseSVehicle
// Description: 
// Created By:  Doug Kuppinger, Spark Unlimited 2007
//***********************************************************************

class KynapseSVehicle extends SVehicle
					native
					abstract;



//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var(Kynapse) const bool Obstacle; // it's an obstacle that Kynapse needs to use dynamic avoidance on

var bool moving;
//////// need to make actors work with Kynapse PathObjects ////////
/** internal variable keeping a pointer on the Kynapse entity */
var private pointer KynapseEntity;



//***********************************************************************
// CPP TEXT
//***********************************************************************

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)



//***********************************************************************
// NATIVE FUNCTIONS
//***********************************************************************

native function InitKynapseEntity(string EntityDefintionName);
native function DestroyKynapseEntity();



//-----------------------------------------------------------------------
// Function: 
// Description:	
//-----------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	if (Obstacle && TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		InitKynapseEntity("KynapseObstaclePathObjectDefinition");
	}
}

//-----------------------------------------------------------------------
// Function: 
// Description:	
//-----------------------------------------------------------------------
simulated function OnDestroy(SeqAct_Destroy Action)
{
	if (Obstacle && TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		DestroyKynapseEntity();
	}
	Super.OnDestroy(Action);
}

//-----------------------------------------------------------------------
// Function: 
// Description:	
//-----------------------------------------------------------------------
// this kills them quicker than FinishDestroy
simulated function Destroyed()
{
	if (Obstacle && TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		DestroyKynapseEntity();
	}
	Super.Destroyed();
}


//***********************************************************************
// Default Properties
//***********************************************************************

