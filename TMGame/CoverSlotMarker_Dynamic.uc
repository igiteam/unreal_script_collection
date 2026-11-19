/**
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */


class CoverSlotMarker_Dynamic extends CoverSlotMarker
	native(TG);

native simulated function InitializeDynamicMantleSpec(class<MantleReachSpec> SpecClass = class'MantleReachSpec');

native simulated function SetMaxPathSize(float Radius, float Height);

native simulated protected function RefreshOctreePosition();

simulated event string GetDebugAbbrev()
{
	return "DynCSM";
}

