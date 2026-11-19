/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_NanoPowerBase extends NanoSkill
	abstract
	native(Pawn)
	config(Pawn);

/** Nano state this skill is associated with */
var const ENanoState NanoState;

/** how much it costs to change to dust/dense */
var const config float	NanoStateChangeCost;
/** how much it costs each second to maintain dust/dense */
var	const config float	NanoStateMaintainCost;

var const EGameButtons GameButton;


/** When you do a nano power your body has effects on it. **/
var array<name> SocketNamesToAttachNanoPowerBodyEffects;
var name SocketNameToAttachNanoPowerBodyEffectsHead;
var name SocketNameToAttachNanoPowerBodyEffectsBody;

var ParticleSystem NanoPowerParticleBodyEffectLimb;
var ParticleSystem NanoPowerParticleBodyEffectHead;
var ParticleSystem NanoPowerParticleBodyEffectBody;

var transient array<ParticleSystemComponent> NanoPowerParticleBodyEffects;

var const config float MaxActiveTime;
var const config float CooldownLockoutTime;

/** Each power needs to have one of these set in default properties which the artists may use to spawn extra effects **/
var NanoPowerSpawnedEffects NanoPowerArchetype;


/** Materials for the body effects **/
var transient MaterialInstanceConstant MIC_Body;
var transient MaterialInstanceConstant MIC_Head;
var transient MaterialInstanceConstant MIC_Scarf;
var transient MaterialInstanceConstant MIC_Weapon;
var transient MaterialInstanceConstant MIC_HandForge;

var MaterialInterface MI_Body;
var MaterialInterface MI_Head;
var MaterialInterface MI_Scarf;
var MaterialInterface MI_HandForge;

var transient float MICValueCurr;
var transient float MICValueGoal;


var SoundCue PowerActivateSound;
var transient AudioComponent AC_PowerActivateSound;

var SoundCue PowerDeactivateSound;



/** Attempt to activate this skill, returns TRUE is successful */
static function bool AttemptToActivate(NanoPawn Instigator)
{
	local NanoPC NPC;

	NPC = NanoPC(Instigator.Controller);

	// check for the cooldown timer
	if ( (NPC != None && !NPC.bCinematicMode) && (Instigator.WorldInfo.TimeSeconds < Instigator.NanoPowerCooldownExpiration) )
	{
		return FALSE;
	}
	if (Instigator.CurrNanoState == default.NanoState || Instigator.ConsumeNanoBucket(default.NanoStateChangeCost))
	{
		Instigator.ActivateSkill(default.class);
		return TRUE;
	}
	return FALSE;
}

simulated event Tick( float DeltaTime )
{
	local NanoPC PC;
	Super.Tick(DeltaTime);
	if( bActive )
	{
		if( !PawnOwner.ConsumeNanoBucket(NanoStateMaintainCost * DeltaTime) )
		{
			DeactivateSkill();
		}
		else if( (PawnOwner.WorldInfo.TimeSeconds > PawnOwner.NanoPowerExpiration) && PawnOwner.IsLocallyControlled() )
		{
			PC = NanoPC(PawnOwner.Controller);
			if( PC == None || (!PC.bCinematicMode && ShouldActivate() == FALSE ) )
			{
				//`log( "Deactivating" @ `showvar(PC) @ `showvar(ShouldActivate()) );
				DeactivateSkill();
			}
			else
			{
				// pulse the FX to indicate a new unit of consumption
				//NanoPowerParticleBodyEffects_Off();
				//PawnOwner.SetTimer(0.25f,FALSE,nameof(NanoPowerParticleBodyEffects_On),self);
				//PawnOwner.NanoPowerExpiration = PawnOwner.WorldInfo.TimeSeconds + MaxActiveTime;
			}
		}
	}
}


/** Asks the specific Power if it should be active.  Button pressing is not enough these days **/
simulated function bool ShouldActivate();


simulated protected function InternalActivated()
{
	//`log(`location);
	Super.InternalActivated();

	PowerActivated();

	PawnOwner.NanoPowerActivationTime = PawnOwner.WorldInfo.TimeSeconds;
	if( PawnOwner.NanoPowerExpiration == 0.f || PawnOwner.WorldInfo.TimeSeconds > PawnOwner.NanoPowerExpiration )
	{
		// if activating nano juice then set the expiration
		PawnOwner.NanoPowerExpiration = PawnOwner.WorldInfo.TimeSeconds + MaxActiveTime;
		PawnOwner.NanoPowerDuration = MaxActiveTime;
	}
	else
	{
		// otherwise clamp to the smallest remaining
		if( PawnOwner.WorldInfo.TimeSeconds + MaxActiveTime < PawnOwner.NanoPowerExpiration )
		{
			PawnOwner.NanoPowerExpiration = PawnOwner.WorldInfo.TimeSeconds + MaxActiveTime;
			PawnOwner.NanoPowerDuration = MaxActiveTime;
		}
	}
}

simulated protected function InternalDeactivated()
{
	//`log(`location);
	PawnOwner.NanoPowerExpiration = 0.f;
	if( PawnOwner.CurrNanoState == NanoState )
	{
		PawnOwner.SetNanoState(ENS_Normal,PawnOwner);
		if( PawnOwner.Physics == PHYS_Walking )
		{
			PawnOwner.NanoPowerCooldownExpiration = PawnOwner.WorldInfo.TimeSeconds + (CooldownLockoutTime * 0.5f);
		}
		else
		{
			PawnOwner.NanoPowerCooldownExpiration = PawnOwner.WorldInfo.TimeSeconds + CooldownLockoutTime;
		}
	}

	if( ShouldPlayClientEffects() )
	{
		NanoPowerParticleBodyEffects_Off( PawnOwner );

		if( PowerDeactivateSound != none )
		{
			PawnOwner.PlaySound( PowerDeactivateSound );
		}

		if( AC_PowerActivateSound != none )
		{
			AC_PowerActivateSound.FadeOut( 1.0f, 0.0f );
			AC_PowerActivateSound = none;
		}
	}

	Super.InternalDeactivated();
}

simulated protected function PowerActivated()
{
	PawnOwner.SetNanoState( NanoState, PawnOwner );

	if( ShouldPlayClientEffects() )
	{
		NanoPowerParticleBodyEffects_On( PawnOwner );
		SpawnEffectsFromArcheType( PawnOwner );

		if( PowerActivateSound != none )
		{
			if( AC_PowerActivateSound == None )
			{
				AC_PowerActivateSound = new(PawnOwner) class'AudioComponent';
				if( AC_PowerActivateSound != None )
				{
					AC_PowerActivateSound.SoundCue = PowerActivateSound;
					PawnOwner.AttachComponent( AC_PowerActivateSound );
					AC_PowerActivateSound.FadeIn( 0.200f, 1.0f );
				}
			}
		}
	}
}


/** This will activate and attach all of the body effects for this power **/
simulated function NanoPowerParticleBodyEffects_On( NanoPawn NP )
{
	local name SocketName;

	if(  NP.WorldInfo.MyEmitterPool != None )
	{
		foreach SocketNamesToAttachNanoPowerBodyEffects( SocketName )
		{
			NanoPowerParticleBodyEffects.AddItem( NP.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( NanoPowerParticleBodyEffectLimb, NP.Mesh, SocketName, TRUE ) );
		}

		// special case for head
		if( NanoPowerParticleBodyEffectHead != none )
		{
			NanoPowerParticleBodyEffects.AddItem( NP.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( NanoPowerParticleBodyEffectHead, NP.Mesh, SocketNameToAttachNanoPowerBodyEffectsHead, TRUE ) );
		}

		if( NanoPowerParticleBodyEffectBody != none )
		{
			NanoPowerParticleBodyEffects.AddItem( NP.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( NanoPowerParticleBodyEffectBody, NP.Mesh, SocketNameToAttachNanoPowerBodyEffectsBody, TRUE ) );
		}
	}
}


/** This will deactivate all the body effects for this power **/
simulated function NanoPowerParticleBodyEffects_Off( NanoPawn NP )
{
	local ParticleSystemComponent PSC_BodyEffect;

	foreach NanoPowerParticleBodyEffects( PSC_BodyEffect )
	{
		PSC_BodyEffect.DeactivateSystem();
	}
}


simulated function SpawnEffectsFromArcheType( NanoPawn NP )
{
	local WorldInfo WI;
	local SkeletalMeshSocket SkelMeshSocket;
	local ParticleSpawnDatum PSD;
	local ParticleSystemComponent PSC;

	if( NanoPowerArchetype.ParticleSpawnData.Length > 0 )
	{
		WI = class'WorldInfo'.static.GetWorldInfo();
		foreach NanoPowerArchetype.ParticleSpawnData( PSD )
		{
			// get a particle system comp
			//PSC = WI.MyEmitterPool.SpawnEmitterCustomLifetime( None );
			PSC = new(NP) class'NanoParticleSystemComponent'; // SpawnEmitterCustomLifetime assumes that you are using the PSC immediately and does crazy stuff.  So just make a new one for now
			PSC.bAutoActivate = FALSE;
			PSC.SetAbsolute( FALSE, FALSE );
			PSC.SetTickGroup( TG_PostUpdateWork );
			PSC.OnSystemFinished = WI.MyEmitterPool.OnParticleSystemFinished;
			PSC.SetTemplate( PSD.EffectToSpawn );

			// find out where to attach.  try sockets first then bone names
			SkelMeshSocket = NP.Mesh.GetSocketByName( PSD.SocketName );
			if( SkelMeshSocket != none )
			{
				NP.Mesh.AttachComponentToSocket( PSC, PSD.SocketName );
			}
			else
			{
				NP.Mesh.AttachComponent( PSC, PSD.SocketName );
			}

			//`log( "waiting" @ PSD.DelayBeforeSpawning @ " to fire" @ PSD.EffectToSpawn @ "on" @ PSD.SocketName );
			// set the time on the PSC to activate
			NP.SetTimer( FMax(PSD.DelayBeforeSpawning,0.001), FALSE, nameof(PSC.ActivateSystem), PSC );
		}
	}
}

simulated function SwitchToPowerActivatedMaterials( NanoPawn NP, optional float MaskGoal = 1.f )
{
	MIC_Body = new(self) class'MaterialInstanceConstant';
	MIC_Body.SetParent( MI_Body );
	NP.Mesh.SetMaterial( 0, MIC_Body );
	NP.Mesh.SetMaterial( 1, MIC_Body );

	MIC_Head = new(self) class'MaterialInstanceConstant';
	MIC_Head.SetParent( MI_Head );
	NP.HeadMesh.SetMaterial( 0, MIC_Head );
	NP.HeadMesh.SetMaterial( 1, MIC_Head );
	NP.HeadMesh.SetMaterial( 2, MIC_Head );
	NP.HeadMesh.SetMaterial( 3, MIC_Head );
	NP.HeadMesh.SetMaterial( 4, MIC_Head );

	MIC_Scarf = new(self) class'MaterialInstanceConstant';
	MIC_Scarf.SetParent( MI_Scarf );
	MIC_HandForge = new(self) class'MaterialInstanceConstant';
	MIC_HandForge.SetParent( MI_HandForge );

	NanoPawn_RebelsBase(NP).SetNanoPowerMaterials(MIC_Scarf, MIC_HandForge);
}

simulated function RestoreDefaultMaterials( NanoPawn NP )
{
	NP.Mesh.SetMaterial( 0, NP.BodyMIC );
	NP.Mesh.SetMaterial( 1, NP.ArmMIC );

	NP.HeadMesh.SetMaterial( 0, NP.HeadMIC );
	NP.HeadMesh.SetMaterial( 1, NP.Head1MIC );
	NP.HeadMesh.SetMaterial( 2, NP.Head2MIC );
	NP.HeadMesh.SetMaterial( 3, NP.Head3MIC );
	NP.HeadMesh.SetMaterial( 4, NP.Head4MIC );

	NanoPawn_RebelsBase(NP).RestoreDefaultNanoPowerMaterials();

	if( ( NanoWeapon(NP.Weapon) != none ) && ( NanoWeapon(NP.Weapon).Mesh != none ) )
	{
		NanoWeapon(NP.Weapon).Mesh.SetMaterial( 0, NanoWeapon(NP.Weapon).WeaponMIC );
	}
}



defaultproperties
{
	SocketNameToAttachNanoPowerBodyEffectsHead="EffectHead"
	SocketNameToAttachNanoPowerBodyEffectsBody="EffectBody"

	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectLeftArm")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectRightArm")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectUpperArmL")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectUpperArmR")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectLegL")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectLegR")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectLeftThigh")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectRightThigh")
}