/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_RagdollTransition extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() { return TEXT("RAG_TRANS"); }
	virtual FColor GetEditorColor() { return FColor(64,255,64); }
}

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local NanoPawn NP;
	NP = NanoPawn(Owner);
	if(NP != None)
	{

	}
}


defaultproperties
{
}