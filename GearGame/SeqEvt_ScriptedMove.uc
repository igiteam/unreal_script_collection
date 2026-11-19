/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqEvt_ScriptedMove extends SeqEvt_Interaction;


/************************************************************************/
/* Enums, consts, structs, etc.                                         */
/************************************************************************/
enum EEngageEventOutputType
{
	eSCRIPTOUT_Started,
	eSCRIPTOUT_LoopStart,
	eSCRIPTOUT_Ending,
	eSCRIPTOUT_Finished,
};

simulated function bool CanDoInteraction(GearPC PC)
{
	return (Super.CanDoInteraction(PC) && PC.CanDoSpecialMove(SM_ScriptedMove));
}

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Scripted Move"

	MaxTriggerCount=0
	ReTriggerDelay=0.0f
	bPlayerOnly=false

	OutputLinks(eSCRIPTOUT_Started)=(LinkDesc="Started")
	OutputLinks(eSCRIPTOUT_LoopStart)=(LinkDesc="Loop Start")
	OutputLinks(eSCRIPTOUT_Ending)=(LinkDesc="Ending")
	OutputLinks(eSCRIPTOUT_Finished)=(LinkDesc="Finished")
}
