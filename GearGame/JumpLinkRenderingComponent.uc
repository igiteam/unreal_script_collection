/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class JumpLinkRenderingComponent extends LineBatchComponent
	native(AI)
	hidecategories(Physics,Collision,PrimitiveComponent,Rendering);

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
