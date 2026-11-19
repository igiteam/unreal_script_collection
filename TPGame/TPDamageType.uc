//=============================================================================
// ExampleDamageType derives from DamageType, the base class of all damagetypes.
// this and its subclasses are never spawned, just used as information holders
// Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class TPDamageType extends DamageType
	abstract
	config(Game);

//these values should overlap slightly for best results
//check order is for power, then medium, then weak.
var config float PowerMin;
var config float PowerMax;
var config float MediumMin;
var config float MediumMax;
var config float WeakMin;
var config float WeakMax;
var config TPPawn.eKillAnimIntensity KillAnimDefault;

//
// Damage type sample class to show how forcefeedback can be hooked in
//

