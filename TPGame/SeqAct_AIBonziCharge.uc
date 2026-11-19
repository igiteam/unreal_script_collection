//***********************************************************************
// Class:		 SeqAct_AIBonziCharge
// Description:  Starts a NPC on killing charge
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  
//***********************************************************************
class SeqAct_AIBonziCharge extends SeqAct_Latent;


//***********************************************************************
// Variable Declaration
//***********************************************************************
// current enemy
var() bool m_UseAgainstCurrentEnemy;

// speed factor
var() float m_SpeedFactorForCharge;

// Fire During Charge
var() bool m_bFireDuringCharge;

// grenade suicide
var() bool m_bGrenadeSuicideAtEndOfCharge;

// War Cry at start
var() bool m_bWarCryAtStart;

// War cry at end
var() bool m_bWarCryAtEnd;

// War cry for whole charge
var() bool m_bWarCryDurringCharge;

// Dist to boom is gren suicide
var() float m_DistToBoomForSuicide;


//***********************************************************************
// Default Properties
//***********************************************************************
