/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SetOverheadMapTexture extends SequenceAction;

/** The texture to use for the overhead map. Setting this to none will cause the map to use the default value in the map info **/
var() Texture2D OverriddenAtRunTimeMapTexture;

/** The anchor to use for this map texture.  If blank will use the default anchors **/
var() NanoMapAnchor OveriddenAtRunTime_MC_TopLeft_NW_MaxX_MinY;

/** The anchor to use for this map texture.  If blank will use the default anchors **/
var() NanoMapAnchor OveriddenAtRunTime_MC_BottomRight_SE_MinX_MaxY;

/** What the scale of the new map is **/
var() float OverriddenAtRunTimeMinimapToWorldScale;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

event Activated()
{
	local NanoMapSpecificInfo MapInfo;

	MapInfo = NanoMapSpecificInfo(class'WorldInfo'.static.GetWorldInfo().GetMapInfo());

	MapInfo.OverriddenAtRunTimeMapTexture = OverriddenAtRunTimeMapTexture;
	MapInfo.OveriddenAtRunTime_MC_TopLeft_NW_MaxX_MinY = OveriddenAtRunTime_MC_TopLeft_NW_MaxX_MinY;
	MapInfo.OveriddenAtRunTime_MC_BottomRight_SE_MinX_MaxY = OveriddenAtRunTime_MC_BottomRight_SE_MinX_MaxY;

	MapInfo.OverriddenAtRunTimeMinimapToWorldScale = OverriddenAtRunTimeMinimapToWorldScale;



	//`log( "SeqAct_SetOverheadMapTexture" @ `showvar(MapInfo.OverriddenAtRunTimeMapTexture) @ `showvar(MapInfo.OveriddenAtRunTime_MC_TopLeft_NW_MaxX_MinY) @ `showvar(MapInfo.OveriddenAtRunTime_MC_BottomRight_SE_MinX_MaxY) @ `showvar(MapInfo.OverriddenAtRunTimeMinimapToWorldScale) );

}



defaultproperties
{
	ObjName="Set Overhead Map Texture"
	ObjCategory="Nano"

	bCallHandler=FALSE

	VariableLinks.Empty()

}



