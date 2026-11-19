/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_OrbitalBotBase extends NanoPawn_MetaCorp_MechsBase
	abstract;


/** Whether primary laser is firing */
var() bool bPrimaryLaserFiring;
/** Offset of laser start impact */
var() Vector	PrimaryLaserStartOffset;
/** Offset of laser end impact */
var() Vector	PrimaryLaserEndOffset;
/** Amount of time laser was set to fire */
var() float		PrimaryLaserFireTime;
/** Amount of time remaining in laser firing */
var() float		PrimaryLaserFireTimeRemaining;

/** Name of the bone that fires the primary laser */
var() Name		PrimaryLaserBoneName;


function Init();


defaultproperties
{

}