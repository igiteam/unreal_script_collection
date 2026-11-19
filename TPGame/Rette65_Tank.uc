class Rette65_Tank extends TPBaseTank
				placeable;

var protected MaterialInstanceConstant InteriorLeftWheelMaterialInstance, InteriorRightWheelMaterialInstance;
var int LWheelSkinID, RWheelSkinID;
var name InteriorWheels;
var float LeftWheelSpeed, RightWheelSpeed;
var name GunBarrelTip2;

simulated function PostBeginPlay()
{
	local MaterialInterface WheelMaterial;

	Super.PostBeginPlay();

	if (Mesh != None)
	{
		// set up material instance (for overlay effects)
		WheelMaterial = Mesh.GetMaterial(LWheelSkinID);
		if ( WheelMaterial != None )
		{
			InteriorLeftWheelMaterialInstance = new(Outer) class'MaterialInstanceConstant';
			Mesh.SetMaterial(LWheelSkinID, InteriorLeftWheelMaterialInstance);
			InteriorLeftWheelMaterialInstance.SetParent(WheelMaterial);
		}
		WheelMaterial = Mesh.GetMaterial(RWheelSkinID);
		if ( WheelMaterial != None )
		{
			InteriorRightWheelMaterialInstance = new(Outer) class'MaterialInstanceConstant';
			Mesh.SetMaterial(RWheelSkinID, InteriorRightWheelMaterialInstance);
			InteriorRightWheelMaterialInstance.SetParent(WheelMaterial);
		}
	}
}

function OnTankFire(SeqAct_TankFire Action)
{
	local vector HitLocation, HitNormal, Start, StartB, End;
	local rotator TurretTipRotation, TurretTipRotationB;
	local Actor HitActor;
	local SplashZone SZ;
	local EmitterSpawnable emitter;
	local SkeletalMeshSocket theSocket, theSocketB;
	local TraceHitInfo HitInfo;
	//local DecalActor Decal;

	theSocket = Mesh.GetSocketByName( GunBarrelTip );
	theSocketB = Mesh.GetSocketByName( GunBarrelTip2 );
	if( theSocket != None && theSocketB != none && GunFireEffect != none)
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

		emitter = spawn( class'EmitterSpawnable');
		emitter.SetTemplate(GunFireEffect, true);

		emitter.SetHardAttach(true);
		emitter.bCollideWorld = false;
		emitter.SetCollision(false, false);
		emitter.SetBase(self,, Mesh, theSocketB.BoneName);

		emitter.SetRelativeLocation( theSocketB.RelativeLocation );
		emitter.SetRelativeRotation( theSocketB.RelativeRotation );

		emitter.bDestroyOnSystemFinish = true;
		emitter.ParticleSystemComponent.ActivateSystem();

		Spawn(class'FadeOutLight',,,emitter.Location);

		ApplyFireImpulse();

		FireEffectAudioCmpt.Play();

		if (Mesh != none && TurretControl != none)
		{
			Mesh.GetSocketWorldLocationAndRotation(GunBarrelTip, Start, TurretTipRotation);
			Mesh.GetSocketWorldLocationAndRotation(GunBarrelTip2, StartB, TurretTipRotationB);
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

			StartB = StartB;
			End = StartB + (vect(0,0,65536) >> TurretTipRotation);
			HitActor = Trace(HitLocation, HitNormal, End, StartB, true,,HitInfo);
			if (HitActor != none)
			{
				SZ = Spawn(SplashZoneEffectClass,,,HitLocation, rotator(HitNormal));
				SZ.ImpactNearbyObjects();
			}

		}

	}
}

simulated function Tick(float dt)
{
	local float Left, Right;
	super.Tick(dt);
	Left = SVehicleSimTank(SimObj).LeftTrackVel * Wheels[0].WheelRadius;
	LeftWheelSpeed += dt * (Left * 0.0085);
	InteriorLeftWheelMaterialInstance.SetScalarParameterValue(InteriorWheels,LeftWheelSpeed);

	Right = SVehicleSimTank(SimObj).RightTrackVel * Wheels[0].WheelRadius;
	RightWheelSpeed += dt * (Right * 0.0085);
	InteriorRightWheelMaterialInstance.SetScalarParameterValue(InteriorWheels,RightWheelSpeed);
}

