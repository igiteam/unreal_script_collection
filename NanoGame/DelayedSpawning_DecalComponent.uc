/**
 * This is just a nice way to have time delayed decal spawning without having to keep a
 * polling loop around.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class DelayedSpawning_DecalComponent extends PrimitiveComponent;


var transient DecalData DecalToSpawn;

var transient name WhereToTraceFrom;

var transient NanoPawn NP;



simulated final function DecalChoice_DelayedSpawning( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = DecalToSpawn;
}


simulated final function DecalTrace_StraightDownFromSocketOrBone( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector StartLoc;
	local vector SocketLocation;
	local rotator SocketRotation;

	// try sockets first
	if( NP.Mesh.GetSocketWorldLocationAndRotation( WhereToTraceFrom, SocketLocation, SocketRotation) == TRUE )
	{
		StartLoc = SocketLocation;
	}
	// must be a bone name
	else
	{
		StartLoc = NP.Mesh.GetBoneLocation( WhereToTraceFrom );
	}


	out_TraceStart = StartLoc;
	out_TraceDest = out_TraceStart - ( Vect(0,0,256));
}


/** This function is our "doit" function which will be called by a timer. **/
function DoDecalSpawning()
{
	// NanoGRI(WorldInfo.GRI).LeaveADecalWorld( DecalTrace_StraightDown, DecalChoice_Default, DecalTimeVaryingParams_Default, Location );

	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).LeaveADecalWorld( DecalTrace_StraightDownFromSocketOrBone,  DecalChoice_DelayedSpawning, NP.NanoPawnFX.BloodDecalTimeVaryingParams_Default );
}



defaultproperties
{

}
