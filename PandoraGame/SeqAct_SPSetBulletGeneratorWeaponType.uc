class SeqAct_SPSetBulletGeneratorWeaponType extends SequenceAction;

var() /*0x80000000-0x00000000*/ class<Inventory> WeaponType;
var() float IntervalOfAutoFire;
var() float IntervalOfAutoFireRange;
var() float IntervalBetweenAutoFireSegments;
var() float IntervalBetweenAutoFireRange;
var() float IntervalBetweenSingleFireSegments;
var() float IntervalBetweenSingleFireRange;
var() float SoundMultiplier;
var() bool m_bOverrideFiringSound;
var() bool bCollisionOn;
var() bool m_bUseRandomizedWeapons;
var() bool m_bRocketsHoming;
var() SoundCue m_FiringSound;
var() /*0x80000000-0x00000000*/ class<Inventory> RandomWeaponType1;
var() /*0x80000000-0x00000000*/ class<Inventory> RandomWeaponType2;
var() /*0x80000000-0x00000000*/ class<Inventory> RandomWeaponType3;
var() /*0x80000000-0x00000000*/ class<Inventory> RandomWeaponType4;
