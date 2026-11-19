//***********************************************************************
// Class:		 SeqAct_AIRappel
// Description:  Make an actor repel until they hit the ground
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  The code for actually moving the actor is
// implemented in the SPAIController class.  We use the default Activate
// function for SeqActs which is to call 'OnXXXX' on their Target object
//***********************************************************************
class SeqAct_AIRappel extends SeqAct_Latent
	native;


//***********************************************************************
// Variable Declaration
//***********************************************************************
/** Should this move be interruptable? */
var() bool bInterruptable;
var() int SlotToMantleFrom;
var() eMantleAction MantleAction;

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
