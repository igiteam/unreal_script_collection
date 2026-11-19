/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoVolume_Dust extends BlockingVolume
	native;


/**
 * This is the sound that will play when you pass through this object.
 * 
 **/
var() SoundCue MovingThroughSound;



cpptext
{
	virtual UBOOL IgnoreBlockingBy( const AActor *Other) const;
	virtual UBOOL ShouldTrace(UPrimitiveComponent* Primitive,AActor *SourceActor, DWORD TraceFlags);
};

defaultproperties
{
	MovingThroughSound=SoundCue'Gameplay_Audio.Dusting.Dusting_Fence_Stereo_01Cue'

	bWorldGeometry=FALSE

	bColored=TRUE
	BrushColor=(R=60,G=255,B=200,A=255)

	Begin Object Name=BrushComponent0
		RBChannel=RBCC_Untitled2
	End Object

};