//***********************************************************************
// Class:		 SeqAct_AIPerformCustomCoverBehavior
// Description:  Have an Actor Perform some Specified cover sub-behavior for the selected duration of time
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  The code for actually moving the actor is
// implemented in the SPAIController class.  We use the default Activate
// function for SeqActs which is to call 'OnXXXX' on their Target object
//***********************************************************************
class SeqAct_AIPerformCustomCoverBehavior extends SeqAct_Latent;


//***********************************************************************
// Variable Declaration
//***********************************************************************
/** Should this move be interruptable? */
var() bool bInterruptable;
var() bool bOverRideNonScriptedDurations;
var() float TimeToPerformInSeconds;
var() eScriptedCoverBehavior BehaviorToPerform;


//***********************************************************************
// Default Properties
//***********************************************************************
