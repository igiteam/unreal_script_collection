/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_ComboSlomo extends AnimNotify_Scripted
	native(Anim);

cpptext
{
	virtual FString GetEditorComment() 
	{ 
		if( SlomoVal < 1.f )
		{
			return TEXT("COM_SLOMO"); 
		}
		else if( SlomoVal > 1.f )
		{
			return TEXT("COM_FASTMO"); 
		}
		else
		{
			return TEXT("COM_REGMO"); 
		}
	}
	
	virtual FColor GetEditorColor() { return FColor(64,64,255); }
}

var() float SlomoVal;

event Notify( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;
	local NanoWeap_Melee Sword;

	NP = NanoPawn(Owner);
	if(NP != None)
	{
		Sword = NanoWeap_Melee(NP.Weapon);
		if(Sword != None)
		{
			Sword.ComboSlomo( SlomoVal );
		}
	}
}

defaultproperties
{
	SlomoVal=1.f
}