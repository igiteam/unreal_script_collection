//***********************************************************************
// Class:		 SeqAct_AIBeTerminator
// Description:  Starts a NPC on a deliberate and slow pased hunt for the player. Should use a large machinegun
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  
//***********************************************************************
class SeqAct_AIBeTerminator extends SeqAct_Latent
	native;


//***********************************************************************
// Variable Declaration
//***********************************************************************
var() float m_Accuracy;
var() int m_RateOfFirePerMin;

var() bool m_UseAgainstCurrentEnemy;


var() float m_MinTimeToTerminate;
var() float m_MaxTimeToTerminate;
var() float m_MinTimeToStandAndShoot;
var() float m_MaxTimeToStandAndShoot;

var() float m_DistanceToLookForCoverSlot;

var() float m_MinDistanceToBeFromEnemy;
var() float m_MaxDistanceToBeFromEnemy;
var() float m_IdealDistanceToBeFromEnemy;

var() float m_MaxDistanceToMoveFromStartLoc;

var() float m_SuppressionCheckDistance;


//***********************************************************************
// Default Properties
//***********************************************************************
