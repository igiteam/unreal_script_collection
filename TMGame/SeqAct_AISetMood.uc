/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AISetMood extends SequenceAction;

var() EPerceptionMood	PerceptionMood;
var() ECombatMood		CombatMood;
var() EAIMoveMood		MoveMood;

var() float				UnawareSightRadius;
var() float				UnawareHearingThreshold;
var() float             UnawareMinEnemySeenTime;
var() float             UnawarePeripheralVision;
var() float             UnawareNotifyTakeDamage;

