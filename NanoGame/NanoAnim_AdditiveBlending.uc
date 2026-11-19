
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAnim_AdditiveBlending extends AnimNodeAdditiveBlending
	native(Anim);

/** Cached ref to NanoPawn Owner */
var protected transient NanoPawn	NanoPawnOwner;

cpptext
{
	virtual void InitAnim(USkeletalMeshComponent* meshComp, UAnimNodeBlendBase* Parent);
	virtual void TickAnim(FLOAT DeltaSeconds);
}

defaultproperties
{
	BlendType=ABT_EaseInOutExponent3
}