//***********************************************************************
// Class:		 SeqAct_AIStartForceAimAtTarget
// Description:  Tells an actor to aim at current target
// Created By:   Cary Hara, Spark Unlimited 2005
//
// Implementation Nodes:  The code for actually turning the actor is
// implemented in the SPAIController class.  We use the default Activate
// function for SeqActs which is to call 'OnXXXX' on their Target object
//***********************************************************************
class SeqAct_AIStartForceAimAtTarget extends SeqAct_Latent
	native;


//***********************************************************************
// Variable Declaration
//***********************************************************************
var() float m_optionalDuration;			// optional duration to attack in seconds

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
