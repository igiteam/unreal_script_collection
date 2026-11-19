
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_AttackRecover_AllowLeftStickInput extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() { return TEXT("AllowLeftStickInput"); }
	virtual FColor GetEditorColor() { return FColor(255,0,0); }
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
			`log( "ZOOOOOPPPPP NanoAnimNotify_AttackRecover_AllowLeftStickInput" );
			Weap.AnimNotify_HandleMoveInterupt( TRUE );
		}
	}
}



defaultproperties
{
}