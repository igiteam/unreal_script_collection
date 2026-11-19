/**
 * MetaCorp pawn base class
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorpBase extends NanoPawn_Infantry
	config(Pawn)
	implements(NanoInterface_JuggleCollision,NanoInterface_JuggleTarget)
	abstract;

var()	vector	TackleAttachOffset;

var NanoCameraShake TackleScreenShake;
var ForceFeedbackWaveform TackleWaveForm;
var SoundCue TackleSound;
var SoundCue TacklePickupSound;

var NanoCameraShake BoulderScreenShake;
var ForceFeedbackWaveform BoulderWaveForm;
var SoundCue BoulderSound;

var NanoCameraShake ShatterScreenShake;
var ForceFeedbackWaveform ShatterWaveForm;

/** These are the orbital attractors currently on this actor.  They get turned on and off by the NanoWeap_Orbitals_Base **/
var transient array<NxForceField> OrbitalsAttractList;

/** How long the pawn should be knocked down due to beig juggled into **/
var config float JuggleKnockDownDuration;


/** The last time we were aimed at **/
var transient float LastTimeBeingAimedAt;

// Notification from AI of change in confrontation type
simulated function NotifyConfrontationTypeChanged( EConfrontationType CT, EConfrontationType LastCT )
{
	// hack
	// We need to really understand and manage RootMotionMode Settings
	if( CurrentLadder != None )
	{
		//`log( self @ "We are on a ladder!  Don't mess with RootMotionMode" );
		return;
	}

	//`log( self @ "!!!!!!!!!!!!!!!!!!!!!!!!!"@`showvar(CT)@`showvar(LastCT));

	if( CT == ECFT_Melee_Engaged && LastCT == ECFT_None && NanoWeap_Melee(Weapon) == None )
	{
		DoSpecialMove( 'NSM_Trooper_DeployBaton', TRUE );
	}

	if( CT == ECFT_Melee_Engaged || CT == ECFT_Melee_Attacking )
	{
		//`log( "   Setting Mesh.RootMotionMode = RMM_Ignore" );
		Mesh.RootMotionMode = RMM_Ignore;
	}
	else
	{
		Mesh.RootMotionMode = default.Mesh.RootMotionMode;
		//`log( "    Setting Mesh.RootMotionMode = RMM_Velocity" @ `showvar(Mesh.RootMotionMode) @ `showvar(default.Mesh.RootMotionMode) );
	}
}

simulated function SetUpOrbitalAttractor()
{
	AddAnOrbitalAttractorRadial( 'OrbitalsCalfLeft', 100.0f, -25.0f );
	AddAnOrbitalAttractorRadial( 'OrbitalsCalfRight', 100.0f, -25.0f );
	AddAnOrbitalAttractorRadial( 'OrbitalsNeck', 200.0f, -50.0f );
	AddAnOrbitalAttractorRadial( 'OrbitalsSpine', 200.0f, -50.0f );

	//AddAnOrbitalAttractorTornado( 'OrbitalsCalfLeft', 10.0f, -25.0f );
	//AddAnOrbitalAttractorTornado( 'OrbitalsCalfRight', 100.0f, -25.0f );
	//AddAnOrbitalAttractorTornado( 'OrbitalsNeck', 200.0f, -50.0f );
	//AddAnOrbitalAttractorTornado( 'OrbitalsSpine', 200.0f, -50.0f );
}


simulated function AddAnOrbitalAttractorTornado( name SocketName, float InRadius, float InStrength )
{
    local NanoForceField_OrbitalAttractorTornado OrbitalsAttact;

	OrbitalsAttact = Spawn( class'NanoForceField_OrbitalAttractorTornado', self,,Location+Vect(0,0,550) );
	OrbitalsAttact.Shape = new(OrbitalsAttact) class'ForceFieldShapeSphere';

    OrbitalsAttact.bForceActive = FALSE;

    OrbitalsAttact.RadialStrength = -50;
	OrbitalsAttact.RotationalStrength = 5;
	OrbitalsAttact.LiftStrength = 5;
	OrbitalsAttact.ForceRadius = 5;
	OrbitalsAttact.ForceTopRadius = 10;
	OrbitalsAttact.LiftFalloffHeight = 0.5f;
	OrbitalsAttact.EscapeVelocity = 50000;
	OrbitalsAttact.ForceHeight = 10;
	OrbitalsAttact.HeightOffset = 0;
	OrbitalsAttact.SelfRotationStrength = 5;
	OrbitalsAttact.BSpecialRadialForceMode = FALSE;


    OrbitalsAttact.SetHardAttach( TRUE );
	OrbitalsAttact.SetBase( self, , Mesh, SocketName );

	OrbitalsAttact.DoInitRBPhys();

	OrbitalsAttractList.AddItem( OrbitalsAttact );
}


simulated function AddAnOrbitalAttractorRadial( name SocketName, float InRadius, float InStrength )
{
    local NanoForceField_OrbitalAttractorRadial OrbitalsAttact;

	OrbitalsAttact = Spawn( class'NanoForceField_OrbitalAttractorRadial', self,,Location+Vect(0,0,550) );
	OrbitalsAttact.Shape = new(OrbitalsAttact) class'ForceFieldShapeSphere';

    OrbitalsAttact.bForceActive = FALSE;

    OrbitalsAttact.ForceRadius = InRadius;
	OrbitalsAttact.ForceStrength = InStrength;
	OrbitalsAttact.ForceFalloff = RIF_Linear;

    OrbitalsAttact.SetHardAttach( TRUE );
	OrbitalsAttact.SetBase( self, , Mesh, SocketName );

	OrbitalsAttact.DoInitRBPhys();

	OrbitalsAttractList.AddItem( OrbitalsAttact );
}


/** This will activate orbital attractors on this target. **/
simulated function ActivateOrbitalAttractors()
{
	local NxForceField FF;

	// make certain we have some force fields
	if( OrbitalsAttractList.Length == 0 )
	{
		//SetUpOrbitalAttractor();
	}

	foreach OrbitalsAttractList(FF)
	{
		//`log( "ActivateOrbitalAttractors" @ self @ FF );
		FF.bForceActive = TRUE;
		//FF.DoInitRBPhys();
	}
}


/** This will deactivate orbital attractors on this target. **/
simulated function DeactivateOrbitalAttractors()
{
	local NxForceField FF;

    //`log( "DeactivateOrbitalAttractorsDeactivateOrbitalAttractorsDeactivateOrbitalAttractors" @ self );

	foreach OrbitalsAttractList(FF)
	{
		FF.bForceActive = FALSE;
		//FF.DoInitRBPhys();
	}
}


function SpawnAnOrb()
{
	// no longer spawn orbs
// 	local class<NanoAbsorbOrb> DroppedOrbClass;
// 
// 	foreach DroppedOrbClasses( DroppedOrbClass )
// 	{
// 		Orbs.AddItem( NanoGRI(WorldInfo.GRI).SpawnANanoOrb( DroppedOrbClass, self, FALSE ) );
// 	}

	//Orb.SetLocation( Mesh.GetBoneLocation( MeleeDamageBoneName ) );
	//Orb.SetBase( self, , Mesh, MeleeDamageBoneName );
}


simulated event Destroyed()
{
	local NxForceField FF;

	foreach OrbitalsAttractList(FF)
	{
		FF.Destroy();
	}

	Super.Destroyed();
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    if( Super.Died(Killer,DamageType,HitLocation) )
    {
    	DeactivateOrbitalAttractors();

		NanoGRI(WorldInfo.GRI).AIBlackboard.RemoveAISpawnedFromADropPod( NanoAI(Controller) );

		return TRUE;
    }

    return FALSE;
}


event EncroachedBy(Actor Other)
{
	local Nano_KActor NKActor;

	NKActor = Nano_KActor(Other);
	if((Role == ROLE_Authority) && (Health > 0) && (NKActor != None) && NKActor.bBoulderWeaponisable)
	{
		Died(None, class'NanoGame.NDT_PhysCrushed', Location);
	}

	Super.EncroachedBy(Other);
}

event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	local NanoPawn NP;

	Super.Bump( Other, OtherComp, HitNormal );

	// If 'bouldered' in to by a dense pawn, die and fly off!
	NP = NanoPawn(Other);
	if( Role == ROLE_Authority && Health > 0 && NP != None )
	{
		// Hit by dashing person
		if( NP.bIsDashing )
		{
			// If I am normal, and other is dense
			if( CurrNanoState == ENS_Normal && NP.CurrNanoState == ENS_Dense )
			{
				//Died(NP.Controller, class'NanoGame.NDT_BoulderedInto', Location);
			}
			// If both are dense
			else if( CurrNanoState == ENS_Dense && NP.CurrNanoState == ENS_Dense )
			{
				ShatteredByActor = NP;
				Died(NP.Controller, class'NanoGame.NDT_Shattered', Location);
			}
		}
	}
}

simulated function JuggleCollisionWithJuggledActor(NanoPawnBase NPCollider)
{
	if( !NPCollider.IsSameTeam( self ) )
	{
		return;
	}

	NPCollider.bJuggleForceKnockDown = TRUE;

	// so here we want to knock down this pawn and then also make it so we can keep juggling the NPCollider through to
	// hit other pawns.  
	// @HACK We do that by setting the collision on this pawn off for a brief moment in time and then restoring it. 
	//       Once we get the ragdolling code ported from gears then we should utilize that
    Knockdown( JuggleKnockDownDuration );
    SetCollision( TRUE, FALSE );

	// assumption is that 1 second will let us pass through and is short enough that if we stopped juggling
	// to attack this guy that he be be collideable again
	SetTimer( 1.0f, FALSE, nameof(RestoreCollisionPostJuggleCollision) );
}

/** This restores the pawn's collision after we turn it off due to post juggle **/
simulated function RestoreCollisionPostJuggleCollision()
{
	SetCollision( TRUE, TRUE );
}


simulated function BoulderedIntoBy(NanoPawn NP)
{
	local vector ThrowVel;
	local NanoPC NPC;

	// Sound/shake
	NPC = NanoPC(NP.Controller);
	if(NPC != None)
	{
		NPC.PlaySound(BoulderSound);
		NPC.ClientPlayCameraShake(BoulderScreenShake);
		NPC.ClientPlayForceFeedbackWaveform(BoulderWaveForm);
	}

	// If this puts me into ragdoll (it should), throw it in direction we were moving
	if(Physics == PHYS_RigidBody)
	{
		// Add some up
		ThrowVel = NP.Velocity + (vect(0,0,1) * VSize2D(NP.Velocity) * 0.4);
		Mesh.SetRBLinearVelocity(ThrowVel, TRUE);
	}
}

simulated function TackledBy( NanoPawn Tackler )
{
	local NanoPC PC;

	PC = NanoPC(Tackler.Controller);
	if( PC != None )
	{
		PC.PlaySound(TackleSound);
	}
	PlaySound(TacklePickupSound);
}

simulated function ShatteredBy(Actor Shatterer)
{
	local SpawnedNanoEmitter Impact;
	local vector ExploDir;
	local NanoPC NPC;
	local NanoPawn NP;

	`log("---"@self@"ShatteredBy"@Shatterer);

	// If hit by a pawn, shake their camera/controller
	NP = NanoPawn(Shatterer);
	if(NP != None)
	{
		NPC = NanoPC(NP.Controller);
		if(NPC != None)
		{
//			NPC.ClientPlayCameraShake(ShatterScreenShake);
//			NPC.ClientPlayForceFeedbackWaveform(ShatterWaveForm);
		}
	}

	Destroy();

	// Spawn shattering actor (should shatter as soon as its spawned)
	ExploDir = Shatterer.Velocity;
	ExploDir.Z = 0.0;
	ExploDir = Normal(ExploDir);

	Spawn(class'Nano_ShockTroopShatterBody',,, Location, rotator(ExploDir));

	// Spawn effect
	Impact = Spawn(class'SpawnedNanoEmitter',,, Location, Rotation);
	Impact.SetTemplate(ParticleSystem'Nano_FX.Effects.P_FX_NanoBeam_DenseDisperse',TRUE);
}

simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook )
{
	local SpawnedNanoEmitter Emitter;

	if( Health <= 0 )
		return FALSE;

	Hook.PlaySound( Hook.ImpactAPawnSound, TRUE, TRUE, FALSE, Hook.Location );
	Emitter = Spawn(class'SpawnedNanoEmitter',,,Hook.Location);
	Emitter.SetTemplate(ParticleSystem'Nano_WeaponFX.Moon.Effects.P_FX_Moon_ImpactEffect',TRUE);
	TakeDamage(Hook.ImpactDamage, Hook.Instigator.Controller, Hook.Location, Hook.Velocity, class'NanoGame.NDT_RicochetMoonThrown',,Hook);
	DropShield();
	return TRUE;
//	Knockdown( Hook.KnockDownTime );
//	return FALSE;
}

/** This Pawn has touched a slickified surface **/
simulated function OnSlickify()
{
    Super.OnSlickify();
			
    DropShield();		
    Knockdown( 5.0f );
}



simulated function bool IsShowcaseForForMelee()
{
	return FALSE;
}





defaultproperties
{
	TackleAttachOffset=(X=50,Y=-50)


	Begin Object Class=NanoCameraShake Name=TackleScreenShake0
		OscillationDuration=2.f
		RotOscillation={(Pitch=(Amplitude=1000.f,Frequency=80.f),
						Yaw=(Amplitude=400.f,Frequency=40.f),
						Roll=(Amplitude=600.f,Frequency=50.f))}
	End Object
	TackleScreenShake=TackleScreenShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformTackle
		Samples(0)=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
	End Object
	TackleWaveForm=ForceFeedbackWaveformTackle

	TackleSound=SoundCue'Foley_Body.MetaCorps.MetaCorpsB_BodyFall_Cue'
	TacklePickupSound=SoundCue'Foley_Body.Player.Body_PickupBody_Cue'

	Begin Object Class=NanoCameraShake Name=BoulderScreenShake0
		OscillationDuration=0.5f
		RotOscillation={(Pitch=(Amplitude=100.f,Frequency=80.f),
						Yaw=(Amplitude=200.f,Frequency=40.f),
						Roll=(Amplitude=300.f,Frequency=50.f))}
	End Object
	BoulderScreenShake=BoulderScreenShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBoulder
		Samples(0)=(LeftAmplitude=80,RightAmplitude=80,LeftFunction=WF_Constant,RightFunction=WF_LinearIncreasing,Duration=0.250)
	End Object
	BoulderWaveForm=ForceFeedbackWaveformBoulder

	BoulderSound=SoundCue'Vehicle_AirCar.Impacts.CarImpact_DeepThud_Cue'

	Begin Object Class=NanoCameraShake Name=ShatterScreenShake0
		OscillationDuration=2.f
		RotOscillation={(Pitch=(Amplitude=1000.f,Frequency=80.f),
						Yaw=(Amplitude=400.f,Frequency=40.f),
						Roll=(Amplitude=600.f,Frequency=50.f))}
	End Object
	ShatterScreenShake=ShatterScreenShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShatter
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
	End Object
	ShatterWaveForm=ForceFeedbackWaveformShatter


	Begin Object Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,bShownEvenIfClamped=TRUE,DistancesToDrawIcon=(X=0,Y=0),Icon=Texture2D'UI_HUD.Minimap.GenericEnemy',IconScale=0.06f,IconColor=(R=255,G=64,B=64,A=255),bAlternateAboveBelowIcon=FALSE,AboveBelowIconScale=0.06f,TextName="",TextDescription="",TextVerticalOffset=0.0f)
	End Object
	UIComponent=UIIconComponent0

	DroppedOrbClasses.Add(class'NanoAbsorbOrb_Body')
	DBNOAudio=NanoDBNOAudio'DBNOAudioArchetypes.Trooper'
}