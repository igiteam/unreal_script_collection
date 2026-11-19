/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoDesignatedFleeSpot extends Actor
	AutoExpandCategories( NanoPatrolPoint )
	hidecategories( Movement, Display, Collision, Physics, Advanced, Debug, Object )
	placeable;


/** The name of this patrol route.  AI can be told to look for a speciifc route. **/
var() Name DesignatedFleeSpotName;

/** How long to pause at this specific patrol point **/
var() float DurationToPauseHere;


var transient NanoPawnBase PawnThatHasClaimedThisRoute;


/**  When a pawn reaches this point they will play this sound **/
var() SoundCue SoundToPlayWhenReachedThisPoint;

var bool bIfStoppedFaceTheDirectionOfPatrolPoint;


simulated function ClaimDesignatedFleeSpot( NanoPawnBase InClaimer )
{
	SetClaim( InClaimer );
}


simulated function UnClaimDesignatedFleeSpot()
{
	SetClaim( None );
}


// NOTE:  this is going to be busted for claiming a node in the "middle of the list"

private function SetClaim( NanoPawnBase InClaimer )
{
	PawnThatHasClaimedThisRoute = InClaimer;
	`log( "Setting Claim" @ `showvar(InClaimer) @ " on " @ `showvar(self) );
}



defaultproperties
{
	Begin Object Class=ArrowComponent Name=Arrow
		ArrowColor=(R=150,G=200,B=255)
		ArrowSize=0.5
		bTreatAsASprite=TRUE
		HiddenGame=TRUE
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
	End Object
	Components.Add(Arrow)


	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Note'
		HiddenGame=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
	End Object
	Components.Add(Sprite)

	bStatic=TRUE
	bHidden=TRUE
	bNoDelete=TRUE
	bMovable=FALSE


	DurationToPauseHere=10000
	bIfStoppedFaceTheDirectionOfPatrolPoint=TRUE
}