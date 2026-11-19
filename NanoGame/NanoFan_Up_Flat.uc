/**
 * This class must be used for our Fan Volumes so we can modifiy it later
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoFan_Up_Flat extends NanoFan_Up;


defaultproperties
{

	Begin Object Name=OuterMetalRingComp
		StaticMesh=StaticMesh'NYC_Deco_Rooftops02_01.SM.Mesh.S_0096_FanHolder_01'
		Materials(0)=MaterialInstanceConstant'Nano_Blockbuster.Materials.MI_BlockbusterSkin_LaunchFan'
	End Object

	Begin Object Name=SpinningFanComp0
		StaticMesh=StaticMesh'NYC_Deco_Rooftops02_01.SM.Mesh.S_0096_FanHolder_01_Fan'
 	    Rotation=(Roll=0)
		Scale3D=(X=1.0f,Y=1.0f,Z=1.0f)
		Translation=(Z=46)

		LightEnvironment=MyLightEnvironment
	End Object

	Begin Object Name=StaticMeshCollisionVolumeComp
		Translation=(Z=94.0)
	End Object

	Begin Object Name=PlumeComp
		Translation=(Z=94.0)
		Scale=0.80f
	End Object
}