class TPBaseTank extends TPBaseVehicle
								abstract
								native;

enum TurretFocusType
{
	TFT_Turret,			// Focus with Turret Only
	TFT_Gun,			// Focus with Gun Only
	TFT_Both,			// Focus with Both
};

// Kismet Variables
var Actor TurretFocus;									// What actor does the TurretFocus, used in ScriptedTurretTurn
var TurretFocusType FocusType;							// What type of focus the Turret does.

// Turret and Gun Variables
var() float TurretMovementSpeed;						// Speed of the Turret when it moves
var() float GunMovementSpeed;							// Speed of the Gun when it moves
var() float MaxTurretYaw;								// Maximum pitch allowed for the Turret, default is 65536 (360 degress)
var() float MaxGunPitch;								// Maximum pitch allowed for the Gun
var name TurretBoneCtrl;								// SkelControl for the Turret
var name GunShieldBoneCtrl;								// SkelControl for the Gun
var() SoundCue TurretMovementSound;						// Sound the Turret makes when moved
var() SoundCue GunMovementSound;						// Sound the Gun makes when moved
var() SoundCue TrackMovementSound;						// Sound the Tracks make when it is moving.
var name GunBarrelBase;									// Name of the bone for the base of the gun, used for when gun is focusing.
var name GunBarrelTip;									// Name of the bone to attach the fire effect

// Tread Variables
var name TreadSpeedParameterName;						// Material parameter controlling tread panner speed

// Effect Variables
var() ParticleSystem GunFireEffect;						// Fire Effect for when the tank Fires
var() SoundCue FireEffectSound;							// Sound for the Firing of the Gun

// Cannon Fire Result Effects and Sounds
var() class<SplashZone> SplashZoneEffectClass;

// Internals
var protected MaterialInstanceConstant LeftTreadMaterialInstance, RightTreadMaterialInstance;
var int LeftTreadSkinID, RightTreadSkinID;
var float LeftTreadSpeed, RightTreadSpeed;
var SkelControlSingleBone TurretControl, GunControl;
var bool bResetTurret;
var AudioComponent TurretTwistAudioCmpt, GunPitchAudioCmpt, FireEffectAudioCmpt, TrackMovementAudioCmpt;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated function PostBeginPlay()
{
	local MaterialInterface TreadMaterial;

	Super.PostBeginPlay();

	if (Mesh != None)
	{
		// set up material instance (for overlay effects)
		TreadMaterial = Mesh.GetMaterial(LeftTreadSkinID);
		if ( TreadMaterial != None )
		{
			LeftTreadMaterialInstance = new(Outer) class'MaterialInstanceConstant';
			Mesh.SetMaterial(LeftTreadSkinID, LeftTreadMaterialInstance);
			LeftTreadMaterialInstance.SetParent(TreadMaterial);
		}
		TreadMaterial = Mesh.GetMaterial(RightTreadSkinID);
		if ( TreadMaterial != None )
		{
			RightTreadMaterialInstance = new(Outer) class'MaterialInstanceConstant';
			Mesh.SetMaterial(RightTreadSkinID, RightTreadMaterialInstance);
			RightTreadMaterialInstance.SetParent(TreadMaterial);
		}

		TurretControl = SkelControlSingleBone(Mesh.FindSkelControl(TurretBoneCtrl) );
		GunControl    = SkelControlSingleBone(Mesh.FindSkelControl(GunShieldBoneCtrl) );
	}

	if (TurretMovementSound != none)
	{
		TurretTwistAudioCmpt.SoundCue = TurretMovementSound;
		AttachComponent(TurretTwistAudioCmpt);
	}
	if (GunMovementSound != none)
	{
		GunPitchAudioCmpt.SoundCue = GunMovementSound;
		AttachComponent(GunPitchAudioCmpt);
	}
	if (FireEffectSound != none)
	{
		FireEffectAudioCmpt.SoundCue = FireEffectSound;
		AttachComponent(FireEffectAudioCmpt);
	}
	if (TrackMovementSound != none)
	{
		TrackMovementAudioCmpt.SoundCue = TrackMovementSound;
		AttachComponent(TrackMovementAudioCmpt);
	}
}

simulated event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

function OnVehicleSpeedModifier(SeqAct_VehicleSpeedModifier action)
{
	// Error check the speed modifier
	if (action.Speed <= 0)
	{
		;
		return;
	}
	SVehicleSimTank(SimObj).MaxEngineTorque *= action.Speed;
}

function OnTankTurretLookAt(SeqAct_TankTurretLookAt Action)
{
	TurretFocus = Action.Destination;
	FocusType = Action.FocusType;
	
	bResetTurret = Action.bResetTurret;

	ClearLatentAction(class'SeqAct_TankTurretLookAt', false);

	switch(FocusType)
	{
		case TFT_Turret:
			TurretTwistAudioCmpt.Play();
		break;
		case TFT_Gun:
			GunPitchAudioCmpt.Play();
		break;
		case TFT_Both:
			TurretTwistAudioCmpt.Play();
			GunPitchAudioCmpt.Play();
		break;
	}
	PushState('ScriptedTurretTurn');
}

function OnTankFire(SeqAct_TankFire Action)
{
	local vector HitLocation, HitNormal, Start, End;
	local rotator TurretTipRotation;
	local Actor HitActor;
	local SplashZone SZ;
	local EmitterSpawnable emitter;
	local SkeletalMeshSocket theSocket;
	local TraceHitInfo HitInfo;
	//local DecalActor Decal;
	
	theSocket = Mesh.GetSocketByName( GunBarrelTip );
	if( theSocket != None && GunFireEffect != none)
	{
		FireEffectAudioCmpt.Stop();

		emitter = spawn( class'EmitterSpawnable');
		emitter.SetTemplate(GunFireEffect, true);

		emitter.SetHardAttach(true); 
		emitter.bCollideWorld = false;
		emitter.SetCollision(false, false);
		emitter.SetBase(self,, Mesh, theSocket.BoneName);
				
		emitter.SetRelativeLocation( theSocket.RelativeLocation );
		emitter.SetRelativeRotation( theSocket.RelativeRotation );

		emitter.bDestroyOnSystemFinish = true;
		emitter.ParticleSystemComponent.ActivateSystem();

		Spawn(class'FadeOutLight',,,emitter.Location);

		ApplyFireImpulse();
		
		FireEffectAudioCmpt.Play();

		if (Mesh != none && TurretControl != none)
		{
			Mesh.GetSocketWorldLocationAndRotation(GunBarrelTip, Start, TurretTipRotation);
		}

		if (!Action.bShootBlanks)
		{
			Start = Start;
			End = Start + (vect(0,0,65536) >> TurretTipRotation);
			HitActor = Trace(HitLocation, HitNormal, End, Start, true,,HitInfo);
			if (HitActor != none)
			{
				SZ = Spawn(SplashZoneEffectClass,,,HitLocation, rotator(HitNormal));
				SZ.ImpactNearbyObjects();
			}
		}
	}
}

function ApplyFireImpulse()
{
	local SkeletalMeshSocket theSocket;
	local vector TipLocation, FireForce;
	FireForce.X = -2;

	theSocket = Mesh.GetSocketByName( GunBarrelTip );
	if (theSocket != none && TurretControl != none)
	{
		Mesh.GetSocketWorldLocationAndRotation(GunBarrelTip, TipLocation);
		FireForce = FireForce >> (TurretControl.BoneRotation+Rotation);
		Mesh.AddImpulse(FireForce, TipLocation,GunBarrelBase,true);
	}
}

state ScriptedTurretTurn
{
	function PushedState()
	{
		;		
	}
	function Tick(float dt)
	{
		local float WhichWay;
		local vector X, Y, Z;
		local vector LookAtTarget;
		local int OldYaw, OldPitch;

		if (TurretControl != none && GunControl != none && TurretFocus != none)
		{
			OldPitch = GunControl.BoneRotation.Pitch;
			OldYaw = TurretControl.BoneRotation.Yaw;
					
			switch(FocusType)
			{
				case TFT_Turret:
					if (!bResetTurret)
						LookAtTarget = Normal(TurretFocus.Location - Location);
					else
						LookAtTarget = Normal((Location+(vect(100,0,0)>>Rotation)) - Location);
					LookAtTarget.Z = 0.0;
				
					GetAxes(TurretControl.BoneRotation+Rotation, X, Y, Z);
					WhichWay = Y dot LookAtTarget;
					TurretControl.BoneRotation.Yaw += (TurretMovementSpeed * WhichWay) * dt;
					TurretControl.BoneRotation.Yaw = Clamp(TurretControl.BoneRotation.Yaw, -MaxTurretYaw, MaxTurretYaw);
					if (Abs(OldYaw-TurretControl.BoneRotation.Yaw) <= 1)
						PopState();
				break;
				case TFT_Gun:
					LookAtTarget = Mesh.GetBoneLocation(GunBarrelBase);
					if (!bResetTurret)
						LookAtTarget = Normal(TurretFocus.Location - LookAtTarget);
					else
						LookAtTarget = Normal((Location+(vect(100,0,0)>>Rotation)) - Location);
					LookAtTarget.Y = 0.0;
					GetAxes(GunControl.BoneRotation+Rotation, X, Y, Z);
					WhichWay = Z dot LookAtTarget;
					GunControl.BoneRotation.Pitch += (GunMovementSpeed * WhichWay) * dt;
					GunControl.BoneRotation.Pitch = Clamp(GunControl.BoneRotation.Pitch, -MaxGunPitch, MaxGunPitch);
					if (Abs(OldPitch-GunControl.BoneRotation.Pitch) <= 1)
						PopState();
				break;
				case TFT_Both:

					// Yaw Turret
					if (!bResetTurret)
						LookAtTarget = Normal(TurretFocus.Location - Location);
					else
						LookAtTarget = Normal((Location+(vect(100,0,0)>>Rotation)) - Location);
					LookAtTarget.Z = 0.0;
					GetAxes(TurretControl.BoneRotation+Rotation, X, Y, Z);
					WhichWay = Y dot LookAtTarget;
					TurretControl.BoneRotation.Yaw += (TurretMovementSpeed * WhichWay) * dt;
					TurretControl.BoneRotation.Yaw = Clamp(TurretControl.BoneRotation.Yaw, -MaxTurretYaw, MaxTurretYaw);
					
					// Pitch Gun
					LookAtTarget = Mesh.GetBoneLocation(GunBarrelBase);
					if (!bResetTurret)
						LookAtTarget = Normal(TurretFocus.Location - LookAtTarget);
					else
						LookAtTarget = Normal((Location+(vect(100,0,0)>>Rotation)) - Location);
					
					LookAtTarget.Y = 0.0;
					GetAxes(GunControl.BoneRotation+Rotation, X, Y, Z);
					WhichWay = Z dot LookAtTarget;
					GunControl.BoneRotation.Pitch += (GunMovementSpeed * WhichWay) * dt;
					GunControl.BoneRotation.Pitch = Clamp(GunControl.BoneRotation.Pitch, -MaxGunPitch, MaxGunPitch);

					if (Abs(OldYaw-TurretControl.BoneRotation.Yaw) <= 1 && Abs(OldPitch-GunControl.BoneRotation.Pitch) <= 1)
						PopState();
				break;
			}
		}
	}
	function PoppedState()
	{
		;
		ClearLatentAction(class'SeqAct_TankTurretLookAt', false);
		
		TurretTwistAudioCmpt.Stop();
		GunPitchAudioCmpt.Stop();
	}
}

