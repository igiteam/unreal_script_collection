
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnimNotify_ToggleSkelControl extends AnimNotify
	native(TGAnim);

struct native CtrlInfo
{
	var()	Name	ControlName;
	var()	Name	SeqNodeName;
};

var()	bool			bTurnOn;
var()	float			BlendTime;

var()	Array<CtrlInfo>	Controls;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

