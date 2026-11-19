/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_BullRam_Charge extends NanoAICmd within NanoAI_BullRam;


var vector MoveLocation;

var float SavedGroundSpeed;


var ParticleSystem TelegraphEffect;
var transient ParticleSystemComponent PSC_TelegraphEffect;

var SoundCue TelegraphSound;



static function Charge(NanoAI_BullRam AI, optional vector NewMoveLocation, optional Actor NewMoveActor, optional float MaxMoveTime, optional bool NewbFaceFocus = TRUE)
{
	local NanoAICmd_BullRam_Charge Cmd;
	if (AI != None)
	{
		Cmd = new(AI) class'NanoAICmd_BullRam_Charge';
		if (Cmd != None)
		{
			Cmd.MoveLocation = NewMoveLocation;
			AI.PushCommand(Cmd);
		}
	}
}


/**
 * Allows the AI to suggest the toss velocity for a grenade
 *
 * @param GrenadeWeap - The grenade weapon itself that is being tossed
 * @param TossVelocity - The returned velocity calculated
 * @param Start - The starting location of the toss
 * @param TargetLocation - the location to fire to
 * @param return - Whether we were successful in finding a velocity to throw the grenade
 */
function bool SuggestTeslaTossVelocity( out vector TossVelocity, vector Start, const float InGravityZ, const vector TargetLocation )
{
/*	local vector TargetLoc;

	TargetLoc = TargetLocation;
	//DrawDebugCoordinateSystem( TargetLoc, rot(0,0,0), 50.0f, TRUE );

	return SuggestTossVelocity( TossVelocity, TargetLoc, Start, class'NanoWeap_Baton'.default.TeslaVelRange.y, Pawn.Velocity.Z, 0.45f, ,, InGravityZ, FALSE );
*/
	return FALSE;
}


function NanoProj_TeslaCoil ThrowTesla( const vector TargetLocation )
{
	local Vector		SpawnLoc;
	local NanoProj_TeslaCoil	NadeProj;
	local Vector		Toss;
	local bool bFoundSuccessfulToss;

	SpawnLoc = Pawn.Location + vect(0,0,100);
	NadeProj = Spawn(class'NanoProj_TeslaCoil_BullRam',,,SpawnLoc,rot(0,0,0),, TRUE );

	if( NadeProj != None && !NadeProj.bDeleteMe )
	{
		// Allow the AI to determine where to throw the grenade
		bFoundSuccessfulToss = SuggestTeslaTossVelocity( Toss, SpawnLoc, NadeProj.GetGravityZ()*NadeProj.GravityScale, TargetLocation );
		if( bFoundSuccessfulToss == TRUE )
		{
			NadeProj.Init( Toss );
			NadeProj.Velocity = Toss; // gears did this but it should just be what the init does
		}
		else
		{
			NadeProj.Destroy();
			NadeProj = none;
		}
	}

	return NadeProj;
}


/** Fires teslsa at the player boxing them in! **/
function LaunchTeslaCoilsAtTarget()
{
	local vector EnemyLoc;
	local Vector ForwardOffset;
	local vector TargetLoc;
	local float DistFromTarget;
    
    EnemyLoc = ChargeLocation;
	ForwardOffset = Normal(Pawn.Location - EnemyLoc) * 256.0f;
	DistFromTarget = 512.0f;

	// this will launch 4 teslas that will surround the player and force them to:
	// 0) dodge and take damage
    // 1) try to run backwards aahahahah
	// 2) attempt to jump on the bull ram!

    TargetLoc = (EnemyLoc + ForwardOffset) + ( (vect(0,1,0) >> Pawn.Rotation) * DistFromTarget );
	//DrawDebugLine( EnemyLoc, TargetLoc, 255, 0, 0, TRUE );
    ThrowTesla( TargetLoc ) ;

    TargetLoc = (EnemyLoc - ForwardOffset) + ( (vect(0,1,0) >> Pawn.Rotation) * DistFromTarget );
	//DrawDebugLine( EnemyLoc, TargetLoc, 255, 0, 0, TRUE );
    ThrowTesla( TargetLoc ) ;

    TargetLoc = (EnemyLoc + ForwardOffset) + ( (vect(0,-1,0) >> Pawn.Rotation) * DistFromTarget );
	//DrawDebugLine( EnemyLoc, TargetLoc, 255, 0, 0, TRUE );
    ThrowTesla( TargetLoc ) ;

    TargetLoc = (EnemyLoc - ForwardOffset) + ( (vect(0,-1,0) >> Pawn.Rotation) * DistFromTarget );
	//DrawDebugLine( EnemyLoc, TargetLoc, 255, 0, 0, TRUE );
    ThrowTesla( TargetLoc ) ;
}


function Pushed()
{
	super.Pushed();
	SavedGroundSpeed = Pawn.GroundSpeed;
	Pawn.GroundSpeed = 2000;
	GotoState( 'DoCharge' );
}

function Popped()
{
	super.Popped();
    Pawn.GroundSpeed = SavedGroundSpeed;
}



function Resumed( name OldCommandName )
{
    super.Resumed( OldCommandName );
}


function DoTelegraph()
{
    PSC_TelegraphEffect = WorldInfo.MyEmitterPool.SpawnEmitter( TelegraphEffect, MyBull.Location, rot(0,0,0), Pawn );

	if( MyBull.RidingPawn != none )
	{
		MyBull.PlaySound( TelegraphSound );
	}
	else
	{
		PlaySound( TelegraphSound, FALSE, FALSE, TRUE, ChargeLocation );
	}

}


State DoCharge
{
	simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_CombatRanged'; }

	simulated function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
	}

	simulated function ChargePlayer()
	{
		MoveToLocation( ChargeLocation, 5.0f, TRUE );
	}

	/** This will determine if we should launch tesla coils or not. **/
	simulated function PossiblyLaunchTeslaCoils()
	{
		// for now just do a distance check
		if( VSize( ChargeLocation - Pawn.Location ) > 1024.0f )
		{
		    LaunchTeslaCoilsAtTarget();
		}
	}
	
Begin:
	DoTelegraph();
	PossiblyLaunchTeslaCoils();
	Sleep( 2.0f );
	PSC_TelegraphEffect.DeactivateSystem();
	ChargePlayer();
	PopCommand( self ); // this is popping ourself (the charge command) and gives control back to the AIController)
}


defaultproperties
{
	TelegraphEffect=ParticleSystem'Nano_FX.Effects.P_FX_SpringerHover_01'
	TelegraphSound=SoundCue'Gameplay_Audio.Densify.Densify_Bend_Cue'
}