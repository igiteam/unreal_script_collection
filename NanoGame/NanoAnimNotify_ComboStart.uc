
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_ComboStart extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() { return TEXT("COMBO"); }
	virtual FColor GetEditorColor() { return FColor(64,64,255); }
}

event Notify( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;
	local NanoWeap_Melee Sword;

	NP = NanoPawn(Owner);
	if(NP != None)
	{
		Sword = NanoWeap_Melee(NP.Weapon);
		if(Sword != None)
		{
			Sword.ComboWindowOpen();
		}
	}
}

event NotifyEnd( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;
	local NanoWeap_Melee Sword;

	NP = NanoPawn(Owner);
	if( NP != None )
	{
		Sword = NanoWeap_Melee(NP.Weapon);
		if(Sword != None)
		{
			Sword.ComboWindowClose();
		}
	}
}



defaultproperties
{
}