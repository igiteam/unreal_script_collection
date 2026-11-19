/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_HitReaction_CanEndMoveEarlyWithInput extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() 
	{ 
		return TEXT("CanEndMoveEarlyWithInput"); 	
	}

	virtual FColor GetEditorColor() { return FColor(64,64,255); }
}




event Notify( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;

	NP = NanoPawn(Owner);
	if( NP != None )
	{
		if( NSM_Melee_HitReaction(NP.ActiveSpecialMove) != None )
		{
			NSM_Melee_HitReaction(NP.ActiveSpecialMove).bCanEndMoveEarlyWithInput = TRUE;
		}
	}

}




defaultproperties
{

}