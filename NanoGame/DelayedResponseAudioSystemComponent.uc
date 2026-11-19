/**
 * This is just a nice way to have time delayed response system dialog playing spawning without having to keep a
 * polling loop around and managing all of the delayed actions.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class DelayedResponseAudioSystemComponent extends PrimitiveComponent
	dependson(NanoArchetypeTypes);


var transient EDialogueLine DialogLineID;

var transient Actor ActorToPlayOn;



/** This function is our "doit" function which will be called by a timer. **/
function DoIt()
{
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NADS.AttemptToPlayLine( DialogLineID, ActorToPlayOn );
}



defaultproperties
{

}
