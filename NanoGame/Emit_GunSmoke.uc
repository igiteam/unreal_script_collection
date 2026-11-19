/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Emit_GunSmoke extends SpawnedNanoEmitter;


var() protected const class<NanoFogVolume_GunSmoke> FogVolumeClass;
var protected transient NanoFogVolume_GunSmoke FogVolume;


simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		FogVolume = Spawn(FogVolumeClass,,,, rot(0,0,0));
		`log( "shiiit" @ FogVolume );
	}
}



defaultproperties
{
	FogVolumeClass=class'NanoFogVolume_GunSmoke'
}