/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_ComboInterruptable extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() { return TEXT("COM_NOINTERUPT"); }
	virtual FColor GetEditorColor() { return FColor(64,255,64); }
}

/** Priorty of attack to prevent (0 == lowest priority) */
var() byte InterruptPriority;

event Notify( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;

	NP = NanoPawn(Owner);
	if( NP != None )
	{
		NP.bDoNoHitReaction = TRUE;
		NP.NoHitReactionPriority = InterruptPriority;
	}
}

event NotifyEnd( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;

	NP = NanoPawn(Owner);
	if( NP != None )
	{
		NP.bDoNoHitReaction = FALSE;
		NP.NoHitReactionPriority = 0;
	}
}

defaultproperties
{
}