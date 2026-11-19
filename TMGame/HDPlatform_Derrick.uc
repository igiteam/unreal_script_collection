/**
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class HDPlatform_Derrick extends InterpActor_GearBasePlatform
	native(TG)
	notplaceable;

var() const array<MaterialInterface>	VehMaterials;
var() const array<StaticMesh>	DestoryVehMeshs;

var() protected transient HDPlatform_DerrickWheels				WheelActor;

var() protected const class<HDPlatform_DerrickWheels>	WheelActorClass;

var() transient HDTurret_Base                         TurretActor;
var protected const editconst class<HDTurret_Base>              TurretActorClass;

/** Skelmesh we carry around for previewing in the editor. */
var protected transient SkeletalMeshComponent				EditorWheelsPreviewMesh;

/** TRUE to suppress all audio for this derrick.  Useful for derricks in the distance. */
var() protected const bool		bNoAudio;

var transient bool				bPlayerAudioIsPlaying;
//var transient bool				bNonPlayerAudioIsPlaying;

///** True if the derrick's engine is running. */
var() repnotify protected bool			bEngineRunning;

/** Not actual RPM, but an abstract concept of engine "effort" above the idle baseline, used to control engine audio.  Normalized to be [0..1]. */
var() protected transient float	EngineRPM;

var protected transient float	LastEngineRPM;
var() protected const float		EngineRPMInterpSpeed;

var() protected const vector2d	EngineRPMAccelRange;
var() protected const vector2d	EngineRPMVelRange;

var protected transient vector	LastActualVelocity;

//
// AUDIO
//

/** Plays only on derricks ridden by a player.  Nonspatialized stereo loops. */
var AudioComponent					PlayerEngineMainLoop;
var() protected transient SoundCue	PlayerEngineMainLoopCue;
var AudioComponent                  ExplodeAudio;
var() protected transient SoundCue	ExplodeAudioCue;

var() protected const SoundCue		StopEngineSound;
var() protected const SoundCue		StartEngineSound;


/** TRUE means this derrick will have no glass. */
var() protected const bool			bNoGlass;
var protected StaticMeshComponent	GlassMesh;

var() protected const bool			bNoJiggle;

/** This forces the wheels to always update, even when derrick is not rendered. This is obviously more costly, but will fix popping issues when you first see the derrick */
var() bool							bAlwaysUpdateWheels;
var() const ParticleSystem			WheelDust;
var() bool                          bHasInCarNpc;
var float                           Health;
var() float                         MaxHealth;
var() bool                          bRecoverHealth;
var   bool                          bDestroyed;
var() bool                          bAutoDestroy;
var   float                         LastDamageTime;
var   float                         RecoverRate;
var() bool                          SimpleSim;
enum EDerrickStripeColor
{
	DerrickStripe_DefaultBlue,
	DerrickStripe_LightBlue,
	DerrickStripe_White,
	DerrickStripe_Yellow,
	DerrickStripe_Green,
};
//var protected const array<LinearColor>				AvailableStripeColors;

/** MIC for stripe coloring */
//var protected transient MaterialInstanceConstant	MIC_Stripe;

//var() protected const EDerrickStripeColor			StripeColor;

/** replicated to tell clients about hatch state */
var repnotify bool bHatchOpened;
/** replicated to tell clients about cabin state */
var repnotify bool bCabinOpened;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

replication
{
	if (bNetDirty)
		bEngineRunning, bHatchOpened, bCabinOpened;
}

/** Internal.  Sets up an audiocomponent. */
simulated protected function AudioComponent CreateAndAttachAudioComponent(SoundCue Cue,bool bSpatialization,optional bool bPlayImmediately)
{
	local AudioComponent AC;

	AC = CreateAudioComponent(Cue, FALSE, TRUE);
	if (AC != None)
	{
		AC.bUseOwnerLocation = TRUE;
		AC.bAllowSpatialization = bSpatialization;
		AC.bAutoDestroy = FALSE;
		AC.bShouldRemainActiveIfDropped = TRUE;
		if(bPlayImmediately)
		{
          AC.Play();
        }
	}

	return AC;
}


simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	// oddly, it seems as if the staticmeshcomponent can lose it's DLE when it is placed
	// and then moved to a different sublevel.  This makes sure it is set properly.
	if (StaticMeshComponent != None)
	{
		StaticMeshComponent.SetLightEnvironment(LightEnvironment);
	}
//    SetCollisionType(COLLIDE_BlockAll);
 // spawn the wheels
	WheelActor = Spawn(WheelActorClass, self,, Location, Rotation,, TRUE);
	if (WheelActor != None)
	{
		WheelActor.AttachToDerrick(self);
		//WheelActor.GetMesh().SetLightEnvironment(LightEnvironment);
	}

	// set up glass
//	if (bNoGlass)
//	{
//		GlassMesh.SetHidden(TRUE);
//		DetachComponent(GlassMesh);
//		GlassMesh = None;
//	}
//	else
//	{
//		GlassMesh.SetShadowParent(StaticMeshComponent);
//	}
//
//	// propagate forced lod level to other meshes
//	if (GlassMesh != None)
//	{
//		GlassMesh.ForcedLODModel = StaticMeshComponent.ForcedLODModel;
//	}
//
//	if (StripeColor != DerrickStripe_DefaultBlue)
//	{
//		MIC_Stripe = StaticMeshComponent.CreateAndSetMaterialInstanceConstant(4);
//		MIC_Stripe.SetVectorParameterValue('Derrick_Stripe_Color', AvailableStripeColors[StripeColor]);
//	}

	// since we're in the game, not the editor, release the ref to this so the object can be destroyed
	DetachComponent(EditorWheelsPreviewMesh);
	EditorWheelsPreviewMesh = None;

    //SetHidden(TRUE);
	// so we have just attached a bunch of stuff we need to recheck this and call it again.   Super.PostBeginPlay() could be moved lower
	// but don't want to break anything
	if (bShouldShadowParentAllAttachedActors)
	{
		SetShadowParentOnAllAttachedComponents();
	}

	if(!bHasInCarNpc)
    {
		TurretActor = Spawn(TurretActorClass, WheelActor,, Location, Rotation,,true);
		if(TurretActor != None)
		{
	    	TurretActor.AttachToPlatformWheels(WheelActor);
	    }
	}

	Health = MaxHealth;
}

/** Set up audio to be player, nonplayer, or neither.  Should be rarely called. */
simulated protected event SetupAudio(bool bDoingPlayerAudio)
{
	if (bDoingPlayerAudio)
	{
		// make sure the stereo loops exist and are playing
		if (PlayerEngineMainLoop == None)
		{
			PlayerEngineMainLoop = CreateAndAttachAudioComponent(PlayerEngineMainLoopCue, TRUE);
		}
//		if (PlayerEngineMainLoop != None)
//		{
//			PlayerEngineMainLoop.Play();
//		}
	}
	else
	{
		if (PlayerEngineMainLoop != None)
		{
			PlayerEngineMainLoop.Stop();
		}
	}
	if(ExplodeAudio == none)
	{
	  ExplodeAudio = CreateAndAttachAudioComponent(ExplodeAudioCue, TRUE);
    }
	bPlayerAudioIsPlaying = bDoingPlayerAudio;

}

/** Overridden to clean up wheel actor. */
simulated event ShutDown()
{
	Super.ShutDown();
	WheelActor.Destroy();
	WheelActor = None;
}


//simulated function bool EncroachingOn(Actor Other)
//{
//	local bool bEncroachUnresolved;
//
//	if ( (Other.Base == self) && (GearPawn(Other) != None) ) //  /* && Other.bHardAttach && !Other.bBlockActors*/ )
//	{
//		// allow this encroachment without complaint
//		`log("***"@self@"encroached"@Other);
//		bEncroachUnresolved = FALSE;
//	}
//	else
//	{
//		bEncroachUnresolved = super.EncroachingOn(Other);
//	}
//
//	return bEncroachUnresolved;
//}
//
//simulated function Tick(float DeltaTime)
//{
//	super.Tick(DeltaTime);
//
//	if (bPlayerAudioIsPlaying)
//	{
//		`log("**** "@self@"stereo:"@PlayerEngineMainLoop.SoundCue@PlayerEngineMainLoop.IsPlaying()@PlayerEngineMainLoop.CurrentVolume);
//		`log("     "@"wheels left:"@WheelActor.EngineAudio_Player_Left.SoundCue@WheelActor.EngineAudio_Player_Left.IsPlaying()@WheelActor.EngineAudio_Player_Left.CurrentVolume);
//		`log("     "@"wheels rght:"@WheelActor.EngineAudio_Player_Right.SoundCue@WheelActor.EngineAudio_Player_Right.IsPlaying()@WheelActor.EngineAudio_Player_Right.CurrentVolume);
//	}
//}


/** Overridden to hide the wheels, too. */
simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
	Super.OnToggleHidden(Action);

	// keep wheels hidden-status in sync.
	// this isn't ideal, but SetHidden is final in the engine.  It should work for how we're using the derrick, though.
	if (bHidden != WheelActor.bHidden)
	{
		WheelActor.SetWheelsHidden(bHidden);
	}

	if (bHidden)
	{
		SetupAudio(FALSE);
	}
	else
	{
		// make sure our audio will automatically restart in tick()
		bPlayerAudioIsPlaying = FALSE;
		//bNonPlayerAudioIsPlaying = FALSE;
	}
}

simulated function StopEngine()
{
	SetupAudio(FALSE);

	PlaySound(StopEngineSound, true);

	bEngineRunning = FALSE;
}

simulated function StartEngine()
{
	PlaySound(StartEngineSound, true);
	bEngineRunning = TRUE;

	// next tick will setup engine audio
	bPlayerAudioIsPlaying = FALSE;
	//bNonPlayerAudioIsPlaying = FALSE;

}

simulated function OnDerrickControl(HDSeqAct_DerrickControl Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		// "start engine" input
		if (!bEngineRunning)
		{
			StartEngine();
		}
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		if (bEngineRunning)
		{
			// "stop engine" input
			StopEngine();
		}
	}
	//else if (Action.InputLinks[2].bHasImpulse)
//	{
//		// "Open Hatch"
//		WheelActor.OpenHatch();
//		bHatchOpened = true;
//	}
//	else if (Action.InputLinks[3].bHasImpulse)
//	{
//		// "Close Hatch"
//		WheelActor.CloseHatch();
//		bHatchOpened = false;
//	}
//	else if (Action.InputLinks[4].bHasImpulse)
//	{
//		// "Open Cabin Door"
//		WheelActor.OpenCabinDoor();
//		bCabinOpened = true;
//	}
//	else if (Action.InputLinks[5].bHasImpulse)
//	{
//		// "Close Cabin Door"
//		WheelActor.CloseCabinDoor();
//		bCabinOpened = false;
//	}
//	else if (Action.InputLinks[6].bHasImpulse)
//	{
//		// "Left Arm Prepare"
//		WheelActor.LeftArmPrepare();
//	}
//	else if (Action.InputLinks[7].bHasImpulse)
//	{
//		// "Left Arm Deploy"
//		WheelActor.LeftArmDeploy();
//	}
//	else if (Action.InputLinks[8].bHasImpulse)
//	{
//		// "Right Arm Prepare"
//		WheelActor.RightArmPrepare();
//	}
//	else if (Action.InputLinks[9].bHasImpulse)
//	{
//		// "Right Arm Deploy"
//		WheelActor.RightArmDeploy();
//	}

	ForceNetRelevant();
}

simulated event ReplicatedEvent(name VarName)
{
//	if (VarName == nameof(bHatchOpened))
//	{
//		if (WheelActor != None)
//		{
//			if (bHatchOpened)
//			{
//				WheelActor.OpenHatch();
//			}
//			else
//			{
//				WheelActor.CloseHatch();
//			}
//		}
//	}
//	else if (VarName == nameof(bCabinOpened))
//	{
//		if (WheelActor != None)
//		{
//			if (bCabinOpened)
//			{
//				WheelActor.OpenCabinDoor();
//			}
//			else
//			{
//				WheelActor.CloseCabinDoor();
//			}
//		}
//	}
//	else
	if (VarName == nameof(bEngineRunning))
	{
		if (bEngineRunning)
		{
			StartEngine();
		}
		else
		{
			StopEngine();
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

function ApplyCheckpointRecord(const out InterpActor.CheckpointRecord Record)
{
	Super.ApplyCheckpointRecord(Record);

	// apply bHidden to wheels
	if (WheelActor != None)
	{
		WheelActor.SetWheelsHidden(bHidden);
	}
}

event BodyTakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if(DamageType != class'HDDmgType_Rocket'
       && DamageType != class'HDDmgType_PF89'
       && DamageType != class'HDDmgType_PF98'
       && DamageType != class'HDDmgType_Track'
       && DamageType != class'HDDmgType_Satellite'
       && DamageType != class'HDDmgType_CSAirAttack'
       && DamageType != class'HDDmgType_HMG')
        return;
    if(bAutoDestroy)
    {
        if( DamageAmount != 0 )
        {
            Health -= DamageAmount;
            LastDamageTime = WorldInfo.TimeSeconds;
        }

        if(Health <= 0)
        {
           if(!bDestroyed)
           {
            Health = 0;
            bRecoverHealth = false;
            bDestroyed = true;
            bEngineRunning = false;
            WheelActor.Destoryed();
            TurretActor.KilledBy(EventInstigator.Pawn);
            ExplodeAudio.Play();
            TriggerEventClass(class'HDSeqEvent_PlatformDestroyed', self);
           }
        }

    }
    super.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

}

/** Handler for collision action, allow designer to toggle collide/block actors */
function OnChangeCollision(SeqAct_ChangeCollision Action)
{
	// if the action is out of date then use the previous properties
	if (Action.ObjInstanceVersion < Action.GetObjClassVersion())
	{
		SetCollision( Action.bCollideActors, Action.bBlockActors, Action.bIgnoreEncroachers );
		WheelActor.SetCollision(Action.bCollideActors, Action.bBlockActors, Action.bIgnoreEncroachers);
	}
	else
	{
		// otherwise use the new collision type
		SetCollisionType(Action.CollisionType);
		WheelActor.SetCollisionType(Action.CollisionType);
	}
	ForceNetRelevant();
	if (RemoteRole != ROLE_None)
	{
		// force replicate flags if necessary
		SetForcedInitialReplicatedProperty(Property'Engine.Actor.bCollideActors', (bCollideActors == default.bCollideActors));
		SetForcedInitialReplicatedProperty(Property'Engine.Actor.bBlockActors', (bBlockActors == default.bBlockActors));
		// don't bother with bIgnoreEncroachers as it isn't editable
	}
}

native function HDPlatform_DerrickWheels  GetWheelActor();

