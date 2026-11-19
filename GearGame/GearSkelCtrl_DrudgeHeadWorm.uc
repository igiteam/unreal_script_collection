/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * conforms the drudge head worm to the world
 */
class GearSkelCtrl_DrudgeHeadWorm extends GearSkelCtrl_NavMeshConformedTail
	native(Anim);

defaultproperties
{
	TailBones(0)=(BoneName=Drudge_HeadWorm_Spine_8, ForwardAxis=AXIS_X, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=TRUE)
	TailBones(1)=(BoneName=Drudge_HeadWorm_Spine_7, ForwardAxis=AXIS_X, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=TRUE)
	TailBones(2)=(BoneName=Drudge_HeadWorm_Spine_6, ForwardAxis=AXIS_X, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=TRUE)
	TailBones(3)=(BoneName=Drudge_HeadWorm_Spine_5, ForwardAxis=AXIS_X, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=TRUE)
	TailBones(4)=(BoneName=Drudge_HeadWorm_Spine_4, ForwardAxis=AXIS_X, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=TRUE)
	TailBones(5)=(BoneName=Drudge_HeadWorm_Spine_3, ForwardAxis=AXIS_X, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=TRUE)
	TailBones(6)=(BoneName=Drudge_HeadWorm_Spine_2, ForwardAxis=AXIS_X, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=TRUE)
	TailBones(7)=(BoneName=Drudge_HeadWorm_Spine_1, ForwardAxis=AXIS_X, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=TRUE)
	TailBones(8)=(BoneName=Drudge_HeadWorm_Pelvis, ForwardAxis=AXIS_X, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=TRUE)

	// since Z is down, it will invert
	DownCheckOffset=75.0
	//bDrawDebug = TRUE
	bUseHitLocation = TRUE

	DownExtent=(X=20,Y=20,Z=10)

	bRootUpInverted = TRUE
}
