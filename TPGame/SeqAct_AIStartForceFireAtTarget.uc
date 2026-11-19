//***********************************************************************
// Class:		 SeqAct_AITurnToActor
// Description:  turns an actor to face another actor
// Created By:   Brad Fitzgerald, Spark Unlimited 2005
//
// Implementation Nodes:  The code for actually turning the actor is
// implemented in the SPAIController class.  We use the default Activate
// function for SeqActs which is to call 'OnXXXX' on their Target object
//***********************************************************************
class SeqAct_AIStartForceFireAtTarget extends SeqAct_Latent
	native;


//***********************************************************************
// Variable Declaration
//***********************************************************************
var() float m_optionalDuration;			// optional duration to attack in seconds
var() int   m_optionalNumberOfShots;	// optional number of shots to fire

var() bool bFireAtTargetReguardlessOfWhatItIs;


//***********************************************************************
// CPP Text
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// Default Properties
//***********************************************************************
