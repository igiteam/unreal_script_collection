
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnimMetaData_OneHandIK extends AnimMetaData_SkelControl
	native(Anim);

cpptext
{
	virtual UBOOL ShouldCallSkelControlTick(USkelControlBase* SkelControl, UAnimNodeSequence* SeqNode);
}

defaultproperties
{
	SkelControlNameList.Empty
	SkelControlNameList.Add("IKBone_RightHand")
	SkelControlNameList.Add("IKBone_LeftHand")
}