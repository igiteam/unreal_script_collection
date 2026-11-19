/**
 * So this should be used when you know that the "path" to the Location is pathable.
 * For example:  GeneratePath(), GetNextMoveLocation(), then use this AICmd as the Path
 * has guarenteed that we can get to the NextMoveLocation Safely.
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_MoveToWithOutPathing extends NanoAICmd
	within NanoAI;


/** Where we want to move. **/
var transient vector LocationToMove;

/** How far away from the offset we can be before saying we have arrived **/
var transient float DestinationOffset;


/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToWithOutPathing( NanoAI AI, const vector InLocationToMove, const float InDestinationOffset )
{
    local NanoAICmd_MoveToWithOutPathing Cmd;

    if( AI != None )
    {
        Cmd = new(AI) class'NanoAICmd_MoveToWithOutPathing';
        if( Cmd != None )
        {
            Cmd.LocationToMove = InLocationToMove;
            Cmd.DestinationOffset = InDestinationOffset;
            AI.PushCommand( Cmd );

            return TRUE;
        }
    }
    return FALSE;
}


function Pushed()
{
    GotoState( 'MovingToLocation' );
}


State MovingToLocation
{
Begin:
    MoveTo( LocationToMove,, DestinationOffset );
    PopCommand( self ); 
}



defaultproperties
{
}

