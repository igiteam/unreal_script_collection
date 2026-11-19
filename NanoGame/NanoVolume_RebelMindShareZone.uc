/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoVolume_RebelMindShareZone extends Volume
	native
	placeable;


var transient NanoRebelMindShareZoneInfo MyNanoRebelMindShareZoneInfo;

/** Whether or not this Volume should actually affect chaos.  Some places we want to not actually affect chaos but still be part of a ChaosZoneInfo. **/
var() bool bShouldAffectRebelMindShare;

event PostBeginPlay()
{
	local Actor A;

	Super.PostBeginPlay();

	// call touch on all things inside this NanoVolume_ChaosZone
	ForEach TouchingActors(class'Actor', A)
	{	
		Touch(A, None, A.Location, Vect(0,0,1) );
	}
}


event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local NanoInterface_CanAffectRebelMindShare ChaosAffector;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

    //`log( "Touched" @ Other );
	ChaosAffector = NanoInterface_CanAffectRebelMindShare(Other);
	if( ChaosAffector != None )
	{
		//`log( "    set zone!!! on" @ Other );
		ChaosAffector.SetRebelMindShareZone( self );
	}
}


// this doesn't seem to get called
event UnTouch(Actor Other)
{
	local NanoInterface_CanAffectRebelMindShare ChaosAffector;

	Super.UnTouch(Other);

    //`log( "unTouched" @ Other );

	ChaosAffector = NanoInterface_CanAffectRebelMindShare(Other);

	// if we just untouched this zone and the pawn is pointing to us.  We need to check self here as the touch untouch order
	// could be flipped
	if( ( ChaosAffector != None ) && ( ChaosAffector.GetRebelMindShareZone() == self ) )
	{
		ChaosAffector.SetRebelMindShareZone( none );
	}
}



defaultproperties
{
	TickGroup=TG_DuringAsyncWork

	//bWorldGeometry=FALSE
	bShouldAffectRebelMindShare=TRUE

	bColored=TRUE
	BrushColor=(R=255,G=128,B=128,A=255)
}