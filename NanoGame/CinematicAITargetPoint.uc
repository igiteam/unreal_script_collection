/** 
 * Special Actor in world to allow for "cinematic" set ups
 * -> dude in front of the window.    This will not ever be fulfilled until a guy dies while being thrown  
 *    through the glass!  (just there telling people to come to him)   (e.g. I headshot a foe and  no cine?!?!  NOT SO with 
 *    this way as another foe will come over!)
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class CinematicAITargetPoint extends NanoTargetPoint
	AutoExpandCategories( NanoCine );

/** This the AI pawn type to attract to this Cinematic Point.  If this is none then we will try to attract anyone! **/
var(NanoCine) class<NanoPawnBase> EnemyTypeToAttract;

/** This is the AIAction that this pawn should perform at this CinematicAITargetPoint **/
var(NanoCine) class<NanoAIAction> AIShouldPerformThis;

/** This is the number of AI that this actor will grab **/
var(NanoCine) int NumOfAIToDoThis;

/** Whether or not the AI should play an anim when standing at this spot. **/
var(NanoCine) bool bPlayAnim;

/** This is the anim to have this cine actor play. **/
var(NanoCine) Name OverrideAnimNameToPlay;

var float TimeBetweenFindAI;
var transient float LastTimeBetweenFindAI;

var transient NanoAI CurrCinematicAI;


simulated function Tick( float DeltaTime )
{
	local NanoAI AI;

	Super.Tick( DeltaTime );

	if( bIsActive == TRUE )
	{
		if( `TimeSince(LastTimeBetweenFindAI) > TimeBetweenFindAI )
		{
			if( ( CurrCinematicAI == None ) && ( NumOfAIToDoThis > 0 ) )
			{
				// hack for now.
				foreach WorldInfo.AllControllers( class'NanoAI', AI )
				{
					// so if we are looking for a specific class of AI
					if( EnemyTypeToAttract != none )
					{
						// and we did not find it then continue to the next AI
						if( AI.Pawn.Class != EnemyTypeToAttract ) 
						{
							continue;
						}
					}


					// so here we need to see if we can find path to this object
					if( AI.GeneratePathToLocation( Location ) == TRUE )
					{
						//`log( "SWEEET I found a path!!!!!!" );
						CurrCinematicAI = AI;
						CurrCinematicAI.CurrCinematicAITargetPoint = self;
						CurrCinematicAI.ListOfAIActionsThisAICanDo.AddItem( AIShouldPerformThis );
						NumOfAIToDoThis--;
						break;
					}
				}
			}
			else
			{
				// our AI has died
				if( ( CurrCinematicAI != None )
					&& ( ( CurrCinematicAI.Pawn == None ) || ( CurrCinematicAI.Pawn.Health <= 0 ) )
					)
				{
					CurrCinematicAI = None;
				}
			}

			LastTimeBetweenFindAI = WorldInfo.TimeSeconds; 
		}
	}

}





defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'UI_HUD.AI.AICinematic'
	End Object

	TimeBetweenFindAI=0.250f
	AIShouldPerformThis=class'NanoAIAction_Idle_DoingCinematicAITargetPoint'
	NumOfAIToDoThis=1

	bPlayAnim=TRUE
}


