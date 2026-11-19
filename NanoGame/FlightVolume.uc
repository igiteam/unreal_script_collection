/**
 * FlightVolume - Volume used for flight navigation in Nano
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class FlightVolume extends Volume
	placeable
	native;

cpptext
{
	// Add a connection to given pylon/poly
	void AddFlightConnector( APylon* Pylon, WORD PolyIdx );

	virtual void ClearCrossLevelReferences();
	virtual void GetActorReferences(TArray<FActorReference*> &ActorRefs, UBOOL bIsRemovingLevel);

	FFlightVolumeToPylonConnector* GetConnectorPtrToPylon( APylon* DestPylon );
}

struct native FlightVolumeToPylonConnector
{
	/** Reference to the pylon that can see this flight volume */
	var() ActorReference PylonRef;
	/** List of poly indices that connect to this flight volume */
	var() array<int>	 Polys;

	structcpptext
	{
		friend FArchive& operator<<( FArchive& Ar, FFlightVolumeToPylonConnector& T );

		FString ToString( class AActor* FV )
		{
			FString ListStr;
			for( INT PolyIdx = 0; PolyIdx < Polys.Num(); PolyIdx++ )
			{
				ListStr += FString::Printf(TEXT("%d, "), Polys(PolyIdx));
			}
			return FString::Printf(TEXT("Flight Connector %s to %s (%s)"), *FV->GetName(), *PylonRef->GetName(), *ListStr );
		}
	}
};
/** List of pylon refs with associated polys that connect to this volume */
var() editconst array<FlightVolumeToPylonConnector>	Connectors;

/** List of pivots that are within this volume */
var() editconst array<FlightPivot>	Pivots;

/** Returns if this flight volume can directly reach or generate a path of pivots to reach the given pylon */ 
native function bool CanReachPylon( Pylon DestPylon, Controller C );
/** Grab flight pivot pathnode nearest the test location */
native function FlightPivot GetNearestPivot( Vector TestPt );
/** Returns if this flight volume has a direct connector to the given pylon */
native function bool HasConnectorToPylon( Pylon DestPylon );

defaultproperties
{
	bColored=TRUE
	BrushColor=(R=255,G=128,B=0,A=255)
}