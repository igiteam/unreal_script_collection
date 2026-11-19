/**
 * So this class is our "brain" for determine what kind of melee attack state to be in.

 *
 *
 *
 *

 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreat_Grabber_Melee extends NanoAIAction_EngageThreat_Trooper_Melee within NanoAI_Trooper;




DefaultProperties
{
	ListOfCmdsCanDo.Empty()

	ListOfCmdsCanDo.Add(class'NanoAICmd_Grabber_Melee_Engage')

}
