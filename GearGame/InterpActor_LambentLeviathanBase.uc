/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class InterpActor_LambentLeviathanBase extends SkeletalMeshActorMAT
	abstract
	native
	config(Game);

var config int StartingOverallHealth;
var config int StartingLeftEyeHealth;
var config int StartingRightEyeHealth;

var transient int Health;
var transient int LeftEyeHealth;
var repnotify transient int RightEyeHealth;

var array<name> RightEyeBones;
var array<name> LeftEyeBones;

var repnotify bool bRightEyeBlownUp;
var repnotify bool bLeftEyeBlownUp;

var transient float RightEyeBlownUpTime;

var transient ParticleSystemComponent RightEyeBlownUpPSC;

var ParticleSystem RightEyeBlownUpParticleTemplate;
var name RightEyeBlownUpSocket;

var transient MaterialInstanceConstant EyeMIC;

/** Whether to ignore conventional health tracking - LDs may still use TakeDamage events in Kismet */
var() bool bInvulnerable;

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'bRightEyeBlownUp')
	{
		if(bRightEyeBlownUp)
		{
			PlayEyeBlownUp(false);
		}
	}
	else if(VarName == 'bLeftEyeBlownUp')
	{
		if(bLeftEyeBlownUp)
		{
			PlayEyeBlownUp(true);
		}
	}
	else if(VarName == 'RightEyeHealth')
	{
		UpdateEyeMICValue();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

replication
{
	if(bNetDirty && Role==ROLE_Authority)
		bRightEyeBlownUp,bLeftEyeBlownUp,RightEyeHealth;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Health = StartingOverallHealth;
	LeftEyeHealth = StartingLeftEyeHealth;
	RightEyeHealth = StartingRightEyeHealth;

	EyeMIC=SkeletalMeshComponent.CreateAndSetMaterialInstanceConstant(4);

	SkeletalMeshComponent.WakeRigidBody();

	SkeletalMeshComponent.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, SkeletalMeshComponent);
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	// Quickly ramp up the 'Explode' parameter when the eye is being blown up
	if( RightEyeBlownUpTime > 0.f )
	{
		EyeMIC.SetScalarParameterValue('Explode', FClamp(3.0f * `TimeSince(RightEyeBlownUpTime), 0.0f, 1.0f));
	}
}

simulated function UpdateEyeMICValue()
{
	local float Scalar;

	Scalar = 1-(float(RightEyeHealth)/float(StartingRightEyeHealth));
	//`log(Scalar);
	EyeMIC.SetScalarParameterValue('Damage',Scalar);
}

simulated function bool IsLeftEyeShot(TraceHitInfo HitInfo)
{
	return LeftEyeBones.Find(HitInfo.BoneName) != INDEX_NONE;
}

simulated function bool IsRightEyeShot(TraceHitInfo HitInfo)
{
	return RightEyeBones.Find(HitInfo.BoneName) != INDEX_NONE;
}

function OnManageLambentLeviathan( SeqAct_ManageLambentLeviathan inAction )
{
	if( inAction.InputLinks[0].bHasImpulse )
	{
		PlayEyeBlownUp( TRUE );
	}
	else if( inAction.InputLinks[1].bHasImpulse )
	{
		PlayEyeBlownUp( FALSE );
	}
}

simulated function PlayEyeBlownUp(bool bLeft)
{
	// right eye is the big one that we care about
	if(!bLeft)
	{
		bRightEyeBlownUp=true;
		PlayRightEyeBlowUpFx();
		TriggerEventClass( class'SeqEvent_LambentLeviathan_EyePop', self, 1 );	
	}
	else
	{
		PlayLeftEyeBlowUpFx();
		bLeftEyeBlownUp=true;
		TriggerEventClass( class'SeqEvent_LambentLeviathan_EyePop', self, 0 );	
	}
}

simulated function PlayRightEyeBlowUpFx()
{
	RightEyeBlownUpTime = WorldInfo.TimeSeconds;
	RightEyeBlownUpPSC = new class'ParticleSystemComponent';
	RightEyeBlownUpPSC.SetTemplate(RightEyeBlownUpParticleTemplate);
	SkeletalMeshComponent.Attachcomponenttosocket(RightEyeBlownUpPSC,RightEyeBlownUpSocket);
	RightEyeBlownUpPSC.ActivateSystem();
}

simulated function PlayLeftEyeBlowUpFx()
{
	
}

function TakeDamage
(
 int					Damage,
 Controller			InstigatedBy,
 Vector				HitLocation,
 Vector				Momentum,
class<DamageType>	DamageType,
	optional	TraceHitInfo		HitInfo,
	optional	Actor				DamageCauser
	)
{
	//local Pawn					InstigatedByPawn;
	local class<GearDamageType>	GearDamageType;

	//`log(GetFuncName()@Damage@InstigatedBy);
	// make sure we are the server and we're alive
	if (Role < ROLE_Authority || Health <= 0 )
	{
		return;
	}

	GearDamageType = class<GearDamageType>(DamageType);
	// if passed an invalid damagetype then use the default
	if( GearDamageType == None )
	{
		GearDamageType = class'GearDamageType';
	}


	
	// limit the size of the momentum
	if( VSize(Momentum) > 4.f )
	{
		Momentum = Normal(Momentum);
	}

	// MT-TODO: make sure difficulty settings etc are taken into account here
// 	if (Damage != 0)
// 	{
// 		// first allow the damage type a first-pass modifier
// 		GearDamageType.static.ModifyDamage(none, InstigatedBy, Damage, HitInfo, HitLocation, Momentum);
// 	}
// 
// 	// notify the game info of the damage, possibly scaling the values
// 	// - this handles stuff like god mode, friendly fire, etc
// 	WorldInfo.Game.ReduceDamage(Damage, none, InstigatedBy, HitLocation, Momentum, GearDamageType, DamageCauser);


	if( Damage != 0 )
	{
		//`log(HitInfo.BoneName);
		// call Actor's version to handle any SeqEvent_TakeDamage for scripting
		Super(Actor).TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, GearDamageType, HitInfo, DamageCauser );


		// apply the damage
		if(IsLeftEyeShot(HitInfo))
		{
			if(LeftEyeHealth > 0)
			{
				LeftEyeHealth -= Damage;
				if( LeftEyeHealth < 0 )
				{
					PlayEyeBlownUp(TRUE);
				}
			}
			//`log(self@"Took eye damage! (Left) Took:"@Damage@"Health:"@LeftEyeHealth);

		}
		else if(IsRightEyeShot(HitInfo))
		{

			if(RightEyeHealth > 0)
			{
				RightEyeHealth -= Damage;
				if( RightEyeHealth < 0 )
				{
					PlayEyeBlownUp(FALSE);
				}
				UpdateEyeMICValue();
			}
			//`log(self@"Took eye damage! (Right) Took:"@Damage@"Health:"@RightEyeHealth);

		}

		if( !bInvulnerable )
		{
			Health -= Damage;
			if( Health <= 0 )
			{
				TriggerEventClass( class'SeqEvent_Death', self );	
			}
		}
	}


	// make noise for AI purposes
	MakeNoise(1.f,'TakeDamage');
}

defaultproperties
{
	SupportedEvents.Add(class'SeqEvent_TakeDamage')
	SupportedEvents.Add(class'SeqEvent_Death')
	SupportedEvents.Add(class'SeqEvent_LambentLeviathan_EyePop')
}
