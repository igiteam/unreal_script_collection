/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * conforms the serapede's tail to the world
 */
class GearSkelCtrl_Serapede extends GearSkelCtrl_NavMeshConformedTail
	native(Anim);

defaultproperties
{
	// note: segment 00 is actually a child of Segment01 in the bone hierarchy, and so on
	TailBones(0)=(BoneName=Segment00, bDontAdjustThisBoneWhenMagicToggleIsOn=TRUE, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(1)=(BoneName=Segment01, bDontAdjustThisBoneWhenMagicToggleIsOn=TRUE, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(2)=(BoneName=Segment02, bDontAdjustThisBoneWhenMagicToggleIsOn=TRUE, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(3)=(BoneName=Segment03, bDontAdjustThisBoneWhenMagicToggleIsOn=TRUE, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(4)=(BoneName=Segment04, bDontAdjustThisBoneWhenMagicToggleIsOn=TRUE, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(5)=(BoneName=Segment05, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(6)=(BoneName=Segment06, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(7)=(BoneName=Segment07, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(8)=(BoneName=Segment08, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(9)=(BoneName=Segment09, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(10)=(BoneName=Segment10, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(11)=(BoneName=Segment11, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)
	TailBones(12)=(BoneName=Segment12, ForwardAxis=AXIS_Y, bForwardInverted=FALSE, UpAxis=AXIS_Z, bUpInverted=FALSE)

	//bDrawDebug=TRUE
	DownExtent=(X=20,Y=20,Z=20)
	// do not want any interp because it has big issue whenever mantle over
	// it will keep distance to previous segment
	//HeightInterpSpeed=100

	DownCheckOffset=100.0
}
