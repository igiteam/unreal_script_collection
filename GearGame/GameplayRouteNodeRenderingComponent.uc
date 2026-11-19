/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayRouteNodeRenderingComponent extends PrimitiveComponent
	native(AI);

cpptext
{
	virtual FPrimitiveSceneProxy* CreateSceneProxy();
	virtual void UpdateBounds();
	virtual UBOOL ShouldRecreateProxyOnUpdateTransform() const;
};

defaultproperties
{
	HiddenGame=TRUE
}
