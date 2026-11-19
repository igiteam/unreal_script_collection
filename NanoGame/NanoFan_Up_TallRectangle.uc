/**
 * This class must be used for our Fan Volumes so we can modifiy it later
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoFan_Up_TallRectangle extends NanoFan_Up;


defaultproperties
{

	Begin Object Name=OuterMetalRingComp
		StaticMesh=StaticMesh'NYC_Deco_Rooftops02_01.SM.Mesh.S_0384_AC_01'
	End Object

	Begin Object Name=SpinningFanComp0
		Rotation=(Roll=0)
		Scale3D=(X=1.0f,Y=1.0f,Z=1.0f)

		StaticMesh=StaticMesh'NYC_Deco_Rooftops02_01.SM.Mesh.S_0096_FanHolder_01_Fan'
		Scale=0.8f
		Translation=(Z=340)
	End Object


	Begin Object Name=StaticMeshCollisionVolumeComp
		Translation=(Z=385.0)
	End Object

	Begin Object Name=PlumeComp
		Translation=(Z=385.0)
		Scale=0.65f
	End Object

}