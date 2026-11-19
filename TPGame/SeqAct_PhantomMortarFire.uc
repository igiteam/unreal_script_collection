class SeqAct_PhantomMortarFire extends SequenceAction;

// Target to Fire At
var() array<Actor> AimTargets;

// Rate of Fire
var() float FireRate;

var() int ShellDamage;
var() float MomentumTransfer;

var() class<DamageType> DamageType;

