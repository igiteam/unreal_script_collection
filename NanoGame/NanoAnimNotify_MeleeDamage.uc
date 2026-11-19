/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimNotify_MeleeDamage extends AnimNotify_Trails
	native(Anim);
	
/** What type of impacts this MeleeDamage is.  This allows to have different sounds and effects based off a hit. **/
var() EMeleeImpactType MeleeImpactType;

var() Byte ReactionID;      


cpptext
{
	virtual FString GetEditorComment() { return TEXT("DAM"); }
	virtual FColor GetEditorColor() { return FColor(255,64,64); }

	virtual AActor* GetNotifyActor(class UAnimNodeSequence* NodeSeq);
}

defaultproperties
{
	SampleTimeStep=0.016f
	bSkipIfOwnerIsHidden=FALSE
}