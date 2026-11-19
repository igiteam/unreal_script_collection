/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqEvt_KillWatch extends SeqEvt_Interaction
	native(Sequence);


/************************************************************************/
/* Enums, consts, structs, etc.                                         */
/************************************************************************/

/** Enum of the first eKILLWATCHOUT_MAX outputs that can be fired */
enum EKillWatchEventOutputType
{
	eKILLWATCHOUT_Spawn,
	eKILLWATCHOUT_Died,
};


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** List of "num kills left" values to fire outputs for */
var() array<int> KillsLeftList;
/** List of bools which will tell us if we've already triggered the KillLeftList outputs */
var array<bool> FiredKillsLeftOutputs;
/** List of Outputs for the KillsLeftList so we can match up outputs when the elements of KillsLeftList change.*/
var transient editoronly array<int> KillsLeftOutputs;

/** List of "percent kills left" values to fire outputs for */
var() array<float> PercKillsLeftList;
/** List of bools which will tell us if we've already triggered the PercKillLeftList outputs */
var array<bool> FiredPercKillsLeftOutputs;

/** List of Outputs for the PercKillsLeftList so we can match up outputs when the elements of PercKillsLeftList change.*/
var transient editoronly array<int> PercKillsLeftOutputs;

/** List of AI Factories  this action is keeping track of */
var array<SeqAct_AIFactory> FactoryList;


/************************************************************************/
/* C++ functions                                                        */
/************************************************************************/

cpptext
{
	virtual void PreEditChange( UProperty* PropertyThatWillChange );

	virtual void UpdateDynamicLinks();
	
	/** Called from an AI factory when a character spawns from it */
	void FactorySpawnedNotify();
	/** Called from an AI factory when a character dies */
	void FactoryDiedNotify();
};


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Initialize the bool arrays */
event RegisterEvent()
{
	FiredKillsLeftOutputs.length = KillsLeftList.length;
	FiredPercKillsLeftOutputs.length = PercKillsLeftList.length;
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
	ObjName="Kill Watch"

	MaxTriggerCount=0
	ReTriggerDelay=0.0f
	bPlayerOnly=false

	OutputLinks(eKILLWATCHOUT_Spawn)=(LinkDesc="Spawn")
	OutputLinks(eKILLWATCHOUT_Died)=(LinkDesc="Died")

	VariableLinks.Empty
}
