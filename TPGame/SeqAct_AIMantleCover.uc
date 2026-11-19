//***********************************************************************
// Class:		 SeqAct_AIMantleCover
// Description:  Move an actor to a cover link node and go over it
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  The code for actually moving the actor is
// implemented in the SPAIController class.  We use the default Activate
// function for SeqActs which is to call 'OnXXXX' on their Target object
//***********************************************************************
class SeqAct_AIMantleCover extends SeqAct_Latent
	native;


//***********************************************************************
// Variable Declaration
//***********************************************************************
/** Should this move be interruptable? */
var() bool bInterruptable;
var() int SlotToMantleFrom;
var() eMantleAction MantleAction;

var() bool bAllowWaitingForPathOrPositionToClear;
var() bool bAllowWanderingWhileWaiting;
var() float TimeToWaitBetweenPathChecks;

var() int NoOfTimesToCheckForPathToCover;

var() bool bAllowAttackWhileWaitingForPathToClear;

var () float JumpDownHorizontalOutDuration;
var () float JumpDownMinVirticalDist;
var () float JumpDownSpeed;


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
