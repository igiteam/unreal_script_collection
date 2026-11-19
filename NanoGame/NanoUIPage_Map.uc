/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoUIPage_Map extends NanoUIPage_Base;

function NanoMissionManager GetMissionManager()
{
	local NanoGRI NGRI;
	local NanoPawn NP;

	NP = GetNanoPawn();
	NGRI = NP.GetGRI();

	return NGRI.TheMissionManager;
}

///// NanoUIPage_Base interface


function HandlePageInput(name ButtonName)
{
	GetMissionManager().HandleMenuInput(ButtonName);
}

function PageShown()
{
	GetMissionManager().OnMenuOpened(NanoHUD);
}

function PageHidden()
{

}

function DrawPage()
{
	GetMissionManager().DrawAllMissionHUDInfo(self);
}

defaultproperties
{
	PageName="MAP"
}