//***********************************************************************
// Class:		 SeqAct_AIDefendCover
// Description:  Move an actor to a cover link node
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  The code for actually moving the actor is
// implemented in the SPAIController class.  We use the default Activate
// function for SeqActs which is to call 'OnXXXX' on their Target object
//***********************************************************************
class SeqAct_AIAttackUsingCover extends SeqAct_Latent
	native;


//***********************************************************************
// Variable Declaration
//***********************************************************************
/** Should this move be interruptable? */
//var() bool bInterruptable;
var() int SlotToStartToDefendFrom;
var() float MinTimeToUseCoverInSeconds;
var() float MaxTimeToUseCoverInSeconds;
var() float DurationToHidePerCycle;
var() float DurationToFirePerCycle;
var() float DurationToLookForTargetBeforeEngageAttemptPerCycle;
var() bool bUseCoverGroupToSlaughterMyCurrentEnemy;
var() bool bUseCoverGroupTimer;
var() float AmountOfTimeToStayInCoverGroup;
var() bool	bAllowWaitingForPathOrPositionToAnyValidCoverToClear;
var() bool	bAllowWanderingWhileWaitingForPathToAnyValidCover;
var() float	TimeToWaitBetweenPathToAnyValidCoverChecks;
var() int	NoOfTimesToCheckForPathToAnyValidCover;
var() bool	bAllowAttackWhileWaitingForPathToAnyValidCoverToClear;
var() bool	bTaskFailedWhenPathToAnyValidCoverCanNotBeFound;



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
