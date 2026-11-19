class SeqAct_InitiateDestruction extends SequenceAction
    native;

/** Type of damage to apply */
var() class<DamageType>		DamageType;

/** Amount of momentum to apply */
var() float					Momentum;

/** player that should take credit for the damage (Controller or Pawn) */
var Actor Instigator;
    
//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

