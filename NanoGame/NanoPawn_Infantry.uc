/*
 * Base class for all infantry type pawns.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */ 
class NanoPawn_Infantry extends NanoPawn
	dependson(NanoWeapon)
	abstract
	native(Pawn);

/** When this pawn is dead and ragdoll hits the floor this is the sound we will play. **/
var protected SoundCue DeadBodyHittingTheFloor;


struct native SpineBoneLink
{
	var name SourceBody;
	var name DestBody;
	var transient RB_ConstraintInstance SpineJoint; 
};

var 			array<SpineBoneLink> 	SpineLinks;
var instanced	RB_ConstraintSetup	SpineSetup;

/** Names of all of the spine skel controls that this pawn has**/
var array<name> SpineSkelControls;

/** Particle system to play from the neck on a head shot**/
var ParticleSystem PS_HeadShotBloodSpray;
var Name HeadShotBloodSpraySocket;

/** This is a simple bool (which might not be at correct level in hierarchy) which basically says:  try to put me into the melee engage list above everyone else. **/
var int MeleeEngagePriorityLevel;


/** Percent of defaulthealth to be considered massive damage **/
var config float JustTookMassiveDamage_PercentOfHealth;
/** How long we add up all damage taken into the accumulator **/
var config float JustTookMassiveDamage_Window;
var transient int JustTookMassiveDamage_Accumulator;
var transient float JustTookMassiveDamage_Time;

/** How long the pawn has before they bleed out and die after entering DBNO state **/
var config float DBNO_DurationTilBleedOutDeath;

/** How many points of damage result in 1 second of time being lost **/
var config float AmountOfDamageFor1SecondDBNOTimeLost;


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	TurnOnDualSpineConstraints();
}


function TurnOnDualSpineConstraints()
{
	local int BoneIdx;

	if( SpineLinks.length > 0 )
	{
		SpineSetup = new(self) class'RB_ConstraintSetup';
		SpineSetup.bSwingLimited = TRUE;
		SpineSetup.bTwistLimited = TRUE;
		SpineSetup.LinearXSetup.bLimited = 1; 
		SpineSetup.LinearYSetup.bLimited = 1; 
		SpineSetup.LinearZSetup.bLimited = 1;

		for(BoneIdx=0; BoneIdx<SpineLinks.length; BoneIdx++) 
		{
			SpineSetup.ConstraintBone1 = SpineLinks[BoneIdx].SourceBody;
			SpineSetup.ConstraintBone2 = SpineLinks[BoneIdx].DestBody;

			SpineLinks[BoneIdx].SpineJoint = new(self) class'RB_ConstraintInstance';

			SpineLinks[BoneIdx].SpineJoint.InitConstraint(Mesh, Mesh, SpineSetup, 1.f, self, Mesh, false); 
		}
	}
}


function TurnOffDualSpineConstraints()
{
	local int BoneIdx;

	for(BoneIdx=0; BoneIdx<SpineLinks.length; BoneIdx++) 
	{
		SpineLinks[BoneIdx].SpineJoint.TermConstraint();
	}
}


function TurnOffDualSpineConstraint( const name BodyName )
{
	local int BoneIdx;

	for(BoneIdx=0; BoneIdx<SpineLinks.length; BoneIdx++) 
	{
		if( BodyName == SpineLinks[BoneIdx].SourceBody )
		{
			SpineLinks[BoneIdx].SpineJoint.TermConstraint();
		}
	}
}


function TurnOffSpineSkelController( const name SkelControlName )
{
	local SkelControlSingleBone SkelControl;

	SkelControl = SkelControlSingleBone(Mesh.FindSkelControl(SkelControlName));

	if( SkelControl != None )
	{
		SkelControl.SetSkelControlStrength( 0.0f, 0.0f );
	}
}


function TurnOffSpineSkelControllers()
{
	local name ControlName;

	foreach SpineSkelControls( ControlName )
	{
		TurnOffSpineSkelController( ControlName );
	}
}



/** When this NanoPawn is targetted, which location should we focus on */
simulated event vector GetTargetedLocation()
{
	return Mesh.GetBoneLocation( MeleeDamageBoneName );
}


function TurnToRagDollPhysics()
{
	if( Mesh != none )
	{
		Mesh.ScriptRigidBodyCollisionThreshold = 100.0f;
		Mesh.SetNotifyRigidBodyCollision( TRUE );
	}

	Super.TurnToRagDollPhysics();
}


simulated event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
					const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	//`log( "RBC: " $ self $ " against " $ HitComponent @ OtherComponent @ NanoPawn(HitComponent.Owner) @ ContactIndex );

	if( ( ( OtherComponent == none ) || ( NanoPawn(OtherComponent.Owner) == None ) )
		&& ( NanoGibStaticMeshComponent(OtherComponent) == none )
		&& ( NanoGibSkeletalMeshComponent(OtherComponent) == none )
		)
	{
		//`log( "   PLAYYYINNNGG" );		`log( "   PLAYYYINNNGG" );		`log( "   PLAYYYINNNGG" );		`log( "   PLAYYYINNNGG" );		`log( "   PLAYYYINNNGG" );
		// once we hit one thing don't fire off anymore hits
		if( Mesh != none )
		{
			Mesh.SetNotifyRigidBodyCollision( FALSE );
		}

		if ( EffectIsRelevant( Location, FALSE, 4000.0) )
		{
			PlaySound( DeadBodyHittingTheFloor, TRUE );
		}
	}
}

simulated function PlayHitReaction( out HitReactionInfo HRI )
{
	// no full reactions allowed when mantling/climbing
	if( MantleState != MANTLE_None || CurrentLadder != None )
	{
		return;
	}

	if( bDoNoHitReaction && HRI.AttackPriority <= NoHitReactionPriority )
	{
		return;
	}

	// need to check to see if we are allowed  to to the HitReaction Special move
	// we do an extra CanOverrideMoveWith as we are going to update the HitReaction struct
	if( ( ActiveSpecialMove == None )
		|| ( ActiveSpecialMove.CanOverrideMoveWith( 'NSM_Melee_HitReaction' ) == TRUE )
		)
	{
		EndSpecialMove();
		HitReaction = HRI;
		DoSpecialMove( 'NSM_Melee_HitReaction' );
	}
// 	else
// 	{
// 		`log( self @ `showvar(ActiveSpecialMove) @ `showvar( ActiveSpecialMove.CanOverrideMoveWith( 'NSM_Melee_HitReaction' )) );
// 	}
}



/**
 * DBNO state, only called on server.
 */
state DBNO
{
	event BeginState(Name PrevStateName)
	{
		`log( "Entered in to DBNO state!" );

		NanoAIBase(Controller).ListOfAIActionsThisAICanDo.Length = 0;

		NanoAIBase(Controller).SetFireTarget( None );
		NanoAIBase(Controller).Focus = None;

		TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_EnteredState', self, 0 );

		DBNORepulsor = Spawn( class'NanoCrowd_PanicRepulsor_DBNOBody', self,, Location, Rotation,, TRUE );
		DBNORepulsor.SetBase( self );

		PlaySound( DBNOAudio.EnterDBNO );
		UpdateDBNOBreathingCue( DBNOAudio.BreathingGenericGuyNotBeingInterrogated );

		DeathReaction.AnimName = '';

		DoSpecialMove( 'NSM_DBNO', TRUE );
	}

	event EndState(Name NextStateName)
	{
		if( AC_DBNOBreathing != None )
		{
			AC_DBNOBreathing.FadeOut( 0.250f, 0.0f );
			AC_DBNOBreathing = None;
		}


		`log( "LEAVING DBNO" @ `showvar(NextStateName) );	`log( "LEAVING DBNO" @ `showvar(NextStateName) );	`log( "LEAVING DBNO" @ `showvar(NextStateName) );	`log( "LEAVING DBNO" @ `showvar(NextStateName) );
		ScriptTrace();
	}

	/**
	 * If you are in state reviving and you take damage then we have special logic to determine what damage actually occurs.
	 */
	function TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		local float NumSecondsToSubtract;

		// do not allow for now

		// prob have some range check here and then call DBNO_Execute

		NumSecondsToSubtract = float(Damage) / AmountOfDamageFor1SecondDBNOTimeLost;

		DBNO_DurationTilBleedOutDeath -= NumSecondsToSubtract;

		//`log( `showvar(NumSecondsToSubtract) @ `showvar(Damage) @ `showvar(AmountOfDamageFor1SecondDBNOTimeLost) );
		

	}



	/**
	 * This is an organ removal sequence; think of Marston's gutting an animal in Red Dead.  Camera cut, quick surgery, organ removal, organ goes into plastic bag and is put in jacket pocket.  Plastic gloves for Owen? 
	 **/
	simulated function DBNO_Harvest()
	{

	}


	/**
	 * this is a QUICK pocket search, to get the contents of pocket.  Owen should find something, and pocket it.  
	 **/
	simulated function DBNO_Patdown()
	{

	}


	/** 
	 * this is a COLLAR GRAB animation, where Owen grabs the enemy; there's a hostile relationship.  Owen will (for argument's sake) THREATEN/SHAKE the enemy to interrogate him.  INTERROGATEE can take beats, and either TALK or NOT TALK.  This will need some squirm room, but ideally we can mock some stuff up with this and see how it works in gameplay.  (Note: This might seem dumb right now, Aaron, but the idea is to create scenarios where injured enemies must be talked to before they bleed out, and while the co-op buddy is covering them.)
	 **/
	simulated function DBNO_Interrogate()
	{

	}


	/**
	 * The DBNO'd pawn can be revived by a teammate.
	 **/
	simulated function DBNO_Revival()
	{

	}


	/**
	 * The DBNO'd pawn can actually be killed when this function is called.  Usually from some set of fulfilled constraints in DBNO's TakeDamage()
	 **/
	simulated function DBNO_Execute()
	{

	}


	simulated event Tick( float DeltaTime )
	{
		local float PercentOfTotalBleedOutDuration;

		Global.Tick(DeltaTime);

		if( default.DBNO_DurationTilBleedOutDeath > 0.0f )
		{
			if( `TimeSince(TimeOfDBNO) > DBNO_DurationTilBleedOutDeath )
			{
				`log( "DBNO  Killing the pawn! due to bleedout!" );
				PlaySound( DBNOAudio.EndViaBleedOut );
				Died( ControllerWhoPutMeDBNO, class'NDT_DBNO_Death', Location );
			}

		}

		// if we are being interrogated then use the special breathing
		if( NSM_DBNO_InteractionVictimBase(ActiveSpecialMove) != None )
		{
			// determine which SoundCue to Play on the Breathing AudioComponent
			PercentOfTotalBleedOutDuration = (default.DBNO_DurationTilBleedOutDeath - `TimeSince(TimeOfDBNO)) / default.DBNO_DurationTilBleedOutDeath;

			//`log( `showvar(PercentOfTotalBleedOutDuration) );

			if( PercentOfTotalBleedOutDuration >= 0.66f )
			{
				UpdateDBNOBreathingCue( DBNOAudio.BreathingLevel1 );
			}
			else if( PercentOfTotalBleedOutDuration >= 0.33f )
			{
				UpdateDBNOBreathingCue( DBNOAudio.BreathingLevel2 );
			}
			else if( PercentOfTotalBleedOutDuration >= 0.00f )
			{
				UpdateDBNOBreathingCue( DBNOAudio.BreathingLevel3 );
			}
		}

	}
	
	final private function UpdateDBNOBreathingCue( SoundCue NewCueToPlay )
	{
		// if we are playing the same SoundCue then just return
		if( ( AC_DBNOBreathing != None ) && ( AC_DBNOBreathing.SoundCue == NewCueToPlay ) )
		{
			return;
		}

		// fade out the old breathing sound
		if( AC_DBNOBreathing != None )
		{
			AC_DBNOBreathing.FadeOut( 0.250f, 0.0f );
			AC_DBNOBreathing = None;
		}

		// fade in the new breathing sound
		AC_DBNOBreathing = new(self) class'AudioComponent';

		if( AC_DBNOBreathing != None )
		{
			AC_DBNOBreathing.SoundCue = NewCueToPlay;
			AttachComponent( AC_DBNOBreathing );
			AC_DBNOBreathing.FadeIn( 0.250f, 1.0f );

			//`log( "Playing new breathing" @ `showvar(MyNP.AC_DBNOBreathing.SoundCue) );
		}

	}



	function DrawDBNOCountdownTimer( NanoHUD_Base H )
	{
		local NanoPC	PC;
		local Canvas	Canvas;
		local Vector	CameraLoc, ScreenLoc;
		local Rotator	CameraRot;

		local float		HealthPct;

		if( default.DBNO_DurationTilBleedOutDeath == 0.0f )
		{
			return;
		}

		PC = NanoGRI(WorldInfo.GRI).GetNanoPC();
		Canvas = H.Canvas;
		Canvas.SetDrawColor(255,255,255);

		// project location onto the hud
		PC.GetPlayerViewPoint( CameraLoc, CameraRot );
		ScreenLoc = Canvas.Project( Location + vect(0,0,1) * GetCollisionHeight() * 0.5f );
		Canvas.SetPos( ScreenLoc.X, ScreenLoc.Y );


		HealthPct = `TimeSince(TimeOfDBNO) / DBNO_DurationTilBleedOutDeath;

		// hack for crazy case where pawn is still alive but should be dead
		if( HealthPct < 0.0f )
		{
			HealthPct = 1.0f;
		}

		Canvas.DrawTile(Texture2D'WhiteSquareTexture',64.f * (1.f - HealthPct),4,0,0,2,2);
		Canvas.SetDrawColor(255,0,0);
		Canvas.DrawTile(Texture2D'WhiteSquareTexture',64.f * (HealthPct),4,0,0,2,2);

	}

}






defaultproperties
{
    MeleeDamageBoneName="b_MF_Spine_02"

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0060.000000
		CollisionHeight=+0088.000000
	End Object

	Begin Object Name=NanoPawnMesh
	    //bRootMotionExtractedNotify=TRUE // DEBUG DEBUG DEBUG
		AnimSets.Empty()
        bHasPhysicsAssetInstance=TRUE	// Needed by PhysicsBodyImpact
		AnimTreeTemplate=AnimTree'REB_Lyrik_AT.AT_Lyrik'
		
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ShockTrooper_Proto')
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ShockT_Hit_React')

		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_Aim_Offset_v2')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_Civilian')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_No_Weapon')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_SMG')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_Sword')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_Lyrik_Aim_Offsets')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_Lyrik_Forge')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_Lyrik_No_Weapon')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_Lyrik_SMG')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_Lyrik_Staff')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_Lyrik_Sword')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_Lyrik_Talon')

		AnimSets.Add(AnimSet'REB_Owen_Anims.AS_REB_Owen_Sword')
		AnimSets.Add(AnimSet'REB_Owen_Anims.AS_REB_Owen_No_Weapon')
		AnimSets.Add(AnimSet'REB_Owen_Anims.AS_REB_Owen_Handgun')
		AnimSets.Add(AnimSet'REB_Owen_Anims.AS_REB_Owen_Knife')

		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_Marcus_Civilian')

		//bOwnerNoSee=TRUE
		//Translation=(Z=-74)
	End Object

	NeckBoneName=b_MF_Neck
	PelvisBoneName=b_MF_Pelvis
	LeftHandBoneName=b_MF_Hand_L
	RightHandBoneName=b_MF_Hand_R
	LeftKneeBoneName=b_MF_Calf_L
	RightKneeBoneName=b_MF_Calf_R
	LeftFootBoneName=b_MF_Foot_L
	RightFootBoneName=b_MF_Foot_R
	LeftElbowBoneName=b_MF_Forearm_L
	RightElbowBoneName=b_MF_Forearm_R

	HeadShotBloodSpraySocket=HeadShotBloodPS
	PS_HeadShotBloodSpray=ParticleSystem'Effects_Gameplay.Blood.P_Blood_HeadShot'

	// Joint limits to scale down when dead.
	RagdollLimitScaleTable(0)=(RB_ConstraintName="b_MF_Thigh_L",Swing1Scale=0.55,Swing2Scale=0.2,TwistScale=0.25)
	RagdollLimitScaleTable(1)=(RB_ConstraintName="b_MF_Thigh_R",Swing1Scale=0.55,Swing2Scale=0.2,TwistScale=0.25)
	RagdollLimitScaleTable(2)=(RB_ConstraintName="b_MF_Foot_L",Swing1Scale=0.5,Swing2Scale=0.5,TwistScale=0.45)
	RagdollLimitScaleTable(3)=(RB_ConstraintName="b_MF_Foot_R",Swing1Scale=0.5,Swing2Scale=0.5,TwistScale=0.45)
	RagdollLimitScaleTable(4)=(RB_ConstraintName="b_MF_Neck",Swing1Scale=0.5,Swing2Scale=0.5,TwistScale=0.5)
	RagdollLimitScaleTable(5)=(RB_ConstraintName="b_MF_Spine01",Swing1Scale=0.3,Swing2Scale=0.3,TwistScale=0.1)
	RagdollLimitScaleTable(6)=(RB_ConstraintName="b_MF_Spine02",Swing1Scale=0.3,Swing2Scale=0.3,TwistScale=0.1)
	TimeToScaleLimits=1.f
	

	DeadBodyHittingTheFloor=SoundCue'Foley_Body.Player.Body_CoverSlam_Cue'
	DismemberSpurtingSound=SoundCue'Foley_Body.MetaCorps.Gore_SpurtDeath_Cue'
	DismemberSpurtingDecapitateSound=SoundCue'Foley_Body.MetaCorps.Gore_SpurtDecapitate_Cue'
	DismemberSpurtingEffect=ParticleSystem'Effects_Gameplay.Blood.P_ChainSaw_Blood_SkorgeWins_01'//ParticleSystem'Effects_Gameplay.Blood.P_Blood_Head_Necksnap_Bloodspray'

	//DismemberSound=SoundCue'Weapon_Sword.Sword_Impact.Sword_Dismember_Cue'

	ConstraintBrokenNotify_LimbChild=ParticleSystem'Effects_Gameplay.Blood.P_Blood_flying_bodypart'
	ConstraintBrokenNotify_LimbParent=ParticleSystem'Nano_Blood.Effects.P_Nano_SmallLimb_Spurt'
	//ParticleSystem'Nano_Blood.Effects.P_Nano_ArterySpurt_01'

	SpecialMoves.Add((SpecialMoveName=NSM_Evade_Rt,SpecialMoveClass=class'NSM_Evade_Rt'))
	SpecialMoves.Add((SpecialMoveName=NSM_Evade_Lt,SpecialMoveClass=class'NSM_Evade_Lt'))
	SpecialMoves.Add((SpecialMoveName=NSM_Evade_Bwd,SpecialMoveClass=class'NSM_Evade_Bwd'))
	SpecialMoves.Add((SpecialMoveName=NSM_Evade_Fwd,SpecialMoveClass=class'NSM_Evade_Fwd'))
	SpecialMoves.Add((SpecialMoveName=NSM_Evade_OverEnemy_Rt,SpecialMoveClass=class'NSM_Evade_OverEnemy_Rt'))
	SpecialMoves.Add((SpecialMoveName=NSM_Evade_OverEnemy_Lt,SpecialMoveClass=class'NSM_Evade_OverEnemy_Lt'))
	SpecialMoves.Add((SpecialMoveName=NSM_Evade_OverEnemy_Victim_Rt,SpecialMoveClass=class'NSM_Evade_OverEnemy_Victim_Rt'))
	SpecialMoves.Add((SpecialMoveName=NSM_Evade_OverEnemy_Victim_Lt,SpecialMoveClass=class'NSM_Evade_OverEnemy_Victim_Lt'))
	SpecialMoves.Add((SpecialMoveName=NSM_Evade_Jump_Back,SpecialMoveClass=class'NSM_Evade_Jump_Back'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_Turtle,SpecialMoveClass=class'NSM_Melee_Turtle'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_AttackBlocked,SpecialMoveClass=class'NSM_Melee_AttackBlocked'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_BreakOut,SpecialMoveClass=class'NSM_Melee_BreakOut'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_BreakOut_Victim,SpecialMoveClass=class'NSM_Melee_BreakOut_Victim'))

	SpecialMoves.Add((SpecialMoveName=NSM_Melee_Counter,SpecialMoveClass=class'NSM_Melee_Counter'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_Counter_Victim,SpecialMoveClass=class'NSM_Melee_Counter_Victim'))

	SpecialMoves.Add((SpecialMoveName=NSM_Thrustered,SpecialMoveClass=class'NSM_Thrustered'))
	SpecialMoves.Add((SpecialMoveName=NSM_Tripped,SpecialMoveClass=class'NSM_Tripped'))
	SpecialMoves.Add((SpecialMoveName=NSM_StunnedAndDazed,SpecialMoveClass=class'NSM_StunnedAndDazed'))
	SpecialMoves.Add((SpecialMoveName=NSM_StunnedAndDazed_AI,SpecialMoveClass=class'NSM_StunnedAndDazed_AI'))
	SpecialMoves.Add((SpecialMoveName=NSM_CowerInFear,SpecialMoveClass=class'NSM_CowerInFear'))

	SpecialMoves.Add((SpecialMoveName=NSM_ShakeItOff,SpecialMoveClass=class'NSM_ShakeItOff'))

	
	SpecialMoves.Add((SpecialMoveName=NSM_ShakeItOff,SpecialMoveClass=class'NSM_BeingAimedAt_Cower'))
	SpecialMoves.Add((SpecialMoveName=NSM_BeingAimedAt_Evade,SpecialMoveClass=class'NSM_BeingAimedAt_Evade'))
	SpecialMoves.Add((SpecialMoveName=NSM_BeingAimedAt_JumpBack,SpecialMoveClass=class'NSM_BeingAimedAt_JumpBack'))
	SpecialMoves.Add((SpecialMoveName=NSM_BeingAimedAt_Panic,SpecialMoveClass=class'NSM_BeingAimedAt_Panic'))
	SpecialMoves.Add((SpecialMoveName=NSM_BeingAimedAt_Taunt,SpecialMoveClass=class'NSM_BeingAimedAt_Taunt'))
	SpecialMoves.Add((SpecialMoveName=NSM_BeingAimedAt_ThrowGunThrowHandsUp,SpecialMoveClass=class'NSM_BeingAimedAt_ThrowGunThrowHandsUp'))


	SpecialMoves.Add((SpecialMoveName=NSM_DBNO,SpecialMoveClass=class'NSM_DBNO'))

	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_InterrogateAttempt,SpecialMoveClass=class'NSM_DBNO_InterrogateAttempt'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_InterrogateEnemy,SpecialMoveClass=class'NSM_DBNO_InterrogateEnemy'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_InterrogateVictim,SpecialMoveClass=class'NSM_DBNO_InterrogateVictim'))

	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_PatDownAttempt,SpecialMoveClass=class'NSM_DBNO_PatDownAttempt'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_PatDownEnemy,SpecialMoveClass=class'NSM_DBNO_PatDownEnemy'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_PatDownVictim,SpecialMoveClass=class'NSM_DBNO_PatDownVictim'))

	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_HarvestAttempt,SpecialMoveClass=class'NSM_DBNO_HarvestAttempt'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_HarvestEnemy,SpecialMoveClass=class'NSM_DBNO_HarvestEnemy'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_HarvestVictim,SpecialMoveClass=class'NSM_DBNO_HarvestVictim'))

	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_DragAttempt,SpecialMoveClass=class'NSM_DBNO_DragAttempt'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_DragEnemy,SpecialMoveClass=class'NSM_DBNO_DragEnemy'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_DragVictim,SpecialMoveClass=class'NSM_DBNO_DragVictim'))

	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_Drag_ThrowFromLedge_Attempt,SpecialMoveClass=class'NSM_DBNO_Drag_ThrowFromLedge_Attempt'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_Drag_ThrowFromLedge_Enemy,SpecialMoveClass=class'NSM_DBNO_Drag_ThrowFromLedge_Enemy'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_Drag_ThrowFromLedge_Victim,SpecialMoveClass=class'NSM_DBNO_Drag_ThrowFromLedge_Victim'))


	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_ExecuteAttempt,SpecialMoveClass=class'NSM_DBNO_ExecuteAttempt'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_ExecuteEnemy,SpecialMoveClass=class'NSM_DBNO_ExecuteEnemy'))
	SpecialMoves.Add((SpecialMoveName=NSM_DBNO_ExecuteVictim,SpecialMoveClass=class'NSM_DBNO_ExecuteVictim'))


	SpecialMoves.Add((SpecialMoveName=NSM_EscapeFromBeingStuckLandingOnWall,SpecialMoveClass=class'NSM_EscapeFromBeingStuckLandingOnWall'))
	SpecialMoves.Add((SpecialMoveName=NSM_DenseBashedFlyThroughTheAir,SpecialMoveClass=class'NSM_DenseBashedFlyThroughTheAir'))
	SpecialMoves.Add((SpecialMoveName=NSM_DenseBash,SpecialMoveClass=class'NSM_DenseBash'))
	

	//SpecialMoves.Add((SpecialMoveName=NSM_Mantle_WallStick,SpecialMoveClass=class'NSM_Mantle_WallStick'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_AntennaRun,SpecialMoveClass=class'NSM_Mantle_AntennaRun'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_BigStep,SpecialMoveClass=class'NSM_Mantle_BigStep'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_ChestHigh,SpecialMoveClass=class'NSM_Mantle_ChestHigh'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_Hurdle,SpecialMoveClass=class'NSM_Mantle_Hurdle'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_Hurdle_Left,SpecialMoveClass=class'NSM_Mantle_Hurdle_Left'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_Hurdle_Right,SpecialMoveClass=class'NSM_Mantle_Hurdle_Right'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_Ledge,SpecialMoveClass=class'NSM_Mantle_Ledge'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_MaxJumpWallRun,SpecialMoveClass=class'NSM_Mantle_MaxJumpWallRun'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_StepDown,SpecialMoveClass=class'NSM_Mantle_StepDown'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_Waist,SpecialMoveClass=class'NSM_Mantle_Waist'))
	SpecialMoves.Add((SpecialMoveName=NSM_Mantle_WallRunAndGrab,SpecialMoveClass=class'NSM_Mantle_WallRunAndGrab'))

	SpecialMoves.Add((SpecialMoveName=NSM_StabMantle,SpecialMoveClass=class'NSM_StabMantle'))

	SpecialMoves.Add((SpecialMoveName=NSM_FireEscape,SpecialMoveClass=class'NSM_FireEscape'))
	SpecialMoves.Add((SpecialMoveName=NSM_Grapple,SpecialMoveClass=class'NSM_Grapple'))
	SpecialMoves.Add((SpecialMoveName=NSM_PerchOnPoint,SpecialMoveClass=class'NSM_PerchOnPoint'))
	SpecialMoves.Add((SpecialMoveName=NSM_Turbine,SpecialMoveClass=class'NSM_Turbine'))
	SpecialMoves.Add((SpecialMoveName=NSM_WireSlide,SpecialMoveClass=class'NSM_WireSlide'))

	SpecialMoves.Add((SpecialMoveName=NSM_AIJumpHolder,SpecialMoveClass=class'NSM_Jump_Base'))
	SpecialMoves.Add((SpecialMoveName=NSM_GhostDash,SpecialMoveClass=class'NSM_GhostDash'))
	SpecialMoves.Add((SpecialMoveName=NSM_Dash_Slide,SpecialMoveClass=class'NSM_Dash_Slide'))
	SpecialMoves.Add((SpecialMoveName=NSM_Dash_AthleticIdle,SpecialMoveClass=class'NSM_Dash_AthleticIdle'))

	SpecialMoves.Add((SpecialMoveName=NSM_Melee_PinEnemy,SpecialMoveClass=class'NSM_Melee_PinEnemy'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_PinVictim,SpecialMoveClass=class'NSM_Melee_PinVictim'))

	SpecialMoves.Add((SpecialMoveName=NSM_Melee_GrabAttempt,SpecialMoveClass=class'NSM_Melee_GrabAttempt'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_GrabEnemy,SpecialMoveClass=class'NSM_Melee_GrabEnemy'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_GrabVictim,SpecialMoveClass=class'NSM_Melee_GrabVictim'))

	SpecialMoves.Add((SpecialMoveName=NSM_Melee_GrabAndBeatAttempt,SpecialMoveClass=class'NSM_Melee_GrabAndBeatAttempt'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_GrabAndBeatEnemy,SpecialMoveClass=class'NSM_Melee_GrabAndBeatEnemy'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_GrabAndBeatVictim,SpecialMoveClass=class'NSM_Melee_GrabAndBeatVictim'))

	SpecialMoves.Add((SpecialMoveName=NSM_Melee_GrabAHostageAttempt,SpecialMoveClass=class'NSM_Melee_GrabAHostageAttempt'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_GrabAHostageEnemy,SpecialMoveClass=class'NSM_Melee_GrabAHostageEnemy'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_GrabAHostageVictim,SpecialMoveClass=class'NSM_Melee_GrabAHostageVictim'))


	SpecialMoves.Add((SpecialMoveName=NSM_Melee_DropTheHammer,SpecialMoveClass=class'NSM_Melee_DropTheHammer'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_DropTheHammer_Victim,SpecialMoveClass=class'NSM_Melee_DropTheHammer_Victim'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_AgentGroundPound_Victim,SpecialMoveClass=class'NSM_Melee_AgentGroundPound_Victim'))

	SpecialMoves.Add((SpecialMoveName=NSM_Trooper_IdleBreak_Spectator,SpecialMoveClass=class'NSM_Trooper_IdleBreak_Spectator'))
	SpecialMoves.Add((SpecialMoveName=NSM_Trooper_IdleBreak_Standby,SpecialMoveClass=class'NSM_Trooper_IdleBreak_Standby'))

	SpecialMoves.Add((SpecialMoveName=NSM_Melee_HitReaction,SpecialMoveClass=class'NSM_Melee_HitReaction'))
	SpecialMoves.Add((SpecialMoveName=NSM_Melee_DeathReaction,SpecialMoveClass=class'NSM_Melee_DeathReaction'))
	SpecialMoves.Add((SpecialMoveName=NSM_Trooper_Death_WaitingToDie,SpecialMoveClass=class'NSM_Trooper_Death_WaitingToDie'))

	SpecialMoves.Add((SpecialMoveName=NSM_Trooper_IssueCommand,SpecialMoveClass=class'NSM_Trooper_IssueCommand'))
	SpecialMoves.Add((SpecialMoveName=NSM_Trooper_DeployBaton,SpecialMoveClass=class'NSM_Trooper_DeployBaton'))

	SpecialMoves.Add((SpecialMoveName=NSM_StopAndPlayAnAnimation,SpecialMoveClass=class'NSM_StopAndPlayAnAnimation'))
	SpecialMoves.Add((SpecialMoveName=NSM_StopAndPlayAnAnimationLooping,SpecialMoveClass=class'NSM_StopAndPlayAnAnimationLooping'))
	SpecialMoves.Add((SpecialMoveName=NSM_MesmorizedByNanoAttractor,SpecialMoveClass=class'NSM_MesmorizedByNanoAttractor'))

	SpecialMoves.Add((SpecialMoveName=NSM_ForgePose,SpecialMoveClass=class'NSM_ForgePose'))
	SpecialMoves.Add((SpecialMoveName=NSM_ForgeCycle,SpecialMoveClass=class'NSM_ForgeCycle'))
	SpecialMoves.Add((SpecialMoveName=NSM_ForgeCycleFast,SpecialMoveClass=class'NSM_ForgeCycleFast'))
	
	Mantles.Add(NSM_Mantle_BigStep)
	Mantles.Add(NSM_Mantle_ChestHigh)
	Mantles.Add(NSM_Mantle_Hurdle)
	Mantles.Add(NSM_Mantle_Hurdle_Left)
	Mantles.Add(NSM_Mantle_Hurdle_Right)
	Mantles.Add(NSM_Mantle_Ledge)
	Mantles.Add(NSM_Mantle_StepDown)
	Mantles.Add(NSM_Mantle_Waist)
	Mantles.Add(NSM_Mantle_WallRunAndGrab)
	Mantles.Add(NSM_Mantle_AntennaRun)
	//Mantles.Add(NSM_Mantle_WallStick)
	Mantles.Add(NSM_Mantle_MaxJumpWallRun)
}
	