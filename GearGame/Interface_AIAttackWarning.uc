/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface Interface_AIAttackWarning;

/**
 * Allows pawn to warn enemy AI of its incoming attack.
 * Works with AIReactCond_EnemyAttack
 *
 * @return - Location that the attack will occur
 */
function vector GetWarnAttackLocation(); 

/**
 * Allows attacking pawn to suggest an evade direction based on its attack type
 *
 * @return - Evade direction
 */
function ESpecialMove GetEnemyEvadeDir();
