class SeqAct_DamageSquad extends SequenceAction
    native;

/** Type of damage to apply */
var() export editinline SPSquadSelector SquadType;
var() class<DamageType> DamageType;
/** Amount of momentum to apply */
var() float Momentum;
/** Amount of damage to apply */
var() float DamageAmount;
var Actor Instigator;
