/**
 * SeqAct_GearUnlockableUnlock - Kismet action that allows unlockables to be unlocked
 * by events that occur in levels.  This action will attempt to unlock the unlockable
 * for all players.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_GearUnlockableUnlock extends SequenceAction
	native(Sequence);

cpptext
{
	virtual void Activated();
	virtual void Serialize( FArchive& Ar );
}

/** Enum of the achievements to be unlocked by events that occur in levels */
enum EGearLevelUnlockable
{
	eGLUNLOCK_Character_Dizzy,
	eGLUNLOCK_Character_Kantus,
	eGLUNLOCK_Character_Tai,
	eGLUNLOCK_Character_PalaceGuard,
	eGLUNLOCK_Character_Skorge,
	eGLUNLOCK_Character_DLC1,
	eGLUNLOCK_Character_DLC2,
	eGLUNLOCK_Character_DLC3,
	eGLUNLOCK_Character_DLC4,
	eGLUNLOCK_Character_DLC5,
};

/** The unlockable you'd like to unlock */
var deprecated EGearLevelUnlockable Unlockable;
var() int UnlockableNum;


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
	ObjName="Unlockable Unlock"
	ObjCategory="Gear"

	InputLinks(0)=(LinkDesc="Unlock")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target",PropertyName=Targets,bHidden=TRUE)
}
