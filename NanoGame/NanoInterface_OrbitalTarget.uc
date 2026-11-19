/**
 *	Implemented by things that can be affected by your nano powers
 *
 *	Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_OrbitalTarget extends Interface
	native;


/** This will activate orbital attractors on this target. **/
simulated function ActivateOrbitalAttractors();

/** This will deactivate orbital attractors on this target. **/
simulated function DeactivateOrbitalAttractors();

/** This is needed to find the location of this OrbitalTarget **/
simulated event vector GetOrbitalTargetLocation();

/** Each Orbital target will have different valid damage distances. **/
simulated event float GetDistanceForDamage();

/** How many orbitals need to be touching this pawn for damage to occur (where touching is being within range **/
simulated event int GetNumOrbitalsTouchingForDamage();