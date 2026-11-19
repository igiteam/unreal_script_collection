class SeqAct_AttachNPCToAPC_Gun extends SeqAct_AttachToActor;

var() bool bAllowTheGunnerToBeTargetedByOtherNPCs;
var() bool bHideNPCsWeapon;

var() float TurretSpeed, TurretProjectileSpeed, TurretProjectileDamage,	TurretProjectileMomentum;
var() float FireCooldown, OverheatTime,	OverheatCoolDownTime;
var() float AimAccuracyOffset;

