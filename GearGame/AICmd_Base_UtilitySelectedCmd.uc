/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
* base class for AI commands which are selected an run based on a selector or utility function  
*
*/
class AICmd_Base_UtilitySelectedCmd extends AICommand;

/**
 * static function called to initiate a command of this class 
 * @param Controller - the controller we're pushing this command onto
 * @param MetaData - meta data associated with the selection of this command
 */
static function bool InitUtilitySelectedCommand(GearAI Controller, UtilBasedAICmdMetaDataPacket MetaData)
{
	// update meta data
	MetaData.LastActivationTime = Controller.WorldInfo.TimeSeconds;
	MetaData.NumberOfActivations++;

	return InitCommand(Controller);
}

/**
 * this function will be called to evaluate whether or not this command should be activated 
 * @param ActivationData - the meta data packet for this command activation history, etc..
 * @return - float indicating the utility value of activation this action right now (-1 means not suitable to activate)
 */
static function float EvaluateActivation( GearAI AI, UtilBasedAICmdMetaDataPacket ActivationData ){return 0.f;}

