
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_ComboMoveInterrupt extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() { return bAllowMoveInterupt ? TEXT("COM_YESMOVE") : TEXT("COM_NOMOVE"); }
	virtual FColor GetEditorColor() { return FColor(64,255,64); }
}

var() bool bAllowMoveInterupt;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local NanoPawn NP;
	local NanoWeap_Melee Weap;

	NP = NanoPawn(Owner);
	if(NP != None)
	{
		Weap = NanoWeap_Melee(NP.Weapon);
		if( Weap != None )
		{
			Weap.AnimNotify_HandleMoveInterupt(bAllowMoveInterupt);
		}
	}
}

defaultproperties
{
}