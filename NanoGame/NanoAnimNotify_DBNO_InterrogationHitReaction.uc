/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimNotify_DBNO_InterrogationHitReaction extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() 
	{ 
		return TEXT("InterrogationHitReaction"); 
	}

	virtual FColor GetEditorColor() { return FColor(255,64,64); }
}


event Notify( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;
	local NSM_DBNO_InteractionEnemyBase NSM_Interrogate;

	NP = NanoPawn(Owner);

	if( NP != None )
	{
		NSM_Interrogate = NSM_DBNO_InteractionEnemyBase(NP.ActiveSpecialMove);

		if( NSM_Interrogate != None )
		{
			NSM_Interrogate.HandleNanoAnimNotify_DBNO_InterrogationHitReaction();
		}
	}
}

defaultproperties
{
}


