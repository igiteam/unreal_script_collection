//***********************************************************************
// Class:		 SeqAct_AIDefendCover
// Description:  Move an actor to a cover link node
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  The code for actually moving the actor is
// implemented in the SPAIController class.  We use the default Activate
// function for SeqActs which is to call 'OnXXXX' on their Target object
//***********************************************************************
class SeqAct_AIDefendCover extends SeqAct_Latent
		native;


//***********************************************************************
// Variable Declaration
//***********************************************************************
/** Should this move be interruptable? */
var() bool bInterruptable;
var() int SlotToStartToDefendFrom;
var() float TimeToDefendInSeconds;
var() float DurationToHidePerCycle;
var() float DurationToFirePerCycle;
var() float DurationToLookForTargetBeforeEngageAttemptPerCycle;

var() bool bAllowWaitingForPathOrPositionToClear;
var() bool bAllowWanderingWhileWaiting;
var() float TimeToWaitBetweenPathChecks;

var() int NoOfTimesToCheckForPathToCover;

var() bool bAllowAttackWhileWaitingForPathToClear;

var() bool			bTaskFailedWhenViolatedByDistenceToEnemy;
var() bool			bTaskFailedWhenViolatedByAngleToEnemy;

var() bool			bTaskFailedWhenPathCanNotBeFound;
var() bool			bTaskFailedWhenCoverCanNotBeClaimed;


//***********************************************************************
// CPP Text
//***********************************************************************

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function AtCoverNode()
{
	;
}

//***********************************************************************
// Default Properties
//***********************************************************************
