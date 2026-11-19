/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoMissionWayPoint extends NanoTargetPoint
	AutoExpandCategories( NanoMissionWayPoint )
	implements( NanoInterface_Interact );


/** If we are interactable or just a place holder to show up on the map **/
var() bool bInteractable;

/** Whether or not this way point is interactable during chaos. **/
var() bool bInteractableDuringChaos;

/** Text to display when showing the interact tool tip **/
var() string TextToDisplayForInteraction;



/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent()
{
	return None;
}

/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted();


/** See if this object can be interacted with by this Pawn */
simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	if( bInteractable == FALSE )
	{
		return FALSE;
	}

	// if there is chaos and we are not allowed to interact
	if( ( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 ) 
		&& ( bInteractableDuringChaos == FALSE )
		)
	{
		return FALSE;
	}

	return TRUE;
}

/**
 * Get tooltip for interacting 
 * Also will return the Texture button to Prefix the text with.
 * Since it is annoying and painful to put a button in the middle of things we will just do:
 * Button to interact   Button to speak to dude. etc.
 **/
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	if( TextToDisplayForInteraction != "" )
	{
		out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';
		return TextToDisplayForInteraction;
	}

	return "";
}

/** Perform the interaction */
simulated function DoInteract(NanoPawn NP, ENanoInteractType Type)
{
	// hrmm not certain what we want to do here.  
	// we probably need to get the "TYPES" of mission interactions
	// and then make some codification
	//
	// for now we will just trigger an event

	// we need make a component that handles the "interaction" / "absorbing" / "timing"   c.f.  the NanoAbsorbOrb code and convert to a component
	TriggerEventClass( class'SeqEvt_MissionWayPointCompleted', NP, 0 );  
}



simulated function OnModifyNanoMissionWayPoint ( SeqAct_ModifyNanoMissionWayPoint InAction )
{
	bInteractable = InAction.bInteractable;

	bInteractableDuringChaos = InAction.bInteractableDuringChaos;

	if( InAction.TextToDisplayForInteraction != "" )
	{
		TextToDisplayForInteraction = InAction.TextToDisplayForInteraction;
	}
}





defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'UI_HUD.Minimap.Mission'
	End Object

	Debug_Icon=None

	bInteractable=TRUE
	bInteractableDuringChaos=TRUE
	TextToDisplayForInteraction="to Complete Mission WayPoint."

	InGameInfo_IconColor=(R=255,G=255,B=255,A=255)

	// Missions / LDs should toggle this to be shown
	Begin Object Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,bShownEvenIfClamped=TRUE,DistancesToDrawIcon=(X=0,Y=20000),Icon=Texture2D'UI_HUD.Minimap.Mission',IconScale=0.125f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=TRUE,AboveBelowIconScale=0.100f,TextName="",TextDescription="",TextVerticalOffset=0.0f)
	End Object

}