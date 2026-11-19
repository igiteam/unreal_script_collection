//***********************************************************************
// Class:		 SeqAct_AIWander
// Description:  
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes:  
//***********************************************************************
class SeqAct_AIWander extends SeqAct_Latent;


//***********************************************************************
// Variable Declaration
//***********************************************************************
/** Should this move be interruptable? */
var() float MinTimeToWanderInSeconds;
var() float MaxTimeToWanderInSeconds;
var() float SpeedFactorToWanderAt;

//***********************************************************************
// CPP Text
//***********************************************************************


//***********************************************************************
// Default Properties
//***********************************************************************
