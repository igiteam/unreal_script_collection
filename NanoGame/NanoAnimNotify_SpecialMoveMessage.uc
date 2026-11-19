
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_SpecialMoveMessage extends AnimNotify_Scripted
	native(Anim);

/** Named message to pass to the active special move */
var() Name  MessageName;

cpptext
{
	virtual FString GetEditorComment() { return TEXT("SM_MES"); }
	virtual FColor GetEditorColor() { return FColor(255,64,255); }
}

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local NanoPawn NP;

	NP = NanoPawn(Owner);
	if(NP != None && NP.ActiveSpecialMove != None )
	{
		NP.ActiveSpecialMove.MessageEvent(MessageName, NP);
	}
}

defaultproperties
{
}