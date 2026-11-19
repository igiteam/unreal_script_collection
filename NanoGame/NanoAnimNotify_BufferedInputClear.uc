/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimNotify_BufferedInputClear extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() { return TEXT("BUFFERED CLEAR"); }
	virtual FColor GetEditorColor() { return FColor(64,64,255); }
}


event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local NanoPawn NP;
	local NanoWeap_Melee Weap;

	NP = NanoPawn(Owner);
	if( NP != None )
	{
		Weap = NanoWeap_Melee(NP.Weapon);
		if( Weap != None )
		{
			Weap.BufferedInputClear();
		}
	}
}

defaultproperties
{

}