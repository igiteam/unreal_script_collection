/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoSkill_Jump extends NanoSkill
	native(Pawn)
	config(Pawn);

struct native JumpLevelInfo
{
	var config float JumpHoldToMaxBoostTime;
	var config float RunUpwardVelocity;		// Run/jog upward movement
	var config float DashUpwardVelocity;	// Dashing upward movement
	
	var config float RunForwardVelocity;	// Run/jog forward movement
	var config float DashForwardVelocity;	// Dashing forward movement

	var config float MaxFallVelocity, MinFallVelocity;
	var config float NanoJumpCost;
	var config int	 AutoTargetPitch;
	var config float AutoTargetPitchSpeed;
	var config float MaxGravityZScale;
	var config float MaxStabMantleHeight;
	var config float PerchJumpBoost;
	var config float SpringJumpBoost;
	var config float HandspringJumpBoost;

	var config float LiftGravityScale;
	var config float ApexHoldTime;
	var config float ApexGravityZScale;
	var config float RunDropGravityZScale;
	var config float DashDropGravityZScale;
	var config float DropBoostTime;
};
var() config array<JumpLevelInfo> JumpLevels;
var			 float	JumpHoldToMaxBoostCounter;

struct native DodgeInfo
{
	var() EComboJoyDirection Dir;
	var() Name				 SpecialMoveName;

	var() bool	bOverPawn;
	var() Name	VictimAnimName;
};
var() array<DodgeInfo> DodgeList;
var() float			   DodgeOverPawnCheckDist;

//debug
var			 Vector	MaxOfJump;
var			 Vector JumpOrigin;
var			 float	ApexOfJumpTime;
var			 float	BoostTimerExpiredTime;

/** Last jump level we completed */
var transient int LastJumpLevel;

/** How far from the pawn to trace to find a wall */
var config float WallJumpTraceDist;

var protected SoundCue JumpCue;
var protected SoundCue JumpEffortCue;
var protected SoundCue JumpEffortTripleCue;

/** This sound is played when you reach your max boost amount.  So the player has an aural sound to let them know they can release the button **/
var protected SoundCue ReachedMaxJumpBoostCue;

var(Debug) config bool bDebugJumpArc;
var(Debug) config bool bDebugJumpCyl;
var(Debug) Vector LastJumpLoc;



`define jump_log(msg)	`loginfo('Nano_Locomotion',`msg)

`if(`notdefined(FINAL_RELEASE))
simulated event Tick(float DeltaTime)
{
	Super.Tick( DeltaTime );

	if( bActive && PawnOwner.Location.Z > MaxOfJump.Z )
	{
		MaxOfJump.Z = PawnOwner.Location.Z;
	}
	MaxOfJump.X = PawnOwner.Location.X;
	MaxOfJump.Y = PawnOwner.Location.Y;

	if( PawnOwner != None )
	{
		if( bDebugJumpArc )
		{
			if( bDebugJumpCyl )
			{
				PawnOwner.DrawDebugBox( LastJumpLoc, PawnOwner.GetCollisionExtent(), 255, 0, 0, TRUE );
			}		

			PawnOwner.DrawDebugLine( LastJumpLoc, PawnOwner.Location, 255, 0, 0, TRUE );
			LastJumpLoc	= PawnOwner.Location;		
		}
	}

	if( bActive )
	{
		if( (PawnOwner.MantleState != MANTLE_None && PawnOwner.MantleState != MANTLE_Jump && PawnOwner.MantleState != MANTLE_FlipJump) || PawnOwner.CurrNanoState != ENS_Normal )
		{
			if( ApexOfJumpTime > 0.f )
			{
				DeactivateSkill();
			}
		}
	}
}
`endif

simulated protected function InternalActivated()
{
	Super.InternalActivated();

	PawnOwner.bIsJumping = TRUE;
	LastJumpLoc	= PawnOwner.Location;

	if( bDebugJumpArc )
	{
		PawnOwner.FlushPersistentDebugLines();
	}
}

simulated protected function InternalDeactivated()
{
	Super.InternalDeactivated();

	PawnOwner.bIsJumping = FALSE;
	PawnOwner.JumpHoldTime = -1.f;
	PawnOwner.JumpHoldGravityZScale = 1.f;

	PawnOwner.DisableFakeGhostEffects();
}

simulated event int GetMaxJumpLevel( NanoPawn NP )
{
	if( SkillLevel < SkillLevels.Length-1 )
	{
		return Min(SkillLevel,JumpLevels.Length-1);
	}
	return (JumpLevels.Length - 1);
}

/** Return how high we can jump up to reach a stab mantle target */
simulated function float GetMaxStabMantleHeight( NanoPawn NP )
{
	return JumpLevels[GetMaxJumpLevel(NP)].MaxStabMantleHeight;
}

function int GetJumpLevel( NanoPawn NP )
{
		return 0;
}


function int GetJumpLevelInfo
( 
	NanoPawn NP, 
	int MaxJumpLevel, 
	float JumpHoldTime, 
	optional Vector StickDir, 
	optional out int out_NanoJumpCost, 
	optional out Byte out_bIsNearWall, 
	optional out Vector out_WallNormal, 
	optional out Vector out_WallLocation,
	optional bool bTest
)
{
	local NanoPerchPoint Perch;
	local int JumpLevel, Level;
	local int Cost;

	JumpLevel = -1;
	// if already jumping or invalid pawn then no jumpy jump!
	if( NP != None )
	{
		Perch = NanoPerchPoint(NP.Base);
		// if perching then use base level jump
		if((Perch != None) || NP.IsAttachedToPerch())
		{
			JumpLevel = 0;
		}
		// if attached to or near a wall then use base level jump
		else if( NP.Physics == PHYS_Falling )
		{
			`jump_log("falling jump"@`showvar(NP.bIsAttachedToWall) @`TimeSinceEx(NP,NP.LastFallOffLedgeTime));
			if (`TimeSinceEx(NP,NP.LastFallOffLedgeTime) < 0.25f)
			{
				`jump_log("extra window jump");
				JumpLevel = GetJumpLevel( NP );
			}
			else if (NP.MantleState == MANTLE_EndingMantle)
			{
				JumpLevel = 0;
			}
			else if( NP.bIsAttachedToWall )
			{
				`jump_log("jump off wall");

				NP.bJustDidWallJump = TRUE;
				out_bIsNearWall = 1;
				JumpLevel = GetJumpLevel( NP );
			}
			else if( bTest )
			{
				JumpLevel = GetJumpLevel( NP );
			}
		}
		// if on the ground
		else if( NP.Physics == PHYS_Walking )
		{
			`jump_log("walking jump"@`showvar(MaxJumpLevel)@`showvar(JumpHoldTime));

			JumpLevel = GetJumpLevel( NP );
		}

		JumpLevel = Min(JumpLevel,MaxJumpLevel);
		if( JumpLevel >= 0 )
		{
			for( Level = JumpLevel; Level >= 0; Level-- )
			{
				JumpLevel = -1;
				Cost = JumpLevels[Level].NanoJumpCost;
				if( NP.GetNanoPower() >= Cost )
				{
					out_NanoJumpCost = Cost;
					JumpLevel = Level;
					break;
				}
			}

			if( JumpLevel < 0 )
			{
				`jump_log("nano juice constrained jump");
				// drop back to the basic jump
				JumpLevel = 0;
				out_NanoJumpCost = NP.GetNanoPower();
			}
		}
	}
	
	return JumpLevel;
}

simulated function bool AttemptDodge( NanoPawn NP, Vector StickDir )
{
	local EComboJoyDirection DodgeDir;
	local int DodgeIdx;
	local Rotator Rot;
	local NanoPawn DodgeVictim;
	local Actor HitActor;
	local Vector HitLocation, HitNormal;
	local Vector DodgeAxis;
	local NanoGRI NGRI;
	local NanoPC PC;

	if( PawnOwner.CanDoSpecialMove( 'NSM_GhostDash' ) )
	{
		PawnOwner.DoSpecialMove( 'NSM_GhostDash' );
		return TRUE;
	}
		
	if( NP == None || 
		NP.MantleState != MANTLE_None || 
		NP.CurrentLadder != None || 
		(NP.bIsDoingMeleeAttack && NP.bPreventJumpInMeleeAttack && !NP.bRecoveringFromMeleeAttack) || 
		(NP.bDodging && !NP.bRecoveringFromDodge) || 
		(NP.Physics != PHYS_Walking && NP.InteractionPawn == None) )
	{
		return FALSE;
	}

	if( NP.InteractionPawn != None )
	{
		if( NP.InteractionType == PAWNINTER_Pin )
		{
			NP.EndSpecialMove();
		}
		else
		{
			return FALSE;
		}
	}

	Rot.Yaw = GetCameraRotation(NP).Yaw;;
	DodgeDir = NP.GetJoyDirection( Rot, StickDir, DodgeAxis );



	//NP.FlushPersistentDebugLines();
	//NP.DrawDebugLine( NP.Location, NP.Location + Vector(NP.Rotation) * 64.f, 255, 0, 0, TRUE );
	//NP.DrawDebugLine( NP.Location, NP.Location + StickDir * 64.f, 0, 255, 0, TRUE );
	//NP.DrawDebugLine( NP.Location, NP.Location + Vector(Rot) * 64.f, 0, 0, 255, TRUE );
	`log( `location@`showvar(DodgeDir) );

	if( DodgeDir != CJD_None )
	{
		HitActor = NP.Trace( HitLocation, HitNormal, NP.Location + DodgeAxis * DodgeOverPawnCheckDist, NP.Location, TRUE, NP.GetCollisionExtent() );
		DodgeVictim = NanoPawn(HitActor);
		if( DodgeVictim != None && (DodgeVictim.Health <= 0 || DodgeVictim.IsSameTeam(NP)) )
		{
			DodgeVictim = None;
		}

		for( DodgeIdx = 0; DodgeIdx < DodgeList.Length; DodgeIdx++ )
		{
			if( DodgeList[DodgeIdx].Dir != DodgeDir )
			{
				continue;
			}

			if( ( DodgeList[DodgeIdx].bOverPawn && DodgeVictim == None) ||
				(!DodgeList[DodgeIdx].bOverPawn && DodgeVictim != None) )
			{
				continue;
			}

			PC = NanoPC(NP.Controller);
			if( PC.CanDoSpecialMove( DodgeList[DodgeIdx].SpecialMoveName ) ) 
			{
				Rot.Yaw = Rotator(DodgeAxis).Yaw;
				NP.SetRotation( Rot );
				NP.SetDesiredRotation( Rot );

				PC.DoSpecialMove( DodgeList[DodgeIdx].SpecialMoveName,, DodgeVictim );

				NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
				if( NGRI != None )
				{
					if( DodgeVictim != None && !DodgeVictim.IsHumanControlled() )
					{
						NGRI.AttemptToPlayLine(EDLine_Combat_MeleeCircle_DodgeWhiff, DodgeVictim);
					}

					if( NGRI.AIBlackboard != None )
					{
						NGRI.AIBlackboard.HandleCombatEvent( NCAT_PlayerDodged, None );
					}
				}

				return TRUE;
			}
		}
	}

	return FALSE;
}

simulated function bool AttemptJump(NanoPawn NP, vector StickDir, optional bool bApplyForwardVelocity, optional float JumpHoldTime)
{
	local int JumpLevel, MaxJumpLevel, NanoJumpCost;
	local byte bIsNearWall;
	local vector WallNormal, WallLoc;
	local NanoPC PC;
	local Rotator ViewRot;
	local NanoPerchPoint Perch;
	local NanoWeap_Melee Weap;
	
	`jump_log(NP.WorldInfo.TimeSeconds@"ATTEMPT JUMP");

	// if already jumping or invalid pawn then no jumpy jump!
	if( NP == None )
	{
		return FALSE;
	}

	if( NP.TeslaShock_NoJump_ActiveUntil > NP.WorldInfo.TimeSeconds )
	{
		return FALSE;
	}


	if( NP.InteractionPawn != None )
	{
		if( NP.InteractionType == PAWNINTER_Pin )
		{
			NP.EndSpecialMove();
		}
		else
		{
			return FALSE;
		}
	}

	if( NP.bIsDoingMeleeAttack && NP.bPreventJumpInMeleeAttack && !NP.bRecoveringFromMeleeAttack )
	{
		return FALSE;
	}

	// if mantle then consume the attempt and set a flag for the mantle code to jump upon finish
	if( NP.MantleState != MANTLE_None && NP.MantleState != MANTLE_EndingMantle )
	{
		return TRUE;
	}

	Perch = NanoPerchPoint(NP.Base);

	//FlushPersistentDebugLines();
	`jump_log(`location@`showvar(LastJumpLevel)@VSize(NP.Velocity));
	PC = GetPC();

	NP.ClearTimer(nameof(ResetJumpLevel),self);

	// figure out what kind of jump this is
	MaxJumpLevel = GetMaxJumpLevel(NP);
	JumpLevel = GetJumpLevelInfo( NP, MaxJumpLevel, JumpHoldTime, StickDir, NanoJumpCost, bIsNearWall, WallNormal, WallLoc );

	// so if were were not atually doing a jump (i.e. were falling down still)
	if( JumpLevel < 0 )
	{
		NP.LastFailedJumpAttemptTime = NP.WorldInfo.TimeSeconds;
		return FALSE;
	}

	// if we have enough power for the jump
	if( NP.HasEnoughNanoPower( NanoJumpCost, TRUE ) == TRUE )
	{
		// Don't allow a new jump if already active and it's not a wall jump
		if( bActive )
		{
			return FALSE;
		}

		Weap = NanoWeap_Melee(NP.Weapon);
		if( Weap != None )
		{
			if( NP.bIsDoingMeleeAttack )
			{
				NP.ZeroMovementVariables();
			}
			Weap.GotoState('Active');
		}

		`jump_log("jumping:"@JumpLevel);
		if( !bActive )
		{
			// activate the skill
			ActivateSkill();
		}
		// and apply the actual jump
		if (NP.bIsAttachedToWall)
		{
			NP.DetachFromWall();

			if( PC.PlayerInput.RawJoyUp < -0.5 )
			{
				ViewRot = PC.Rotation;
				ViewRot.Yaw = Rotator(-NP.WallAttachNormal).Yaw;
				PC.InterpViewRotation( ViewRot, 0.25f );
			}
		}
		else if( bIsNearWall != 0 )
		{
			ViewRot = PC.Rotation;
			ViewRot.Yaw = Rotator(WallNormal).Yaw;
			PC.InterpViewRotation( ViewRot, 0.25f );
		}

		if( Perch != None )
		{
			assert(Perch.LockedPawn == NP); // Check pointers match
			NP.LocalEndSpecialMove('NSM_PerchOnPoint');
		}
	
		NP.ConsumeNanoPower(NanoJumpCost);
		ApplyJumpVelocity( JumpLevel, FALSE, (bIsNearWall!=0?TRUE:FALSE), WallNormal, bApplyForwardVelocity, StickDir );

		// save the last jump level for sequential jumps
		LastJumpLevel = MaxJumpLevel;
		ActiveSkillLevel = MaxJumpLevel;
		JumpHoldToMaxBoostCounter = 0.f;

		// audio efforts
		PC.PlaySound( JumpCue );
		// only play the jump effort sound on the "big" jumps
		if( JumpLevel == 1 )
		{
			PC.PlaySound( JumpEffortCue );
		}
		else if( JumpLevel == 2 )
		{
			PC.PlaySound( JumpEffortTripleCue );
		}

		// Fire kismet event
		if(JumpLevel == 2)
		{
			NP.TriggerEventClass(class'SeqEvt_NanoActionPerformed', NP, 1);
		}
		else
		{
			NP.TriggerEventClass(class'SeqEvt_NanoActionPerformed', NP, 0);
		}

		// if this is a client then save important information for the next server move
		if (NP.Role < ROLE_Authority)
		{
			NP.LastWallJumpNormal = (bIsNearWall!=0) ? WallNormal : vect(0,0,0);
			NP.bLastJumpWasForward = bApplyForwardVelocity;
		}

		// Remember when we jumped
		NP.LastJumpTime = NP.WorldInfo.TimeSeconds;
		NP.LastJumpDir  = Vector(NP.Rotation);

		NP.bStabMantling = FALSE;

		// Notify on the apex of the jump so we can check for skydiving
		NP.Controller.bNotifyApex = TRUE;

		return TRUE;
	}
	else
	{
		return FALSE;
	}
}


/** We want to get:  FLOAT MaxSpeed = GroundSpeed * MaxSpeedModifier(); **/
native function vector GetMaxVelocityPossible( NanoPawn InPawn ); // const;

simulated function Rotator GetCameraRotation( optional NanoPawn NP )
{
	local Vector CamLoc;
	local Rotator CamRot;

	if( NP == None )
	{
		NP = PawnOwner;
	}

	CamRot = NP.Rotation;
	if( NP.IsHumanControlled() )
	{
		NP.GetActorEyesViewPoint(CamLoc,CamRot);
	}
	return CamRot;
}

simulated event Vector GetJumpForwardVelocity( Vector StickDir, bool bApplyForwardVelocity, bool bIsNearWall, Vector WallNormal )
{
	local Vector Result;
	
	Result = PawnOwner.Velocity;
	if( NanoVehicleAgent(PawnOwner.Base) != None )
	{
		Result = vector(PawnOwner.Rotation) * 512.f;
	}
	// if wall jump then flip the current velocity
	else if( bIsNearWall )
	{
		Result  = PawnOwner.Velocity >> rotator(WallNormal);
		Result += WallNormal * JumpLevels[SkillLevel].RunForwardVelocity;
	}
	else if( !IsZero( StickDir ) )
	{
		if( bApplyForwardVelocity )
		{
			if( PawnOwner.bIsDashing )
			{
				Result = Vector(PawnOwner.DesiredRotation) * JumpLevels[SkillLevel].DashForwardVelocity;
			}
			else
			{
				Result = Vector(PawnOwner.DesiredRotation) * JumpLevels[SkillLevel].RunForwardVelocity;
			}
		}
	}

	return Result;
}

simulated event Vector GetJumpUpwardVelocity( Vector StickDir )
{
	local Vector Result;
	if( PawnOwner.bIsDashing && PawnOwner.MantleState == MANTLE_None )
	{
		Result = vect(0,0,1) * JumpLevels[SkillLevel].DashUpwardVelocity;
	}
	else
	{
		Result = vect(0,0,1) * JumpLevels[SkillLevel].RunUpwardVelocity;

		if( VSize2D(PawnOwner.Velocity) < 64.f )
		{
			//@fixme - there's an unknown z contribution to jumps when moving forward, so this will compensate to reach generally the same height when not moving
			Result.Z += 65.f;
		}
	}

	return Result;
}

simulated event ApplyJumpVelocity(int JumpLevel, bool bFromSpring, bool bIsNearWall, vector WallNormal, bool bApplyForwardVelocity, Vector StickDir )
{
	local vector JumpVel, Dir;
	local NanoPC PC;
	local rotator CamRot;
	local vector CamLoc;
	local float AddDotDir;
	local bool bFromCar;
	local NanoPerchPoint PerchPoint;
	local float JumpZ, CamDotFwd, Pct;
	
	bFromCar = NanoVehicleAgent(PawnOwner.Base) != None;
	PerchPoint = NanoPerchPoint(PawnOwner.Base);

	`jump_log(`location@`showvar(JumpLevel)@`showvar(bIsNearWall)@`showvar(bApplyForwardVelocity)@`showvar(StickDir)@`showvar(bFromCar));

	JumpVel = GetJumpForwardVelocity( StickDir, bApplyForwardVelocity, bIsNearWall, WallNormal );
	if( PawnOwner.Physics == PHYS_Falling )
	{
		// if falling then eliminate the z
		JumpVel.Z = 0;
	}
	JumpVel += GetJumpUpwardVelocity( StickDir );

	PC = NanoPC(PawnOwner.Controller);
	if( PC != None )
	{
		// Since the above does not work on the server, base the base contribution solely off of rotation
		Dir = vector(PC.Rotation);

		// if we have a moving base then apply that velocity as well
		// Only apply in the direction we are trying to jump
		if( PawnOwner.Base != None && !PawnOwner.Base.bStatic )
		{
			// when jumping off of elevators, we want their full velocity transferred
			if( NanoVehicle_ElevatorBase(PawnOwner.Base) != None )
			{
				JumpVel += PawnOwner.Base.Velocity;
			}
			else
			{
				AddDotDir = Dir DOT PawnOwner.Base.Velocity;
				if( AddDotDir > 0 )
				{
					JumpVel += Dir * AddDotDir * 0.85;
				}
			}
		}

		// if from a perch then add a directional boost
		
		if( PerchPoint != None )
		{
			JumpVel += Dir * PerchPoint.PerchJumpBoost;
		}
	}
	else
	{
		Dir = vector(PawnOwner.Rotation);
	}

	if( bFromSpring )
	{
		JumpVel += vect(0,0,1) * JumpLevels[SkillLevel].SpringJumpBoost;
	}
	// if doing a handspring
	if( PawnOwner.bHandspringJump )
	{
		JumpVel += vector(PawnOwner.Rotation) * JumpLevels[SkillLevel].HandspringJumpBoost;

		if( PC != None )
		{
			// Get the direction left thumbstick is pushed relative to camera			
			PawnOwner.GetActorEyesViewPoint(CamLoc,CamRot);
			Dir = (Normal(vect(1,0,0) * PC.PlayerInput.RawJoyUp + vect(0,1,0) * PC.PlayerInput.RawJoyRight) >> CamRot);
			CamDotFwd = Dir DOT Vector(CamRot);
			JumpZ = JumpVel.Z;

			// Change lateral direction of jump vel based on thumbstick dir
			JumpVel = Dir * VSize2D(JumpVel);
			JumpVel.Z = JumpZ;

			// If not pushing mostly forward
			if( Abs(CamDotFwd) < 0.95f )
			{
				// Scale vertical vel
				Pct = FMax(FPctByRange( Abs(CamDotFwd), 0.f, 0.95f ), 0.5f);
				JumpVel.Z *= Pct;
			}

			// Update the rotation
			PawnOwner.SetRotation( Rotator(Dir) );
			PawnOwner.SetDesiredRotation( PawnOwner.Rotation );
		}
	}
	else if( PawnOwner.MantleState != MANTLE_None )
	{
		JumpVel.Z *= 0.5f;
		//`log("mantle jump, no spring");
	}

	// update physics and set the new jump velocity
	PawnOwner.SetPhysics(PHYS_Falling);
	PawnOwner.Velocity = JumpVel;
	// enable check for falling to receive an event at the apex
	PawnOwner.bCheckForFalling = TRUE;

`if(`notdefined(FINAL_RELEASE))
	JumpOrigin = PawnOwner.Location;
	MaxOfJump = PawnOwner.Location;
	BoostTimerExpiredTime = 0.f;
`endif
	ApexOfJumpTime = 0.f;

	if( PerchPoint == None )
	{
		if( bFromCar )
		{
			PawnOwner.UpdateJumpAnimSet('SprintJump');
		}
		else
		{
			PawnOwner.UpdateJumpAnimSet();
		}
		PawnOwner.BlendFallNode.bResetFall = TRUE;
	}
	PawnOwner.BlendFallNode.ChangeFallState(FBT_Up);
}

simulated native function ApplyJumpBoost( NanoPawn NP, float DeltaTime );


simulated function NotifyFalling(NanoPawn NP)
{
	// pretend we jumped even if falling off a ledge to allow sequential jumps
	if( LastJumpLevel == -1 )
	{
		LastJumpLevel = 0;
	}

	`jump_log( "FALLING"@`TimeSinceEx(NP,NP.LastJumpTime) @ self @ NP.WorldInfo.TimeSeconds );
	ApexOfJumpTime = NP.WorldInfo.TimeSeconds;
}

simulated function NotifyLanded(NanoPawn NP)
{
	ResetJumpLevel();
	if( bActive )
	{
		DeactivateSkill();
	}
	
	NP.MakeNoise( 0.4f );

`if(`notdefined(FINAL_RELEASE))
	`jump_log( `showvar(MaxOfJump.Z)@"Delta"@(MaxOfJump.Z-JumpOrigin.Z)@"Dist"@VSize2D(MaxOfJump-JumpOrigin) );
	`jump_log( "Time Between Timer Expired and Apex of Jump"@(ApexOfJumpTime-BoostTimerExpiredTime) );
`endif
}

simulated function ResetJumpLevel()
{
	`jump_log("resetting last jump level");
	LastJumpLevel = -1;
	JumpHoldToMaxBoostCounter = 0.0f;
}


/** Gets the current skill level in use */
simulated function int GetCurrentSkillLevelInUse()
{
	return LastJumpLevel;
}

defaultproperties
{
	SkillType=NS_Jump
	bSkipReplication=TRUE

	

	JumpCue=SoundCue'Foley_Footsteps.Stone.Footstep_Stone_Jump_Cue'
	JumpEffortCue=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_Jump_Cue'
	JumpEffortTripleCue=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_JumpDouble_Cue'

	ReachedMaxJumpBoostCue=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_ReachedMaxJumpBoost_Cue'

	LastJumpLevel=-1

	SkillIconOrigin=(X=128)
	SkillIconSize=(X=64,Y=64)
	
	bHideFromSkillUI=TRUE

	DodgeOverPawnCheckDist=120.f
	
	DodgeList(0)=(Dir=CJD_Right,SpecialMoveName=NSM_Evade_Fwd,bOverPawn=FALSE)
	DodgeList(1)=(Dir=CJD_Left,SpecialMoveName=NSM_Evade_Fwd,bOverPawn=FALSE)
	DodgeList(2)=(Dir=CJD_Down,SpecialMoveName=NSM_Evade_Fwd,bOverPawn=FALSE)
	DodgeList(3)=(Dir=CJD_Up,SpecialMoveName=NSM_Evade_Fwd,bOverPawn=FALSE)

	DodgeList(4)=(Dir=CJD_Right,SpecialMoveName=NSM_Evade_OverEnemy_Rt,bOverPawn=TRUE)
	DodgeList(5)=(Dir=CJD_Left,SpecialMoveName=NSM_Evade_OverEnemy_Lt,bOverPawn=TRUE)
}
