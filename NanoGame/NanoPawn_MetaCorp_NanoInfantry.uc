/**
 * MetaCorp Infantry base class
 *
 * @todo:  remove the NanoInfantry and jsut name it InfantryBase
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_NanoInfantry extends NanoPawn_MetaCorpBase
	abstract;


var Name KnockdownAnimName;
var Name ShotHitReaction_Head;
var Name ShotHitReaction_Left, ShotHitReaction_Right;
var Name ShoulderHitReaction_Left, ShoulderHitReaction_Right;
var Name StomachHitReaction_Left, StomachHitReaction_Right;
var Name LegHitReaction_Left, LegHitReaction_Right;

var AnimNodeAdditiveBlending AdditiveBlendNode;
var AnimNodeSequence AdditiveSeqNode;
var transient float CachedAdditiveBlendOutTime;

var transient float LastTimeShot;
var transient float ShotHitReactionCounter;

var SoundCue KnockDownBodySound;
var SoundCue KnockDownPainSound;

var SoundCue HitByBulletSound;
var SoundCue KilledByBulletSound;

var config float KnockedDownDamageMultiplier;

var config float FlankAttackDamageMultiplier;
var config float FromBehindDamageMultiplier;

var config float HeadShotAttackDamageMultiplier;

var transient bool bLastReactionWasLeft;
var transient bool bLastReactionFullHitAnimationWasLeft;
var transient float LastLightHitTime;

/** Our "flicker as the pawn dies gore material" **/
var transient MaterialInstanceTimeVarying MITV_Gore;
var transient MaterialInstanceTimeVarying MITV_GoreOverlay;

/** This is how fast this AI can be falling and still survive the drop **/
var float Jump_DestZValueThatICanSurvive;

/** This is how high I can jump in units **/
var float Jump_HowHighICanJumpInStories;

simulated function CacheAnimNodes()
{
	AdditiveBlendNode = AnimNodeAdditiveBlending(Mesh.FindAnimNode('AdditiveBlend'));
	AdditiveSeqNode = AnimNodeSequence(Mesh.FindAnimNode('AdditiveSeq'));
	//`log("!!!!!!!!!!"@`location@`showvar(AdditiveBlendNode));
}

function PlayAdditiveAnim(Name SeqName, float AdditiveWeight, float BlendTime)
{
	AdditiveSeqNode.SetAnim(SeqName);
	AdditiveSeqNode.SetPosition(0.f,FALSE);
	AdditiveBlendNode.SetBlendTarget(AdditiveWeight,BlendTime);
	SetTimer(FMax(0.01,AdditiveSeqNode.GetTimeLeft()-BlendTime),FALSE,nameof(StopAdditiveAnim));
	CachedAdditiveBlendOutTime = BlendTime;
}

function StopAdditiveAnim()
{
	AdditiveBlendNode.SetBlendTarget(0.f,CachedAdditiveBlendOutTime);
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local float ShotDotProduct, ShotSideDotProduct;
	local int ModifiedDamage;
	local NanoAI AI;
	local rotator R;
	local bool bWasHeadShot;
	local name HitReactionAnimToPlay;
	local class<NanoDamageType> NDT;

	//`log( self @ `showvar(Damage) @ `showvar(InstigatedBy) @  `showvar(InstigatedBy.Pawn) @ `showvar(DamageType) @ `showvar(DamageCauser) @ `showvar(InstigatedBy.Pawn.IsSameTeam( self )) @ `showvar(ClassIsChildOf( DamageType, class'NDT_Melee') ) );

	NDT = class<NanoDamageType>(DamageType);


	//`log( `showvar(NDT) @ `showvar(NDT.default.HeadShotAttackDamageMultiplier) @ `showvar(NDT.default.KnockedDownDamageMultiplier) @ `showvar(NDT.default.FlankAttackDamageMultiplier) @ `showvar(NDT.default.FromBehindDamageMultiplier) );

    ShotDotProduct = 1.0f;
	// determine whether the shot came from behind us or not
	if( InstigatedBy != None && InstigatedBy.Pawn != none )
	{
		ShotDotProduct = Normal(InstigatedBy.Pawn.Location - Location) dot Vector(Rotation);
	}

	ModifiedDamage = Damage;

	// only do special modifications if we are not doing melee combat
	if( ClassIsChildOf( DamageType, class'NDT_Melee') == FALSE )
	{

		// check to see if I was shot by my teammate
		if( ( InstigatedBy != None ) && ( InstigatedBy.Pawn != None ) && ( InstigatedBy.Pawn.IsSameTeam( self ) == TRUE ) )
		{
			Damage = 0;
		}

		// determine head shot modifications
		bWasHeadShot = TookHeadShot( HitInfo.BoneName, HitLocation, Momentum );

		if( bWasHeadShot == TRUE ) 
		{
			//`log( "head shot" ) ; 
			ModifiedDamage = Damage * HeadShotAttackDamageMultiplier * NDT.default.HeadShotAttackDamageMultiplier;
		}
		else if( bKnockedDown == TRUE )
		{
			//`log( "knockdown" ) ; 
			ModifiedDamage = Damage * KnockedDownDamageMultiplier * NDT.default.KnockedDownDamageMultiplier;
		}
		// shot from the flank (bias to the flank so you need to be really "behind" to get get behind bonus
		else if( 0.1f > ShotDotProduct && ShotDotProduct >= -0.5f )
		{
			//`log( " flank" );
			ModifiedDamage = Damage * FlankAttackDamageMultiplier * NDT.default.FlankAttackDamageMultiplier;
		}
		// shot from behind
		else if( ShotDotProduct < -0.5f)
		{
			//`log( " behind!" );
			ModifiedDamage = Damage * FromBehindDamageMultiplier * NDT.default.FromBehindDamageMultiplier;
		}
		else
		{
			ModifiedDamage = Damage;
		}
	}


	//`log( `showvar(DamageType) @ `showvar(ModifiedDamage) );

	Super.TakeDamage(ModifiedDamage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

	// check for head shots here
	if( ( Health <= 0 )
		&& ( bWasHeadShot == TRUE )
		&& ( ( NanoPawn(InstigatedBy.Pawn) == none ) || ( NanoPawn(InstigatedBy.Pawn).bIsTargeting  == TRUE) )
		)
	{
		// so we have been head shot.   Need to see if we are prone or not. (right now that is just if we are pinned)
		if( IsDoingSpecialMove('NSM_Melee_PinVictim') == TRUE )
		{
			NanoGRI(WorldInfo.GRI).NGM.ShouldPlayNanoGoreEffect( TRUE, 'HeadShot_LyingProne', self, HitLocation, Momentum );
		}
		else
		{
			NanoGRI(WorldInfo.GRI).NGM.ShouldPlayNanoGoreEffect( TRUE, 'HeadShot', self, HitLocation, Momentum );
			NanoGRI(WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_HeadShot );
		}
	

		// check killer and see if it is player
		if( NanoPC(InstigatedBy) != None )
		{
			if( NanoPC(InstigatedBy).CanGainEXP() == TRUE )
			{
				NanoGRI(WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumHeadShots, 1 );
			}
		}

	}


	//`log( "AGAGAG" );
	NanoGRI(WorldInfo.GRI).AIBlackboard.HandleCombatEvent( NCAT_PlayerHitMe, NanoAIBase(Controller) );
	NanoGRI(WorldInfo.GRI).AIBlackboard.HandleCombatEvent( NCAT_PlayerHitAFoe, NanoAIBase(Controller) );

	// if still alive and some percentage chance
	if( ( Health > 0 ) && ( Frand() > 0.50f ) && ( ModifiedDamage > 0 ) )
	{
		NADSResponse_TrooperWasHit();
	}

	if( ModifiedDamage > 0 && !bIgnoreForces && (!bHasShield || HitInfo.HitComponent != ShieldMeshComp) && !ClassIsChildOf( DamageType, class'NDT_Melee'))
	{
		ShotSideDotProduct = Normal(HitLocation - Location) dot Normal(vector(Rotation) cross vect(0,0,1));
		if (ShotDotProduct < 0.f)
		{
			ShotSideDotProduct *= -1.f;
		}
		bLastReactionWasLeft = (ShotSideDotProduct >= 0.f && !bLastReactionWasLeft);

		// this makes the first shot never have any hit reaction
		// and when you have a one hit or two hit kill weapon you never play any hit reactions
// 		if (`TimeSince(LastTimeShot) > 3.f)
// 		{
// 			ShotHitReactionCounter = 0.f;
// 			`log( "resetting shot hit reaction counter" );
// 		}
// 		else
		if( TRUE )
		{
			ShotHitReactionCounter += 1.f - `TimeSince(LastTimeShot);

			//`log( WorldInfo.TimeSeconds @ "hit react:" @ `showvar(bStunned) @ `showvar(bLastReactionWasLeft) @ `showvar(ShotHitReactionCounter) @ `showvar(`TimeSince(LastTimeShot))  @ `showvar(`TimeSince(TimeOfStun)) @ `showvar(`TimeSince(LastLightHitTime)) );

			//if (Health < DefaultHealth * 0.95f && (!bStunned || `TimeSince(TimeOfStun) > 2.0f) && ShotHitReactionCounter > 2.0f)
			if( ( Health > 0 )  )
			{
				bLastReactionFullHitAnimationWasLeft = (ShotSideDotProduct >= 0.f && !bLastReactionFullHitAnimationWasLeft);

				//`log ( "REAL HIT!" );
				//`log( `showvar(bLastReactionFullHitAnimationWasLeft) );

				if( ( bWasHeadShot == TRUE ) && ( Health > 0 ) )
				{
					HitReactionAnimToPlay = ShotHitReaction_Head;
				}
				else if (HitLocation.Z < Location.Z && VSize(Velocity) < GroundSpeed * 0.3f)
				{
					HitReactionAnimToPlay = bLastReactionWasLeft ? LegHitReaction_Left : LegHitReaction_Right;
				}
				else if (HitLocation.Z < Location.Z + 20.f)
				{
					HitReactionAnimToPlay = bLastReactionWasLeft ? StomachHitReaction_Left : StomachHitReaction_Right;
				}
				else
				{
					HitReactionAnimToPlay = bLastReactionWasLeft ? ShoulderHitReaction_Left : ShoulderHitReaction_Right;
				}


				//`log( `showvar(HitReactionAnimToPlay) );

				class'NanoTypes'.static.FillHitReactionInfo( DeathReaction, HitReactionAnimToPlay, 1.f, (bStunned?0.15f:0.25f), (bStunned?0.8f:0.1f), 0.1f, 0.8f, HitLocation, Normal(Momentum)  );
				DeathReaction.RootMotionMode = RMM_Translate;
				DeathReaction.RootBoneOption[0] = RBA_Translate;
				DeathReaction.RootBoneOption[1] = RBA_Translate;
				DeathReaction.RootBoneOption[2] = RBA_Translate;

				PlayHitReaction( DeathReaction );

				ShotHitReactionCounter = 0.f;

				AI = NanoAI(Controller);
				if( AI != None && AI.bTargetDummy && Physics != PHYS_Falling )
				{
					if (ShotDotProduct < 0.f)
					{
						AI.SetFocalPoint( Location + Normal(Location - InstigatedBy.Pawn.Location) * 512.f);
						R.Yaw = Rotator(Location-InstigatedBy.Pawn.Location).Yaw;
						SetRotation( R );
						//`log( "0" );
					}
					else
					{
						AI.SetFocalPoint( InstigatedBy.Pawn.Location );
						R.Yaw = Rotator(InstigatedBy.Pawn.Location-Location).Yaw;
						SetRotation( R );
						//`log( "1" );
					}
				}

				//`log( "nothinnnning" );
			}
			else if (!bHasShield && `TimeSince(LastLightHitTime) > 0.2f)
			{
				//`log( "DOING NORMAL PLAY ANIM " );

				if( bWasHeadShot == TRUE ) 
				{
					FullBodySlot.PlayCustomAnim(ShotHitReaction_Head,1.f,0.1f,0.1f);
					//PlayAdditiveAnim(ShotHitReaction_Head,1.f,0.1f);
					//`log( "head" );
				}
				else if (HitLocation.Z < Location.Z && VSize(Velocity) < GroundSpeed * 0.3f)
				{
					FullBodySlot.PlayCustomAnim(bLastReactionWasLeft ? LegHitReaction_Left : LegHitReaction_Right,1.f,0.1f,0.1f);
					//PlayAdditiveAnim(bLastReactionWasLeft ? LegHitReaction_Left : LegHitReaction_Right,1.f,0.1f);
					Velocity = vect(0,0,0);
					//`log( "leg" );
				}
				else if (HitLocation.Z < Location.Z + 20.f)
				{
					FullBodySlot.PlayCustomAnim(bLastReactionWasLeft ? StomachHitReaction_Left : StomachHitReaction_Right,1.f,0.2f,0.2f);
					//PlayAdditiveAnim(bLastReactionWasLeft ? StomachHitReaction_Left : StomachHitReaction_Right,1.f,0.1f);
					//`log( "stomach" );
				}
				else
				{
					FullBodySlot.PlayCustomAnim(bLastReactionWasLeft ? ShoulderHitReaction_Left : ShoulderHitReaction_Right,1.f,0.2f,0.2f);
					//PlayAdditiveAnim(bLastReactionWasLeft ? ShoulderHitReaction_Left : ShoulderHitReaction_Right,1.f,0.1f);
					//`log( "shoulder" );
				}

				LastLightHitTime = WorldInfo.TimeSeconds;
			}
			else
			{
				//`log( "super nothing" @ `showvar(`TimeSince(LastLightHitTime) ) );
			}

			if( Health > 0 )
			{		
				// play hit by bullet sound
				PlaySound( HitByBulletSound );
			}
		}

		LastTimeShot = WorldInfo.TimeSeconds;
	}

	// check to see if we should gib based on our damage type
	if( ( Health <= 0 )
		&& ( class<NanoDamageType>(DamageType).static.ShouldGib( self, InstigatedBy.Pawn ) == TRUE )
		)
	{
		NanoGRI(WorldInfo.GRI).NGM.ShouldPlayNanoGoreEffect( TRUE, 'GoreExplosionForced', self, HitLocation, Momentum );
	}

		//`log( `showvar(ModifiedDamage) @`showvar(DamageType) @ `showvar(InstigatedBy) );		


	if( Health > 0 )
	{
		DeathReaction.AnimName = '';
	}
}

simulated function PlayKnockdown()
{
	if( KnockdownAnimName != '' )
	{
		FullBodySlot.PlayCustomAnim(KnockdownAnimName,1.f,0.5f,-1.f);
	}
		
	PlaySound(KnockDownBodySound);
	PlaySound(KnockDownPainSound);

	DropShield();
}

simulated function float PlayGetup( optional bool bFromBack = TRUE )
{
	local float AnimTime;
	local Name GetupAnimName;

	GetupAnimName = bFromBack ? 'Getup_From_Back' : 'Getup_From_Front';
	
	AnimTime = FullBodySlot.PlayCustomAnimEx( GetupAnimName, GetUpAnimRate, 0.0f, 0.33f, FALSE, TRUE );
	FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );
	FullBodySlot.SetActorAnimEndNotification( TRUE );
	return AnimTime;
}


function PlayDeathScreamSound()
{
	if( DeathSoundForPawnToPlay == FALSE )
	{
		PlaySound( KilledByBulletSound );
	}
}

/** If we have died, then we are going to let all of our friends in the various melee lists have chance to say something **/
function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local vector GoreExplosionMomentum;

	//`log( `showvar(DamageType) );
	//ScriptTrace();

	if( !ClassIsChildOf( DamageType, class'NDT_Melee') && ( class'NDT_KilledByProceduralSpawner' != DamageType ) )
	{
		PlayDeathScreamSound();
	}

	if( class'NDT_KilledByProceduralSpawner' != DamageType )
	{
		NanoGRI(WorldInfo.GRI).AIBlackboard.HandleCombatEvent( NCAT_PlayerKilledAFoe, NanoAIBase(Controller) );
		NADSResponse_MeleeParticipants();
	}

	if( class<NanoDamageType>(DamageType) == class'NDT_DroppingTheHammer' )
	{
		GoreExplosionMomentum = vect(0,0,400);
		NanoGRI(WorldInfo.GRI).NGM.ShouldPlayNanoGoreEffect( TRUE, 'DroppingTheHammer', self, HitLocation, GoreExplosionMomentum );	
	}

	return Super.Died( Killer, DamageType, HitLocation );
}

/** This will look at the melee lists and then choose a random AI and have it send out a NADS event **/
function NADSResponse_MeleeParticipants()
{
	local TargetableOctreeComponent Targetable;
	local NanoAIBase AI;

	Targetable = NanoInterface_Targetable(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn).GetTargetableOctreeComponent();

	if( Targetable.MeleeSpectatorList.Length > 0 )
	{
		AI = Targetable.MeleeSpectatorList[ Rand( Targetable.MeleeSpectatorList.Length ) ];
		NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_Combat_SpectatorCircle_SeesBuddyDie, AI.Pawn );	
	}
}


/** If we were hit let's have the standby ring have a chance to say something **/
function NADSResponse_TrooperWasHit()
{
	local TargetableOctreeComponent Targetable;
	local NanoAIBase AI;

	Targetable = NanoInterface_Targetable(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn).GetTargetableOctreeComponent();

	if( Targetable.MeleeStandByList.Length > 0 )
	{
		AI = Targetable.MeleeStandByList[ Rand( Targetable.MeleeStandByList.Length ) ];
		NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_Combat_StandbyCircle_SawBuddyGetHit, AI.Pawn );	
	}
}

function NADSResponse_TrooperWasTackled()
{
	local TargetableOctreeComponent Targetable;
	local NanoAIBase AI;

	Targetable = NanoInterface_Targetable(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn).GetTargetableOctreeComponent();

	if( Targetable.MeleeStandByList.Length > 0 )
	{
		AI = Targetable.MeleeStandByList[ Rand( Targetable.MeleeStandByList.Length ) ];
		NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_Combat_StandbyCircle_SawBuddyGetTackled, AI.Pawn );	
	}
}

function DoGoreGlowEffect( float DurationOfGlow )
{
	local InterpCurveFloat Points;
	local InterpCurvePointFloat Point;

	if( MITV_Gore != None )
	{
		Points.Points.length = 2;

		Point.InVal = 0.0f;
		Point.OutVal = 1.0f;
		Points.Points[0] = Point;

		Point.InVal = DurationOfGlow;
		Point.OutVal = 0.0f;
		Points.Points[1] = Point;

		MITV_Gore.SetScalarCurveParameterValue( 'Glow', Points );
		MITV_Gore.SetScalarStartTime( 'Glow', 0.0f );
	}
}


function DoGoreParam( out MaterialInstanceTimeVarying MITV, const name ParamName, const float DurationOfGlow, const float Delay, const bool bFadeBackToZero, const float FadeBackDownToZeroAfterReachingOne_Delay, const float FadeBackDownToZeroAfterReachingOne_Duration )
{
	local InterpCurveFloat Points;
	local InterpCurvePointFloat Point;

	if( MITV != None )
	{
		if( bFadeBackToZero == TRUE )
		{
			Points.Points.length = 4;
		}
		else
		{
			Points.Points.length = 2;
		}

		Point.InVal = 0.0f;
		Point.OutVal = 0.0f;
		Points.Points[0] = Point;

		Point.InVal = DurationOfGlow;
		Point.OutVal = 1.0f;
		Points.Points[1] = Point;


		if( bFadeBackToZero == TRUE )
		{
			Point.InVal = Points.Points[1].InVal + FadeBackDownToZeroAfterReachingOne_Delay;
			Point.OutVal = 1.0f;
			Points.Points[2] = Point;

			Point.InVal = Points.Points[2].InVal + FadeBackDownToZeroAfterReachingOne_Duration;
			Point.OutVal = 0.0f;
			Points.Points[3] = Point;
		}


		MITV.SetScalarCurveParameterValue( ParamName, Points );
		MITV.SetScalarStartTime( ParamName, Delay );
	}
}


function class<NanoAICmd> GetSpecialMeleeMove();

function bool AbleToDoSpecialMeleeMove();

function DidSpecialMeleeMove();


function AddPawnBasedPathConstraints()
{
	class'NavMeshPath_AvoidJumpsDownThatWillKill'.static.AvoidJumpsThatWillKill( NanoAIBase(Controller).NavigationHandle, Jump_DestZValueThatICanSurvive );
	class'NavMeshPath_AvoidJumpUpsThatAreTooHigh'.static.AvoidJumpUpsThatAreTooHigh( NanoAIBase(Controller).NavigationHandle, GetNumUnitsFromNumStoriesForJumping(Jump_HowHighICanJumpInStories) );
}

final function int GetNumUnitsFromNumStoriesForJumping( int InNumStories )
{
	// we do story + story-1 to make certain our none vertical line has a chance
	return (InNumStories * 384) + 383;
}

simulated function PossiblySpawnIRIS_FirstEncounterEffect()
{

	//`log( `showvar( `TimeSince(LastRenderTime)) @ `showvar(`TimeSince(TimeSpawnedFirstEncounterEffect)) );

	if( ( `TimeSince(LastRenderTime) < 0.200f )
		&& ( TimeSpawnedFirstEncounterEffect == 0.0f ) // for now
		//&& ( `TimeSince(TimeSpawnedFirstEncounterEffect) > DurationBeforeSpawningFirstEncounterEffects )
		)
	{
		SpawnIRIS_FirstEncounterEffect();
	}
}




defaultproperties
{
	CharacterFootStepType=NFST_MetaCorp_Generic

	bShouldDestroyWhenNotSeen=TRUE

	FirstPersonCamBoneName="b_MF_Head"
	ThirdPersonCamBoneName="b_MF_Head"

	ShotHitReaction_Head="HitReactionHead"
	ShotHitReaction_Left="Shot_Arm_L"
	ShotHitReaction_Right="Shot_Arm_R"
	ShoulderHitReaction_Left="HitReactionLeftShoulder"
	ShoulderHitReaction_Right="HitReactionRightShoulder"
	StomachHitReaction_Left="HitReactionStomach"
	StomachHitReaction_Right="HitReactionStomach"
	LegHitReaction_Left="HitReactionLeftLeg"
	LegHitReaction_Right="HitReactionRightLeg"
	LastTimeShot=-1.f


	HitBySwordSound=SoundCue'Weapon_Sword.Sword_Impact.Sword_SlashImpactSmall_Cue'
	HitBySwordDismember300Sound=SoundCue'Weapon_Sword.Sword_Movement.Combat_SlomoHackedOff_Cue'

	HitBySwordAndKilledSound=SoundCue'Weapon_Sword.Sword_Impact.Sword_SlashRegularDeath_01Cue'
	HitByElbowOrFootAndKilledSound=SoundCue'Foley_Flesh.Flesh.Kick_ImpactDeath_Cue'

	HitByBulletSound=SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_Pain_Cue'
	KilledByBulletSound=SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_Death_Cue'

	HitByStaffSound=SoundCue'Weapon_Staff.Impacts.Staff_ImpactFlesh_Cue'
	HitByStaffAndKilledSound=SoundCue'Weapon_Staff.Impacts.Staff_ImpactFleshKill_Cue'



	// this is the DestFallZ distance for 2 stories.
	Jump_DestZValueThatICanSurvive=2320
	Jump_HowHighICanJumpInStories=1


	// give infantry a lil bit of glow to make them stand out of the darkness some
	Begin Object Name=MyLightEnvironment
	    AmbientGlow=(R=0.3f,G=0.3f,B=0.3f,A=1.0)
	End Object



}