/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTPlayAnimNode extends OLBTNode
	native(AI);

struct native AnimData
{
	var() name AnimName;
	var() float Weight;
	var() float Rate;
	var() float BlendInTime;
	var() float BlendOutTime;
	var() float StartTime;
	var() float EndTime;

	structdefaultproperties
	{
		Weight=1.0f
		Rate=1.0f
		BlendInTime=0.2f
		BlendOutTime=0.2f
		StartTime=0.0f
		EndTime=0.0f
	}
};

var() array<AnimData> Animations;

var() bool bLoop;

defaultproperties
{
	TaskType=class'OLBTPlayAnimTask'

	bLoop=false
}
