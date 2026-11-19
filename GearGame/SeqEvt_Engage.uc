/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqEvt_Engage extends SeqEvt_Interaction
	native(Sequence);

/** Whether DisabledGUDEvent should be triggered if a player uses the engage trigger while we're disabled */
var() bool bPlayDisabledGUD;

/** The GUD to play when a player uses the engage trigger and we're disabled */
var() EGUDEventID DisabledGUDEvent;

/************************************************************************/
/* Enums, consts, structs, etc.                                         */
/************************************************************************/
enum EEngageEventOutputType
{
	eENGAGEOUT_InteractBegin,
	eENGAGEOUT_InteractEnd,
	eENGAGEOUT_Started,
	eENGAGEOUT_Stopped,
};

cpptext
{
	/**
	 * Allow the event to activated if not enabled, but set up to play a disabled GUD
	 *
	 * @param InOriginator - the actor that activated the engage trigger
	 * 
	 * @param InInstigator - the actor that instigated the activation
	 *
	 * @param bTest - whether this is a test activation
	 *
	 * @param ActivateIndices - which indices should be activated
	 *
	 * @param bPushTop - whether the action should be pushed to the top of the stack and executed first
	 *
	 * @return TRUE if we can be activated
	 */
	virtual UBOOL CheckActivate(AActor *InOriginator, AActor *InInstigator, UBOOL bTest=FALSE, TArray<INT>* ActivateIndices = NULL, UBOOL bPushTop = FALSE);
}

/**
 * Say we can do the interaction if we can do the engage special move.
 * Also allow it if we are going to play the disabled GUD
 * 
 * @param PC - the controller that wants to interact
 * 
 * @return TRUE if can do the interaction
 */
simulated function bool CanDoInteraction(GearPC PC)
{
	if (bPlayDisabledGUD && !bEnabled && PC.CanDoSpecialMove(SM_Engage_Start))
	{
		return TRUE;
	}

	return (Super.CanDoInteraction(PC) && PC.CanDoSpecialMove(SM_Engage_Start));
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
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Engage"

	MaxTriggerCount=0
	ReTriggerDelay=0.0f
	bPlayerOnly=false

	bPlayDisabledGUD=FALSE
	DisabledGUDEvent=GUDEvent_CoopDoorDisabled

	OutputLinks(eENGAGEOUT_InteractBegin)=(LinkDesc="Interact Begin")
	OutputLinks(eENGAGEOUT_InteractEnd)=(LinkDesc="Interact End")
	OutputLinks(eENGAGEOUT_Started)=(LinkDesc="Started")
	OutputLinks(eENGAGEOUT_Stopped)=(LinkDesc="Stopped")

	InteractAction={(
		ActionName=WheelGrab,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // X Button
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=109,V=429,UL=68,VL=71)))	),
	)}
}
