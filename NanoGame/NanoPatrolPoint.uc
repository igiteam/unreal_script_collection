/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPatrolPoint extends Actor
	AutoExpandCategories( NanoPatrolPoint )
	hidecategories( Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object )
	implements( NanoInterface_PatrolDestination )
	placeable;

/** 
 * Determines the patrol order for this list.
 *
 * starting from 0 to N
 *
 * The AI will go from 0 to N and then N to 0 more than likely.
 *
 **/
var() NanoPatrolPoint NextNanoPatrolPoint;

/** The name of this patrol route.  AI can be told to look for a speciifc route. **/
var() Name PatrolRouteName;

/** How long to pause at this specific patrol point **/
var() float DurationToPauseHere;


var transient NanoPawnBase PawnThatHasClaimedThisRoute;


/**  When a pawn reaches this point they will play this sound **/
var() SoundCue SoundToPlayWhenReachedThisPoint;


/** If the AI stops at this patrol point then it will face the direction the patrol point is facing **/
var() bool bIfStoppedFaceTheDirectionOfPatrolPoint;



// can add some extra logic in here eventually
simulated function bool GetPatrolDestination( out Vector out_PatrolDest )
{
	out_PatrolDest = Location;
	return TRUE;
}


simulated function ClaimPatrolRoute( NanoPawnBase InClaimer )
{
	SetClaim( InClaimer );
}


simulated function UnClaimPatrolRoute()
{
	SetClaim( None );
}


// NOTE:  this is going to be busted for claiming a node in the "middle of the list"

private function SetClaim( NanoPawnBase InClaimer )
{
	local NanoPatrolPoint Next;

	PawnThatHasClaimedThisRoute = InClaimer;
	`log( "Setting Claim" @ `showvar(InClaimer) @ " on " @ `showvar(self) );


	Next = NextNanoPatrolPoint;


	while( Next != None )
	{
		`log( "Setting Claim" @ `showvar(InClaimer) @ " on " @ `showvar(Next) );
		Next.PawnThatHasClaimedThisRoute = InClaimer;

		Next = Next.NextNanoPatrolPoint;

		// ughh

		// if we are setting things to none and we see a "none'd" node then break as we have a cycle
		if( InClaimer == None )
		{
			if( Next.PawnThatHasClaimedThisRoute == None )
			{
				break;
			}
		}

		// if we are setting things to a Pawn and we see a "pawned'd" node then break as we have a cycle
		if( InClaimer != None )
		{
			if( Next.PawnThatHasClaimedThisRoute != None )
			{
				break;
			}
		}
	}



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

	bIfStoppedFaceTheDirectionOfPatrolPoint=TRUE
}