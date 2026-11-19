//***********************************************************************
// Class:		KynapseStaticMeshActor
// Description: 
// Created By:  Doug Kuppinger, Spark Unlimited 2005
//***********************************************************************

class KynapseStaticMeshActor extends StaticMeshActor
	native
	placeable;



//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var(Kynapse) const bool BlocksAIMesh; // for door frames & stuff that don't destruct (don't like, want these changed to StaticMesh)
var(Kynapse) const bool Obstacle; // it's an obstacle that Kynapse needs to use dynamic avoidance on

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

//***********************************************************************
// NATIVE FUNCTIONS
//***********************************************************************

final native function InitKynapseEntity(string EntityDefintionName);
final native function DestroyKynapseEntity();


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

