/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoNavigationHandle extends NavigationHandle
	native(AI);

cpptext
{
	virtual AFlightVolume* GetFlightVolumeFromPos( const FVector& Pos );
}


native function bool CanUseFlightNetwork( Vector Src, Vector Dest, out Vector out_TakeOffPos, out Vector out_LandPos, out FlightPivot out_SrcPivot, out FlightPivot out_DestPivot );
	
defaultproperties
{
}