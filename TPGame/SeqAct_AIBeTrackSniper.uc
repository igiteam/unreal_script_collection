//***********************************************************************
// Class:		 SeqAct_AIBeTrackSniper
// Description:  Move an actor to a point and have him watch a series of actors and snipe any targets that are in that track
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  
//***********************************************************************
class SeqAct_AIBeTrackSniper extends SeqAct_Latent
	native;

//***********************************************************************
// Variable Declaration
//***********************************************************************
/** Should this move be interruptable? */
var() array<Actor> Track;
var() bool bLoopTrack;
var() bool bInterruptable;
var() int SlotToStartToBeAt;
var() float MinTimeToBeSniperInSeconds;
var() float MaxTimeToBeSniperInSeconds;
//var() float SearchRange;
var() float SearchRateUUnitsPerSec;
//var() float MaxDirChangePerSec;
var() float Accuracy;
var() int RateOfFirePerMin;
var() float TargetAcquireRange;
var() float TimeToWaitAfterLosingContact;
var() bool bDisplaySniperAimRay;
var() color DisplaySniperAimRaySearchingColor;
var() color DisplaySniperAimRayAcquiredColor;

var() bool bAllowWaitingForPathOrPositionToClear;
var() bool bAllowWanderingWhileWaiting;
var() float TimeToWaitBetweenPathChecks;

var() int NoOfTimesToCheckForPathToCover;

var() bool bAllowAttackWhileWaitingForPathToClear;



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
