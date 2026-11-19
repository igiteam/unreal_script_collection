/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** base class for Actors that move along a matinee track when player(s) get close to them */
class GearTrackActor extends GearMeleeTarget
	native
	abstract
	config(Game);

/** matinee that is used to move the bomb along its track */
var SeqAct_Interp TrackMatinee;
/** current position on the matinee track */
var repnotify float TrackPosition;
/** all friendly players in this radius cause us to move along the track */
var config float MovementRadius;
/** multiplier to world time that the bomb moves along its matinee path per player within the radius */
var config float MovementPctPerPlayer;
/** maximum movement multiplier */
var config float MaxMovementPct;
/** number of points players obtain each second they are pushing the bomb */
var config int PointsForMovingPerSec;
/** time remaining until we will award moving points */
var float AwardPointsTimeRemaining;
/** ring effect that is colorized while the bomb is moving */
var ParticleSystemComponent RingEffect;
/** parameter for the ring effect color */
var name RingEffectColorParam;
/** color for ring effect when we're not moving */
var vector RingStoppedColor;

replication
{
	if (bNetDirty)
		TrackPosition;
}

/** @FIXME: debug code that draws the bomb path using the line batcher */
native final function DrawBombPath();

simulated event PreBeginPlay()
{
	local array<SequenceObject> SeqObjList;
	local int i;
	local Actor RelativeActor;

	WorldInfo.GetGameSequence().FindSeqObjectsByName("TheBomb", true, SeqObjList, true);
	for (i = 0; i < SeqObjList.length; i++)
	{
		TrackMatinee = SeqAct_Interp(SeqObjList[i]);
		if (TrackMatinee != None)
		{
			// force the track matinee to not use its own replication
			TrackMatinee.bClientSideOnly = true;
			// the matinee may be relative, so start in the location of the linked Actor (if any)
			RelativeActor = Actor(SeqVar_Object(TrackMatinee.VariableLinks[1].LinkedVariables[0]).GetObjectValue());
			if (RelativeActor != None)
			{
				SetLocation(RelativeActor.Location);
			}
			// insert ourselves in the matinee
			SeqVar_Object(TrackMatinee.VariableLinks[1].LinkedVariables[0]).SetObjectValue(self);
			// 0 is "play"
			TrackMatinee.ForceActivateInput(0);
			// 3 is "pause"
			TrackMatinee.ForceActivateInput(3);
			TrackMatinee.SetPosition(0.0);
			TrackPosition = 0.0;
			break;
		}
	}

	if (TrackMatinee == None)
	{
		`Warn("Failed to find track matinee named \"TheBomb\"");
	}

	Super.PreBeginPlay();
}

/** verify that the matinee is active and playing; turn it on if not */
simulated final function VerifyMatineeActive()
{
	if (!TrackMatinee.bActive)
	{
		// 0 is "play"
		TrackMatinee.ForceActivateInput(0);
		// 3 is "pause"
		TrackMatinee.ForceActivateInput(3);
	}
	else if (!TrackMatinee.bIsPlaying)
	{
		TrackMatinee.bIsPlaying = true;
	}
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(TrackPosition))
	{
		TrackMatinee.SetPosition(TrackPosition);
		VerifyMatineeActive();
	}
}

/** this is a client friendly version of LineOfSightTo() */
simulated function bool CanBeSeenBy(GearPawn P)
{
	local vector EyeLoc, X, Y, Z;
	local float Radius, Height;

	EyeLoc = P.Location;
	EyeLoc.Z += P.BaseEyeHeight;
	// first test center
	if (FastTrace(Location, EyeLoc,, true))
	{
		return true;
	}
	else
	{
		// try sides
		GetBoundingCylinder(Radius, Height);
		GetAxes(rotator(EyeLoc - Location), X, Y, Z);
		Y.Z = 0.0;
		Y = Normal(Y);
		return (FastTrace(Location + Y * Radius, EyeLoc,, true) || FastTrace(Location - Y * Radius, EyeLoc,, true));
	}
}

/** @return whether it's currently valid for us to move along the matinee track */
simulated function bool CanMove()
{
	return TrackMatinee.bIsPlaying && TrackMatinee.Position < TrackMatinee.InterpData.InterpLength;
}

/** @return the amount the given Pawn should add to the matinee's movement rate (return zero to ignore this Pawn for movement) */
simulated function float GetMovementPctFor(GearPawn P)
{
	return MovementPctPerPlayer;
}

/** called when successful movement has occurred; for subclasses to trigger events based on progress and such (server only) */
function CheckProgress(float AmountMoved);

/** @return the color that should be used for the ring surrounding our movement radius */
simulated function vector GetRingMovementColor(float AmountMoved);

simulated event Tick(float DeltaTime)
{
	local GearPawn P;
	local float AmountToMove, MovementPct;
	local bool bAwardPoints, bCheckedAwardPoints;

	if (CanMove())
	{
		// advance the track position DeltaTime seconds for each GearPawn on our team in the radius
		foreach WorldInfo.AllPawns(class'GearPawn', P)
		{
			if ( (P.Health > 0 || P.IsDBNO()) && P.Physics != PHYS_RigidBody &&
				VSize(P.Location - Location) < MovementRadius && CanBeSeenBy(P) )
			{
				MovementPct = GetMovementPctFor(P);
				if (MovementPct != 0.0)
				{
					AmountToMove += MovementPct * DeltaTime;
					if (Role == ROLE_Authority)
					{
						if (!bCheckedAwardPoints)
						{
							AwardPointsTimeRemaining -= DeltaTime;
							if (AwardPointsTimeRemaining <= 0.0)
							{
								bAwardPoints = true;
								AwardPointsTimeRemaining += 1.0;
							}
							bCheckedAwardPoints = true;
						}
						if (bAwardPoints)
						{
		     GearPRI(P.PlayerReplicationInfo).ScoreGameSpecific1(`StatId(SCORE_PUSH_BOMB), PointsForMovingPerSec, true);
						}
					}
				}
			}
		}
		if (MaxMovementPct > 0.0)
		{
			AmountToMove = FClamp(AmountToMove, -MaxMovementPct, MaxMovementPct);
		}

		if (AmountToMove != 0.0)
		{
			TrackMatinee.SetPosition(TrackMatinee.Position + AmountToMove);
			if (Role == ROLE_Authority)
			{
				TrackPosition = TrackMatinee.Position;
				CheckProgress(AmountToMove);
			}
			RingEffect.SetVectorParameter(RingEffectColorParam, GetRingMovementColor(AmountToMove));
		}
		else
		{
			RingEffect.SetVectorParameter(RingEffectColorParam, RingStoppedColor);
		}
	}

	DrawBombPath();
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	NetUpdateFrequency=10.0
	bAlwaysRelevant=true
	bUpdateSimulatedPosition=false
	bReplicateMovement=false
	Physics=PHYS_Interpolating
}
