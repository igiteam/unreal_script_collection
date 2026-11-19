/**
 * This class must be used for our Fan Volumes so we can modifiy it later
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoFan_Up extends NanoFanBase;


defaultproperties
{
	bAbleToGhostThroughBase=FALSE

	Begin Object Name=OuterMetalRingComp
		StaticMesh=StaticMesh'Nano_Proto_Fan.SM.Mesh.S_Proto_FanHolder'
	End Object

	Begin Object Name=SpinningFanComp0
		StaticMesh=StaticMesh'MET_Buildings_02.SM_MET_Building_03_Fan'
	End Object


}