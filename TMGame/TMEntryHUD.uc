/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMEntryHUD extends HUD
	config(Game);

simulated function PostBeginPlay()
{
    local MaterialEffect ME;

    Super.PostBeginPlay();

    //clear the latest level effect
    ME = MaterialEffect(LocalPlayer(PlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect('HitEffect'));
    if(ME != None)
    {
        ME.bShowInGame = false;
    }

    ME = MaterialEffect(LocalPlayer(PlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect('LDEffect'));
    if(ME != None)
    {
        ME.bShowInGame = false;
    }
}

event PostRender()
{
	return;
}

