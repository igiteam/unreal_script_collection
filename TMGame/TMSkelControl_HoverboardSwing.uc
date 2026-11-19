/**
 *	Controller used by hoverboard for moving lower part in response to wheel movements.
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSkelControl_HoverboardSwing extends SkelControlSingleBone
	hidecategories(Translation,Rotation)
	native(Animation);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var()	int				SwingHistoryWindow;
var		int				SwingHistorySlot;
var		array<float>	SwingHistory;
var()	float	SwingScale;
var()	float	MaxSwing;
var()	float	MaxUseVel;
var		float	CurrentSwing;

