/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_Interact extends Interface;


// don't forget to update THE TICK function of this implementing object to: InteractableComp.Tick( DeltaTime );


/**
 * Get tooltip for interacting 
 * Also will return the Texture button to Prefix the text with.
 * Since it is annoying and painful to put a button in the middle of things we will just do:
 * Button to interact   Button to speak to dude. etc.
 **/
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix );


/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent();


/** See if this object can be interacted with by this Pawn */
simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type);


/** Perform the interaction */
simulated function DoInteract(NanoPawn NPP, ENanoInteractType Type);

/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted();


// these are functions that the componenet will call back to the NanoInterface_Interact(Owner) casted Owner!


// update effects

// do reward shizzle