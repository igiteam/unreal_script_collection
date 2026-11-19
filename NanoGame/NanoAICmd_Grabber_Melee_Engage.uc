/**
 * I am engaged with the FireTarger and choosing what action to do to attack them 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Grabber_Melee_Engage extends NanoAICmd_Trooper_Melee_Engage within NanoAI_Trooper
	config(AI);



defaultproperties
{
	ListOfCmdsCanDo.Empty()

	// I think this is all this guy does.  He doesn't stand around.  He just ruuuunnnss in and tries to grab

	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Melee_MoveInRange')

	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Attack_Grab_Always')

}
