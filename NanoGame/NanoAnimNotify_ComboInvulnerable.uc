/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_ComboInvulnerable extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() { return TEXT("COM_INVULN"); }
	virtual FColor GetEditorColor() { return FColor(64,255,64); }
}

event Notify( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;

	NP = NanoPawn(Owner);
	if( NP != None )
	{
		NP.bPawnInvulnerable = TRUE;
	}
}

event NotifyEnd( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;

	NP = NanoPawn(Owner);
	if( NP != None )
	{
		NP.bPawnInvulnerable = FALSE;
	}
}

defaultproperties
{
}