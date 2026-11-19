//***********************************************************************
// Class:		 SeqAct_AIForceTarget
// Description:  forces the guy to take on a specific target
// Created By:   Brad Fitzgerald, Spark Unlimited 2005
//
// Implementation Nodes:  The code for actually turning the actor is
// implemented in the SPAIController class.  We use the default Activate
// function for SeqActs which is to call 'OnXXXX' on their Target object
//***********************************************************************
class SeqAct_AIForceTarget extends SequenceAction;

var() bool bMakeEnemy;

//***********************************************************************
// Default Properties
//***********************************************************************
