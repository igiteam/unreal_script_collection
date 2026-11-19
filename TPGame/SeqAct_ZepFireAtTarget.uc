/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ZepFireAtTarget extends SequenceAction
	native;

var() float TurretProjectileSpeed;
var() float TurretProjectileDamage;
var() float TurretProjectileMomentum;
var() float TurretFireInterval;
var() float OverheatTimeMin;
var() float OverheatTimeMax;
var() float CoolDownTimeMin;
var() float CoolDownTimeMax;


/**
 * Determines whether this class should be displayed in the list of available ops in the UI's kismet editor.
 *
 * @param	TargetObject	the widget that this SequenceObject would be attached to.
 *
 * @return	TRUE if this sequence object should be available for use in the UI kismet editor
 */
event bool IsValidUISequenceObject( optional UIScreenObject TargetObject )
{
	return true;
}


native function float GetOverheatTime();
// {
//     return OverheatTimeMin + frand()*(OverheatTimeMax-OverheatTimeMin);
// }

native function float GetCooldownTime();
// {
//     return CooldownTimeMin + frand()*(CooldownTimeMax-CooldownTimeMin);
// }

