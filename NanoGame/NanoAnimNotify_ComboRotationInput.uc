
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_ComboRotationInput extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() { return bAllowInput ? TEXT("COM_YESROT") : TEXT("COM_NOROT"); }
	virtual FColor GetEditorColor() { return FColor(64,64,255); }
}

var() bool bAllowInput;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local NanoPawn NP;
	local NanoWeap_Melee Sword;

	NP = NanoPawn(Owner);
	if(NP != None)
	{
		Sword = NanoWeap_Melee(NP.Weapon);
		if( Sword != None )
		{
			Sword.AnimNotify_HandleRotationInput(bAllowInput);
		}
	}
}

defaultproperties
{
}