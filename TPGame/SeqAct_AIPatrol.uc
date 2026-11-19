//***********************************************************************
// Class:		 SeqAct_AIPatrol
// Description:  Move along a track
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  
//***********************************************************************
class SeqAct_AIPatrol extends SeqAct_Latent;


//***********************************************************************
// Variable Declaration
//***********************************************************************
var() array<Actor> Track;
var() bool bLoopTrack;
var() float MinTimeToPatrolInSeconds;
var() float MaxTimeToPatrolInSeconds;
var() float SpeedFactorWhilePatrolling;
var() bool	bDisplayPatrolTrack;
var() color DisplayPatrolTrackColor;





//***********************************************************************
// CPP Text
//***********************************************************************


//***********************************************************************
// Default Properties
//***********************************************************************
