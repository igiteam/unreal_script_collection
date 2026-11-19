/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class EmergenceHoleRenderingComponent extends PrimitiveComponent
	native;

cpptext
{
	FPrimitiveSceneProxy* CreateSceneProxy();
	void UpdateBounds();
};

defaultproperties
{
	HiddenGame=TRUE
	AlwaysLoadOnClient=FALSE
	AlwaysLoadOnServer=FALSE
}
