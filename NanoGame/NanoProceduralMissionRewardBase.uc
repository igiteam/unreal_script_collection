/**
 * This is given to an actor sich that when they are killed you will get the reward.
 * 
 * Most things seem to revolve around punking some foe down so this it really easy for Foes to
 * now have an additional reward.
 * 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoProceduralMissionRewardBase extends Actor
	abstract
	config(Game);


/** Amount of experience the player will get. **/
var config int Experience;

/** Amount of currency the player will get. **/
var config int Currency;

/** Amount of rebel mind share player will get. **/
var config int AmountOfRebelMindShare;


defaultproperties
{
}