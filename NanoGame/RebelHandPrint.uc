/** 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class RebelHandPrint extends DynamicSMActor_Spawnable
	implements( NanoInterface_Interact, NanoInterface_Objective )
	notplaceable;

var transient string OwnerID;

var InteractableComponent InteractableComp;

/** Our UIIconComponent for easy access. **/
var UIIconComponent UIComponent;

// put this into the DB

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}


simulated function UpdateForgedLocation()
{
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.RebelHandPrintLocation, Location );
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.RebelHandPrintRotation, Rotation );
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.RebelHandUsedBy, "" );

}


simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	InteractableComp.Tick( DeltaTime );
}


/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted()
{
	local string EnumString;

	// since our handprint was absorbed we are going to update the DB
	EnumString = String(GetEnum(enum'EChallengeEventType', ECET_RebelHandPrintAbsorbed));
	NanoGRI(WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( OwnerID, EnumString, 1 );

	// reset so they don't appear in the world until they have been replaced
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( OwnerID, class'NanoMCPKeys'.default.RebelHandPrintLocation, vect(0,0,0) );
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( OwnerID, class'NanoMCPKeys'.default.RebelHandPrintRotation, rot(0,0,0) );
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( OwnerID, class'NanoMCPKeys'.default.RebelHandUsedBy, class'NanoTypes'.static.GetLocalPlayerUserName() );
	
}


event Destroyed()
{
	Super.Destroyed();
}



/**
 * Get tooltip for interacting 
 * Also will return the Texture button to Prefix the text with.
 * Since it is annoying and painful to put a button in the middle of things we will just do:
 * Button to interact   Button to speak to dude. etc.
 **/
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	if( OwnerID == class'NanoTypes'.static.GetLocalPlayerUserName() )
	{
		return "You own this RebelHandPrint";
	}

	if( InteractableComp.BeingAbsorbedBy != None )
	{
		return "Acquiring NanoPower from" @ OwnerID;
	}

	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';

	if( InteractableComp.bCanAbsorb == TRUE )
	{
		return "for NanoPower left by" @ OwnerID;
	}
	else
	{
		return "Cannot interact";
	}	
}


/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent()
{
	return InteractableComp;
}

simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	return InteractableComp.CanInteract( NP, Type );
}

simulated function DoInteract( NanoPawn NP, ENanoInteractType Type )
{
	if( OwnerID == class'NanoTypes'.static.GetLocalPlayerUserName() )
	{
		return;
	}

	InteractableComp.DoInteract( NP, Type );
}


function vector GetObjectiveLocation()
{
	return Location;
}


/** Returns the UI component which we will then act upon. **/
function UIIconComponent GetUIIconComponent()
{
	return UIComponent;
}




defaultproperties
{

	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'REB_Deco01.SM.Mesh.S_REB_Deco01_HandForge_Symbol'
		Rotation=(Pitch=0,Yaw=16384,Roll=0)
		Scale=4.0f
	End Object



	Begin Object Class=UIIconComponent Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,bShownEvenIfClamped=FALSE,DistancesToDrawIcon=(X=0,Y=0),Icon=Texture2D'UI_HUD.MiniMap.HandForge',IconScale=0.125f,AboveBelowIconScale=0.1f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=TRUE)
	End Object
	UIComponent=UIIconComponent0
	Components.Add(UIIconComponent0)


	Begin Object Class=InteractableComponent Name=InteractableComponent0
	    InteractDistance=768.0f
		bCanGrab=FALSE
		bCanAbsorb=TRUE
		AbsorbTime=3.0f
		Reward=(NanoPowerBucketsGained=20)
	End Object
	//CollisionComponent=InteractableComponent0
	InteractableComp=InteractableComponent0
	Components.Add( InteractableComponent0 )

	bCollideActors=TRUE
	bBlockActors=FALSE

}

