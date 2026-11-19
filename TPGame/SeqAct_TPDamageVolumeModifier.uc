class SeqAct_TPDamageVolumeModifier extends SequenceAction;

var() array<class<Actor> > ExemptActorClasses;

var() float             DamageAmount;
var() float             DamageTimeSeconds;
var() class<DamageType>	DamageType;

var() float             MovementDamageAmount;
var() float             MovementDamageDistance;
var() class<DamageType>	MovementDamageType;

