/**
 * This just holds all of the challenge data.
 *
 * Nice to have a separtion of the Manager and data
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoChallenges extends Object
	config(Game)
	abstract
	notplaceable;



var const config array<ChallengeDatum> TheChallenges;

var const config array<AssuranceGameDatum> AssuranceGames;



defaultproperties
{

}