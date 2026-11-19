//***********************************************************************
// Class:		 SeqAct_AITurnCoverSlotOnOff
// Description:  Enable or Disable a cover slot
// Created By:   Charles G. Hennon, Spark Unlimited 2007
//
// Implementation Nodes: 
//***********************************************************************
class SeqAct_AITurnCoverSlotOnOff extends SequenceAction;


//***********************************************************************
// Variable Declaration
//***********************************************************************
/** Should this move be interruptable? */
var() bool bEnable;
var() int SlotToToggle;

//***********************************************************************
// Default Properties
//***********************************************************************
