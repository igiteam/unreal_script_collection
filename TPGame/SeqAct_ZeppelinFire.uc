class SeqAct_ZeppelinFire extends SequenceAction;

// Target to Fire At
var() Actor AimTarget;

// Rate of Fire
var() float RefireRate;

var() float AimAccuracyOffset;

// How long the firing lasts before weapon overheats
var() float OverheatTimeMin;
var() float OverheatTimeMax;

// Amount of Time to wait before weapon is cooled down
var() float CooldownTimeMin;
var() float CooldownTimeMax;

var() int BulletDamage;
var() float MomentumTransfer;

// Used for Tweaking
var() vector TracerDrawScale;
var() float TracerSpeed;

var() class<DamageType> DamageType;

