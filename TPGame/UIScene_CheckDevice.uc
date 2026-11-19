/**
 * Copyright ? 2006 Epic Games, Inc. All Rights Reserved.
 */

class UIScene_CheckDevice extends UIScene
	native;

delegate OnSceneClose();

event SceneDeactivated()
{
	Super.SceneDeactivated();
	OnSceneClose();
}
