/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoInteractableActor extends KActor
		implements( NanoInterface_Interact )
		placeable;


var() InteractableComponent InteractableComp;


simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	InteractableComp.Tick( DeltaTime );
}


simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	//`log( `showvar(InteractableComp.bEnabled) );

	if( InteractableComp.bEnabled == FALSE )
	{
		return "";
	}

	if( InteractableComp.BeingAbsorbedBy != None )
	{
		return "Interacting";
	}

	if( InteractableComp.bCanAbsorb == TRUE )
	{
		out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';
		return "to Interact";
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

/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted();

simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	return InteractableComp.CanInteract( NP, Type );
}


simulated function DoInteract( NanoPawn NP, ENanoInteractType Type )
{
	InteractableComp.DoInteract( NP, Type );
}

function vector GetObjectiveLocation()
{
	return Location;
}






defaultproperties
{
	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'EngineMeshes.Cube'
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE,Untitled2=TRUE,Untitled3=TRUE)
	End Object

	Begin Object Class=InteractableComponent Name=InteractableComponent0
		InteractDistance=128.0f
		bCanGrab=FALSE
		bCanAbsorb=TRUE
		AbsorbTime=11.0f
	End Object
	InteractableComp=InteractableComponent0
	Components.Add( InteractableComponent0 )

	bCollideActors=TRUE // this is needed to put into the octree


	SupportedEvents.Add( class'SeqEvt_InteractionWithActor' )
}