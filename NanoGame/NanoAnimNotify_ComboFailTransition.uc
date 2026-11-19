
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_ComboFailTransition extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() { return TEXT("COM_FAIL"); }
	virtual FColor GetEditorColor() { return (bAllowComboTransDuringRecovery ? FColor(64,255,64) : FColor(255,64,64)); }
}

/** Whether a combo input during the recovery period will allow an instant transition */
var() bool bAllowComboTransDuringRecovery;

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
			Weap.ComboFailTransition( bAllowComboTransDuringRecovery );
		}
	}
}

defaultproperties
{
	bAllowComboTransDuringRecovery=TRUE
}