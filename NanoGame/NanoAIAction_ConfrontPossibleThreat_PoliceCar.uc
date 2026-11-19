/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_ConfrontPossibleThreat_PoliceCar extends NanoAIAction within NanoAI_PoliceCar;

/** Range to engage the player at */
var float EngagementRange;

var transient StimulusInfo CurrBestStim;

/** How often we stop and just unleash a hail of bullets **/
var float TimeBetweenFireMiniGun;

/** How long to fire the mini gun **/
var float DurationToFireMiniGun;

/** Next time to stop and fire! **/
var transient float TimeToDoFireMiniGun;

var transient float TimeStartedFiring;


var SoundCue PreFiringWarningSound;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local array<int> StimulusIndices;

	local StimulusQuery ModifiedConfrontThreatQuery;

	local NanoPC NPC;
	local bool bWithinDefendRadius;


	//`AIlog_Ext( "NanoAIAction_ConfrontPossibleThreat_PoliceCar GetUtility()" ,, InAI );


	ModifiedConfrontThreatQuery = NanoAI(InAI).ConfrontPossibleThreatQuery;

	ModifiedConfrontThreatQuery.bRequireDamaged = TRUE;
	ModifiedConfrontThreatQuery.bDisregardChaosOverride_RequireDamaged = TRUE;


	if( (InAI.Enemy != None) 
		|| (InAI.MultipleResultStimulusQuery( NanoAI(InAI).ConfrontPossibleThreatQuery, StimulusIndices ) > 0) 
		
		)
	{
		Retval = default.UtilityStartVal + 50;
	}


	foreach InAI.WorldInfo.AllControllers( class'NanoPC', NPC )
	{
		break;
	}

	bWithinDefendRadius = ( VSize(NPC.Pawn.Location - InAI.Pawn.Location) < NanoAI(InAI).ConfrontPossibleThreatQuery.MaxDist );



	ModifiedConfrontThreatQuery = NanoAI(InAI).ConfrontPossibleThreatQuery;

	ModifiedConfrontThreatQuery.bRequireDamaged = FALSE;


	if( ( NanoGRI(InAI.WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
		&& ( bWithinDefendRadius == TRUE )
		&& ( InAI.MultipleResultStimulusQuery( ModifiedConfrontThreatQuery, StimulusIndices ) > 0 )
		)
	{
		//`AILog_Ext( "INSIDE RadiusToDefend",, InAI );
		Retval += default.UtilityStartVal + 50;
	}

	// MOVE to the player if we are not near them and chaos is up
	if( ( NanoGRI(InAI.WorldInfo.GRI).GetCurrentChaosLevel() > 0 ) 
		&& ( bWithinDefendRadius == FALSE )
		)
	{
		Retval += default.UtilityStartVal + 250;
	}



	return Retval;
}

function Pushed()
{
	Super.Pushed();

	SetMood(AIMood_Aggressive);

	if( MyCar != None )
	{
		MyCar.PossiblyActivateSpotLight();
		MyCar.SetSearchLightActiveColor( TRUE );
		MyCar.ActivateLightBar();
		//MyCar.SetDefaultTilt( rot(4096,0,0) );
		MyCar.SetEngineSpeedSound(TRUE);

		MyCar.PanicCrowds( TRUE );

		// Increase the maximum pursuit speed
		MyCar.AirSpeed = 2000.f;
	}
}

function Popped()
{
	Super.Popped();

	if( MyCar != None )
	{
		MyCar.DeactivateSpotLight();
		MyCar.SetSearchLightActiveColor( FALSE );
		MyCar.DeactivateLightBar();
		//MyCar.SetDefaultTilt( rot(0,0,0) );
		MyCar.SetEngineSpeedSound(FALSE);

		MyCar.PanicCrowds( FALSE );

		MyCar.AirSpeed = MyCar.default.AirSpeed;
	}
}

function SetTargetedTilt()
{
	local vector ToTilt;

	ToTilt = Normal(Focus.Location - Pawn.Location);

	MyCar.SetDefaultTilt( rotator(ToTilt) * 4096 );
}


state ConfrontPossibleThreat
{
	function float RateStimulus(int Index)
	{
		return 1.f;
	}

	function vector GetEngagementLocation(vector TargetLocation, Actor EnemyActor)
	{
		local vector Displacement, FromEnemy;
		local NanoPawn EnemyPawn;
		local Rotator Variance;

		EnemyPawn = NanoPawn(EnemyActor);
		if( EnemyPawn != None )
		{
			FromEnemy = Normal(Pawn.Location - EnemyActor.Location);
			// If the car isn't in front of the enemy pawn, try to get there
			if( FromEnemy dot vector(EnemyActor.Rotation) < 0.7071f )
			{
				// Add in a little random factor, so the cop car isn't always immediately in front of you
				Variance.Yaw = Rand(4096);
				Variance.Yaw -= 2048;

				return EnemyPawn.Location + EngagementRange * vector(EnemyPawn.Rotation + Variance);
			}
		}

		// Otherwise, the default case, try to get in front of the player
 		Displacement = Pawn.Location - TargetLocation;
 		Displacement = EngagementRange * Normal(Displacement);
		Displacement.Z = 128.0f;

		return (TargetLocation + Displacement);
	}


	function LostEnemy()
	{
		`AILog("Police car lost enemy  popping state.");
		SetFireTarget( None );
		Focus = None;

		//NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_PoliceCar_LostPawn, Pawn);

		PopCommand(self);
	}


	function CheckForStimulus()
	{
		local StimulusQuery ModifiedConfrontThreatQuery;

		local array<int> StimulusIndices;
		local float Rating, BestRating;
		local int Index, BestStimulusIdx;
		local StimulusInfo BestStim;


		ModifiedConfrontThreatQuery = ConfrontPossibleThreatQuery;

		// so if we are in chaos we we are going to have a MASSSIVE search radius to find the player
		if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
		{
			ModifiedConfrontThreatQuery.MaxDist = 35000;
			ModifiedConfrontThreatQuery.bRequireCombative = QO_Allow;
			ModifiedConfrontThreatQuery.bRequireDamaged = FALSE;
		}


		//`AILog( GetFuncName()  @ `showvar(ModifiedConfrontThreatQuery.bDisregardChaosOverride_RequireDamaged) @ `showvar(ModifiedConfrontThreatQuery.bRequireDamaged) );

		MultipleResultStimulusQuery( Enemy != None ? ModifiedConfrontThreatQuery : ModifiedConfrontThreatQuery, StimulusIndices );

		//`AILog( GetFuncName() @ `showvar(StimulusIndices.Length));

		// Rank the current stimuli, and determine if we're looking at a pawn that we're interested in
		BestStimulusIdx = -1;
		foreach StimulusIndices(Index)
		{
			Rating = RateStimulus(StimulusIndices[Index]);

			//`AILog(GetFuncName()@Stimuli[Index].Actor@`showvar(Rating));

			if( (Rating > BestRating) || (BestStimulusIdx == -1) )
			{
				BestStimulusIdx = Index;
				BestRating = Rating;
			}
		}

		//`AILog( GetFuncName() @ `showvar(BestStimulusIdx) );



		// If we have a valid stimulus...
		if( BestStimulusIdx != -1 )
		{
			ClearTimer( nameof(LostEnemy), self );

			// Play a spotted dialog line if this is the first time we're picking up the pawn
			if( Enemy == None )
			{
				if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
				{
					NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_PoliceCar_SpotPawn, Pawn);
					Pawn.SetTimer( 5.0f, FALSE, nameof(NanoPawn_MetaCorp_PoliceCarBase(Pawn).PlayYelperSound) );
				}
				else
				{
					NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_PoliceCar_SpotPawnNotInCombat, Pawn);
				}

			}

			BestStim = Stimuli[BestStimulusIdx];
			CurrBestStim = BestStim;

			`AILog("  Found a Stimulus " $ `showvar(CurrBestStim.Location)  @ `showvar(CurrBestStim.Actor) );

 			if( BestStim.bVisible )
 			{
 				Alert_PendingFocus = BestStim.Actor;
 				Enemy = NanoPawnBase(BestStim.Actor);
 			}
 			else
 			{
 				Alert_PendingFocalPoint = BestStim.Location;
 			}

			// If we're not facing the stimulus direction, do so now
			if( Normal(BestStim.Location - Pawn.Location) DOT vector(Pawn.Rotation) < 0.3f )
			{
 				GotoState(GetStateName(),Alert_PendingFocus!=None?'TurnTowardsFocus':'TurnTowardsPoint');
			}
			else
			{
				// Stay higher up if we've been damaged by the stimulus, otherwise, get in close
				if( BestStim.bDamaged )
				{
					CruisingAltitude = Outer.default.CruisingAltitude;
				}
				else
				{
					CruisingAltitude = 0.5f * Outer.default.CruisingAltitude;
				}
			}
		}
		else
		{
			// If we've had no stimulus, set a timer before giving up the chase
			if( ( !IsTimerActive(nameof(LostEnemy), self) )
				&& ( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() == 0 ) // only ever set this if there is no chaos otherwise hunt down the rebels
				)
			{
				SetTimer( 5.f, FALSE, nameof(LostEnemy), self );
			}
		}
	}


	function FindRebelsAndChaseThem()
	{
		local NanoPawn NP;

		if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
		{
			`AILog( GetFuncName() @ "!!!!! just find the pawn and mess them up") ;
			NP = NanoPawn(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn);
			Enemy = NP;

			MoveToLocation( NP.Location );
		}
	}


	function BeginState( name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		TimeToDoFireMiniGun = WorldInfo.TimeSeconds + TimeBetweenFireMiniGun;
	}

Begin:

	if( Enemy == None )
	{
		FindRebelsAndChaseThem();
	}
	else
	{
		CheckForStimulus();
	}

	if( MyCar != None )
	{
		MyCar.PossiblyActivateSpotLight();
	}


	if( ( TimeToDoFireMiniGun < WorldInfo.TimeSeconds )
		&& ( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
		)
	{
		// stop and tear it up

		Pawn.ZeroMovementVariables();

		// FIRE FIRE FIRE
		`log( "FIRING!!!!!" );
		Pawn.PlaySound( PreFiringWarningSound ); // this is 5.29 seconds
		Sleep( 5.0f );

		TimeStartedFiring = WorldInfo.TimeSeconds;
		StartFiring();

		CruisingAltitude=256.0f;
		MyCar.SetDefaultTilt( rot(0,0,-2048) );

		// do a strafing run
		Focus = FireTarget;
		do 
		{
			Sleep(0.25f);
			
			`AILog("Turning towards pawn " $ Focus);
		} until( `TimeSince(TimeStartedFiring) > DurationToFireMiniGun );
		
		MyCar.SetDefaultTilt( rot(0,0,0) );
		CruisingAltitude=512.0f;

		StopFiring();


		TimeToDoFireMiniGun = WorldInfo.TimeSeconds + TimeBetweenFireMiniGun;

	}
	// only do this if the BestTime is within EngagementRange
	else if( VSize( Pawn.Location - CurrBestStim.Location) < EngagementRange )
	{
		`AILog("  Starting Move GetEngagementLocation " );
		// maybe just remove this and try location as that seems to work better 
		MoveToLocation( GetEngagementLocation(CurrBestStim.Location, CurrBestStim.Actor) );
	}
	else
	{
		`AILog("  Starting Move MoveToLocation " );
		MoveToLocation( CurrBestStim.Location );
	}

	`AILog("  Finished Move " $ `showvar(CurrBestStim.Location)  @ `showvar(CurrBestStim.Actor) );

	Sleep(0.1f);

	Goto('Begin');

TurnTowardsFocus:
	Focus = Alert_PendingFocus;
	do 
	{
		Sleep(0.25f);
		`AILog("Turning towards pawn " $ Focus);
	} until( Normal(Focus.Location - Pawn.Location) dot vector(Pawn.Rotation) > 0.3 );

	Goto('Begin');

TurnTowardsPoint:
	SetFocalPoint(Alert_PendingFocalPoint);
	do 
	{
		Sleep(0.25f);
		`AILog("Turning towards location " $ GetFocalPoint());
	} until( Normal(GetFocalPoint() - Pawn.Location) dot vector(Pawn.Rotation) > 0.3 );

	Goto('Begin');
}


defaultproperties
{
	StartingStateName="ConfrontPossibleThreat"

	EngagementRange=1200.f

	TimeBetweenFireMiniGun=12.0f
	DurationToFireMiniGun=7.0f
	PreFiringWarningSound=SoundCue'Dialog_Temp.PoliceCar.PoliceCar_PA_PreFireMiniGunWarning_Cue'
}