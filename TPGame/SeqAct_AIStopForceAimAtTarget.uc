//***********************************************************************
// Class:		 SeqAct_AIStopForceAimAtTarget
// Description:  Force an Actor to Stop Aiming at a target (assumes already doing a forced aim)
// Created By:   Cary Hara, Spark Unlimited 2005
//
// Implementation Nodes:  The code for actually turning the actor is
// implemented in the SPAIController class.  We use the default Activate
// function for SeqActs which is to call 'OnXXXX' on their Target object
//***********************************************************************
class SeqAct_AIStopForceAimAtTarget extends SequenceAction;


//***********************************************************************
// Default Properties
//***********************************************************************
