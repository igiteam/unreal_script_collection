/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_DodgeTransition extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() 
	{ 
		return TEXT("DODGE_TRANS"); 
	}
	
	virtual FColor GetEditorColor() { return FColor(64,64,255); }
}

event Notify( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;
	NP = NanoPawn(Owner);
	if( NP != None && NP.bDodging )
	{
		NP.bRecoveringFromDodge = TRUE;
	}
}

defaultproperties
{
}