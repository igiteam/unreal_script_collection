class ACTION_InjurePawn extends ScriptedAction;

var(Action)	name	PawnTagToInjure;
var(Action) float	InjuredPct;
var(Action) bool	bLeftLeg;

function bool InitActionFor ( ScriptedController C )
{
	local ZombieBipedPawn MyPawn;

	// check this scripted controller for a pawn
	if ( C.Pawn != None )
	{
		MyPawn = ZombieBipedPawn ( C.Pawn );
		if ( MyPawn != None )
		{
			SetInjured ( MyPawn );
		}
	}

	// loop over all pawns if we have a valid search tag
	if ( PawnTagToInjure != 'None' && PawnTagToInjure != '' )
	{
		foreach C.AllActors ( class'ZombieBipedPawn', MyPawn, PawnTagToInjure )
		{
			if ( MyPawn != None )
			{
				SetInjured ( MyPawn );
			}
		}
	}

	// end action
	return false;	
}

function SetInjured ( ZombieBipedPawn PawnToInjure )
{
	PawnToInjure.Health = 100 - 100 * ( InjuredPct - 0.25 );
	PawnToInjure.bInjured = true;

	//FAISON clamped health
	PawnToInjure.GroundSpeed = 150.0 + (2.0 * FClamp(PawnToInjure.Health, 0, 100));
	
	if( PawnToInjure.Health > 0 )
		PawnToInjure.WalkingPct = 0.29 + ( 1.0 / FClamp(PawnToInjure.Health, 0, 100));

    if ( bLeftLeg )
	{
		PawnToInjure.LoopAnim('wounded_leg_l_blend', 1.0, 0.2, 5);
	}
	else
	{
		PawnToInjure.LoopAnim('wounded_leg_r_blend', 1.0, 0.2, 5);
	}
}

function string GetActionString()
{
	return ActionString;
}


// Decompiled with UE Explorer.
defaultproperties
{
    InjuredPct=0.5000000
    ActionString="Injure pawn"
}