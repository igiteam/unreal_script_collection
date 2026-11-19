/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class FlightPivot extends NavigationPoint
	placeable
	native;

cpptext
{
#if WITH_EDITOR
	virtual void addReachSpecs(AScout *Scout, UBOOL bOnlyChanged);
	virtual UBOOL CanConnectTo(ANavigationPoint* Nav, UBOOL bCheckDistance);
#endif // #if WITH_EDITOR

	virtual UClass* GetReachSpecClass( ANavigationPoint* Nav, UClass* DefaultReachSpecClass ) { return UForcedReachSpec::StaticClass(); }
	virtual void ClearPaths();
}

defaultproperties
{
	Begin Object NAME=Sprite
		Sprite=Texture2D'EditorResources.VolumePath'
	End Object

	bNoAutoConnect=true
}