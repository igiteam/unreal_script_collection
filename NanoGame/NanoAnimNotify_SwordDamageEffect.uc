/**
 * NOTE: We can subclass  AnimNotify_PlayParticleEffect and have a reference to: PSTemplate as that
 * will be the particle effect we actually use commonly across mobs.
 *
 *
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimNotify_SwordDamageEffect extends AnimNotify_PlayParticleEffect
	native(Anim);

cpptext
{
	// AnimNotify interface.
	virtual void Notify( class UAnimNodeSequence* NodeSeq );

	virtual FString GetEditorComment() { return TEXT("DAM_EFF"); }
	virtual FColor GetEditorColor() { return FColor(255,0,0); }
}

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local NanoPawn NP;
	local NanoWeap_Melee Sword;

	NP = NanoPawn(Owner);
	if(NP != None)
	{
		Sword = NanoWeap_Melee(NP.Weapon);
		if(Sword != None)
		{
			Sword.DoSwordDamageEffect();
		}
	}
}



defaultproperties
{
}