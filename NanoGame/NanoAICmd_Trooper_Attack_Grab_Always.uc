/** 
 * AI Command that handles melee grab attack
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAICmd_Trooper_Attack_Grab_Always extends NanoAICmd_Trooper_Attack_Grab within NanoAI_Trooper
	config(AI);




defaultproperties
{
	GrabDotThresh=-1.f
	MinNumAttackerRequiredToGrab=0
}