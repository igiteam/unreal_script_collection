/**
 * This component will keep track of all of the data needed for "how" to display an object on the various parts of the UI.
 *
 * Basically, if you want to be displayed on the UI then just add this component and parameterized it.
 *
 * NOTE: Any vars that need to up updated need to have a function as the data needs to be on teh object and we don't
 *       really have a notion of a ref that will get updated correctly
 *
 *
 * This is still DIRTY need to keep refactoring it
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIIconComponent extends PrimitiveComponent
	hidecategories( Object, Rendering, Physics, Collision, Lighting, PrimitiveComponent );


struct IconDatum
{
	//// rules for when to draw this

	/** Should this show up (on what ever medium we are drawing on) **/
	var() bool bShown;

	/** Should this show up even if there is no chaos **/
	var() bool bShowEvenIfNoChaos;

	/** Show on the edge even if the drawn point is "outside" of the currently view on current medium. **/
	var() bool bShownEvenIfClamped;

	/** If the NanoTargetPoint is in between these distances draw it.  Helps reduce screen clutter **/
	var() vector2d DistancesToDrawIcon;


	//// this is icon data

	/** Variables for how this Pawn should show up on the mini map **/
	var() Texture2D Icon;

	/** Scale of the icon.  Basically, icon is made as a 128x128 or such and needs to be scaled down to fit on the minimap/hud/etc **/
	var() float IconScale;

	/** We sometimes want to colorize the icon (e.g. you have a generic people icon and it can be a mission/foe/ally **/
	var() color IconColor;


	/** Scale of the icon with Chaos.  Basically, icon is made as a 128x128 or such and needs to be scaled down to fit on the minimap/hud/etc **/
	var() float IconScaleWithChaos;

	/** We sometimes want to colorize the icon with Chaos (e.g. you have a generic people icon and it can be a mission/foe/ally **/
	var() color IconColorWithChaos;



	//// above below vars

	/** Whether or not we are a special icon that the mini map needs to NOT just replace with a down/up arrow but instead alternate **/
	var() bool bAlternateAboveBelowIcon;

	/** Scale of the above/below icon.  Basically, icon is made as a 128x128 or such and needs to be scaled down to fit on the minimap/hud/etc **/
	var() float AboveBelowIconScale;

	/** Used to say we actually should be using the above/below icon and not the default icon. **/
	var transient bool bDisplayAboveBelowIcon;

	/** If we are alternating between our icon and the above/below icon we need to know when we were last the NormalIcon so we can flip to the Up/Down**/
	var transient float LastNormalIconTime; 



	//// so all of the special case data which may or may not be used by all of the systems
	//// but we want to keep it simple to pass these around and not just have structs inside structs inside structs

	/** Name to display on the map / in game. **/
	var(IconText) Name TextName;

	/** String data to display on the map / in game. **/
	var(IconText) string TextDescription;

	/** How far to place the debug info above the in world actor**/
	var(IconText) float TextVerticalOffset;



	//// Animated vars (basically whenever we first add a new icon to the screen we want to do a special flashy flash or scaling or what not)

	/** Used to say we actually should be using the above/below icon and not the default icon. **/
	var() transient bool bDisplayAnimation;

	/** If we are alternating between our icon and the above/below icon we need to know when we were last the NormalIcon so we can flip to the Up/Down**/
	//var() transient float LastNormalIconTime; 

	structdefaultproperties
	{
		bShown=FALSE
		bShownEvenIfClamped=FALSE
		DistancesToDrawIcon=(X=0,Y=20000)
		Icon=None
		IconScale=1.0f
		IconColor=(R=255,G=255,B=255,A=255)
		IconScaleWithChaos=1.0f
		IconColorWithChaos=(R=255,G=255,B=255,A=255)
		bAlternateAboveBelowIcon=0
		AboveBelowIconScale=0.06f
		bDisplayAboveBelowIcon=FALSE
		TextName=""
		TextDescription=""
		TextVerticalOffset=0.0f
	}

};


var() IconDatum MiniMap;
var() protectedwrite IconDatum PauseMenuMap;
var() protectedwrite IconDatum InGameHUDIconFloating;
var() protectedwrite IconDatum DebugInfo;
var() protectedwrite IconDatum IRIS;


var protected float AboveBelowIconScale;

var const Texture2D EntityAbove;
var const Texture2D EntityBelow;



/** Return location of objective, used by radar */
final function vector GetObjectiveLocation()
{
	return Owner.Location;
}


final function GetIconDatum( const EIconType IconType, out IconDatum TheIconDatum )
{
	//// Find the correct Icon Datum
	// copying here sort of sucks
	switch( IconType )
	{
	case EIT_MiniMap: TheIconDatum = Minimap; break;
	case EIT_PauseMenuMap: TheIconDatum = PauseMenuMap; break;
	case EIT_InGameHUDIconFloating: TheIconDatum = InGameHUDIconFloating; break;
	case EIT_DebugInfo: TheIconDatum = DebugInfo; break;
	case EIT_IRIS: TheIconDatum = IRIS; break;

	default: TheIconDatum = Minimap; break;
	}
}

final function SetIconDatum( const EIconType IconType, const out IconDatum TheIconDatum )
{
	//// Find the correct Icon Datum
	// copying here sort of sucks
	switch( IconType )
	{
	case EIT_MiniMap: Minimap = TheIconDatum; break;
	case EIT_PauseMenuMap: PauseMenuMap = TheIconDatum; break;
	case EIT_InGameHUDIconFloating: InGameHUDIconFloating = TheIconDatum; break;
	case EIT_DebugInfo: DebugInfo = TheIconDatum; break;
	case EIT_IRIS: IRIS = TheIconDatum; break;

	default: Minimap = TheIconDatum; break;
	}
}



function SetLastNormalIconTime( const EIconType IconType, float InTime )
{
	//MiniMap_LastNormalIconTime = InTime;
	switch( IconType )
	{
	case EIT_MiniMap: Minimap.LastNormalIconTime = InTime; break;
	case EIT_PauseMenuMap: PauseMenuMap.LastNormalIconTime = InTime; break;
	case EIT_InGameHUDIconFloating: InGameHUDIconFloating.LastNormalIconTime = InTime; break;
	case EIT_DebugInfo: DebugInfo.LastNormalIconTime = InTime; break;
	case EIT_IRIS: IRIS.LastNormalIconTime = InTime; break;

	default: `warn( GetFuncName() @ "INVALID" @ `showvar(IconType) );
	}
}


final function ToggleDisplayAboveBelowIcon( const EIconType IconType )
{
	switch( IconType )
	{
	case EIT_MiniMap: Minimap.bDisplayAboveBelowIcon = !Minimap.bDisplayAboveBelowIcon; break;
	case EIT_PauseMenuMap: PauseMenuMap.bDisplayAboveBelowIcon = !Minimap.bDisplayAboveBelowIcon; break;
	case EIT_InGameHUDIconFloating: InGameHUDIconFloating.bDisplayAboveBelowIcon = !Minimap.bDisplayAboveBelowIcon; break;
	case EIT_DebugInfo: DebugInfo.bDisplayAboveBelowIcon = !Minimap.bDisplayAboveBelowIcon; break;
	case EIT_IRIS: IRIS.bDisplayAboveBelowIcon = !Minimap.bDisplayAboveBelowIcon; break;

	default: `warn( GetFuncName() @ "INVALID" @ `showvar(IconType) );
	}
}






defaultproperties
{
	// NEWTYPE=(bShown=FALSE,bShownEvenIfClamped=FALSE,DistancesToDrawIcon=(X=0,Y=0),Icon=None,IconScale=1.0f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=FALSE,AboveBelowIconScale=0.06f,TextName="",TextDescription="",TextVerticalOffset=0.0f)


	EntityAbove=Texture2D'UI_HUD.Minimap.EnemyAbove'
	EntityBelow=Texture2D'UI_HUD.Minimap.EnemyBelow'
	AlwaysLoadOnServer=FALSE // without this  MoveViewportCamerasToActor will take this component's Bound.GetBox() which will be insanely large as it is either not init'd correctly or just assumes to be HUGE  (prob a bug there)
}


/*

/** Our UIIconComponent for easy access. **/
var UIIconComponent UIComponent;


/** Returns the UI component which we will then act upon. **/
function UIIconComponent GetUIIconComponent()
{
	return UIComponent;
}


Begin Object Class=UIIconComponent Name=UIIconComponent0
End Object
UIComponent=UIIconComponent0
Components.Add(UIIconComponent0)




*/