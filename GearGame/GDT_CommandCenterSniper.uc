/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_CommandCenterSniper extends GDT_SniperRifle
	abstract;

static function bool ShouldCheckHeadShot(Controller InstigatedBy)
{
	return true;
}
