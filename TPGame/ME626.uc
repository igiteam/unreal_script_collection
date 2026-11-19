class ME626 extends TPBaseVehicle
    placeable;

var() ParticleSystem TurbineSmoke;
var() ParticleSystem TurbineDamaged;
var() ParticleSystem MuzzleFlashTemplate;
var() SoundCue RocketFireSound;

var name RocketNames[2];
var name GunNames[2];
var name TurbineNames[2];
var name RocketLocationNames[2];

var ParticleSystemComponent TurbineParticleSystemComponent[2];
var ParticleSystemComponent MuzzleFlashComponents[2];

var StaticMeshComponent LeftRocket, RightRocket;

var SkelControlSingleBone LFlapControl, RFlapControl, LTailFlapControl, RTailFlapControl, RudderControl;
var class<TPProjectile> GunProjectileClass;
var class<TPProjectile> RocketProjectileClass;
var SeqAct_AirplaneFire FireAction;
var bool IsFiring;

var AudioComponent GunFireSoundComponent;

simulated function PostBeginPlay()
{
	local EmitterSpawnable E;
	super.PostBeginPlay();

	// Spawn the Engine Effects
	E = spawn(class'EmitterSpawnable');
	E.SetTemplate(TurbineSmoke, false);
	E.ParticleSystemComponent.ActivateSystem();
	TurbineParticleSystemComponent[0] = E.ParticleSystemComponent;
    Mesh.AttachComponentToSocket(E.ParticleSystemComponent, TurbineNames[0]);

	E = spawn(class'EmitterSpawnable');
	E.SetTemplate(TurbineSmoke, false);
	E.ParticleSystemComponent.ActivateSystem();
	TurbineParticleSystemComponent[1] = E.ParticleSystemComponent;
	Mesh.AttachComponentToSocket(E.ParticleSystemComponent, TurbineNames[1]);

	// Initialize the flap and rudder controls and setup the bone controls
	Mesh.InitSkelControls();
	LFlapControl = SkelControlSingleBone(Mesh.FindSkelControl('Left_Front_Flap'));
	RFlapControl = SkelControlSingleBone(Mesh.FindSkelControl('Right_Front_Flap'));
	LTailFlapControl = SkelControlSingleBone(Mesh.FindSkelControl('Left_Rear_Flap'));
	RTailFlapControl = SkelControlSingleBone(Mesh.FindSkelControl('Right_Rear_Flap'));
	RudderControl = SkelControlSingleBone(Mesh.FindSkelControl('RudderControl'));

	// Spawn the MachineGun MuzzleFlash Components :)
	E = spawn(class'EmitterSpawnable');
    E.SetTemplate(MuzzleFlashTemplate, false);
	MuzzleFlashComponents[0] = E.ParticleSystemComponent;
	Mesh.AttachComponentToSocket(E.ParticleSystemComponent, GunNames[0]);

	E = spawn(class'EmitterSpawnable');
	E.SetTemplate(MuzzleFlashTemplate, false);
	MuzzleFlashComponents[1] = E.ParticleSystemComponent;
	Mesh.AttachComponentToSocket(E.ParticleSystemComponent, GunNames[1]);

	// Attach the rockets
	Mesh.AttachComponentToSocket(LeftRocket,RocketLocationNames[0]);
	Mesh.AttachComponentToSocket(RightRocket,RocketLocationNames[1]);
}

simulated function Tick(float dt)
{
	local vector X, Y, Z;
    local float TurnAmount;

	super.Tick(dt);

	GetAxes(Rotation, X, Y, Z);
	TurnAmount = Y dot vect(0,0,1);

	LFlapControl.BoneRotation.Yaw = TurnAmount * 16384;
	RFlapControl.BoneRotation.Yaw = -TurnAmount * 16384;
	LTailFlapControl.BoneRotation.Yaw = TurnAmount * 8196;
	RTailFlapControl.BoneRotation.Yaw = -TurnAmount * 8196;

	if (IsFiring)
	{
		FireAction.RefireTime += dt;
		if (FireAction.RefireTime > FireAction.RefireRate)
		{
			FireGuns();
			FireAction.RefireTime = 0.0;
		}
	}
}

function FireGuns()
{
	local TPProjectile Bullet;
	local vector GunLocL, GunLocR;
	local rotator GunRot;
	local float SpeedMod;

	if (Base != none)
	{
		if (SplineMover(Base) != none)
			SpeedMod = SplineMover(Base).Speed;
	}

	Mesh.GetSocketWorldLocationAndRotation(GunNames[0], GunLocL, GunRot);
	Mesh.GetSocketWorldLocationAndRotation(GunNames[1], GunLocR, GunRot);

	// Make the Muzzle Flash go off
	MuzzleFlashComponents[0].ActivateSystem();
	MuzzleFlashComponents[1].ActivateSystem();

	Bullet = Spawn(GunProjectileClass,self,,GunLocL);
	Bullet.SpawnTracer();
	Bullet.Speed += SpeedMod;
	Bullet.MaxSpeed += SpeedMod;
	Bullet.Init(vector(Rotation));

	Bullet = Spawn(GunProjectileClass,self,,GunLocR);
	Bullet.SpawnTracer();
	Bullet.Speed += SpeedMod;
	Bullet.MaxSpeed += SpeedMod;
	Bullet.Init(vector(Rotation));

	//PlaySound(GunFireSound,,,,Location);

}

function ReArmRightRocket()
{
	RightRocket.SetHidden(false);
}
function ReArmLeftRocket()
{
	LeftRocket.SetHidden(false);
}

function FireRocket(int Side)
{
	local TPProjectile Rocket;
	local vector RocketLocL, RocketLocR;
	local rotator RocketRot;
	local float SpeedMod;

	Mesh.GetSocketWorldLocationAndRotation(RocketLocationNames[0], RocketLocL, RocketRot);
	Mesh.GetSocketWorldLocationAndRotation(RocketLocationNames[1], RocketLocR, RocketRot);

	if (Base != none)
	{
		if (SplineMover(Base) != none)
			SpeedMod = SplineMover(Base).Speed;
	}

	switch(Side)
	{
		// Left Rocket
	case 0:
		if (!LeftRocket.HiddenGame)
		{
			LeftRocket.SetHidden(true);
			Rocket = Spawn(RocketProjectileClass,self,,RocketLocL, RocketRot);
			Rocket.Speed += SpeedMod;
			Rocket.MaxSpeed += SpeedMod;
			Rocket.Init(vector(Rotation));
			PlaySound(RocketFireSound,,,,RocketLocL);
			SetTimer(5.0, false, 'ReArmLeftRocket');
		}
		break;
		// Right Rocket
	case 1:
		if (!RightRocket.HiddenGame)
		{
			RightRocket.SetHidden(true);
			Rocket = Spawn(RocketProjectileClass,self,,RocketLocR, RocketRot);
			Rocket.Speed += SpeedMod;
			Rocket.MaxSpeed += SpeedMod;
			Rocket.Init(vector(Rotation));
			PlaySound(RocketFireSound,,,,RocketLocR);
			SetTimer(5.0, false, 'ReArmRightRocket');
		}
		break;
	}
}

function OnAirplaneFire(SeqAct_AirplaneFire Action)
{
	FireAction = Action;
	FireAction.RefireTime = 0.0;

	if (Action.FireLeftRocket)
	{
		FireRocket(0);
	}
	if (Action.FireRightRocket)
	{
		FireRocket(1);
	}
	if (Action.FireGuns)
	{
		SetTimer(Action.GunFireTimer, false, 'FinishFiring');
		GunFireSoundComponent.Play();
		IsFiring=true;
	}
}

function FinishFiring()
{
	IsFiring = false;
	GunFireSoundComponent.Stop();
}

event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	if (Health <= 0)
	{
		GoDownInFlames();
	}
}

function GoDownInFlames()
{
	local int RandomEngine;
	RandomEngine = Rand(2);
	TurbineParticleSystemComponent[RandomEngine].SetTemplate(TurbineDamaged);
	SetBase(None);
	SetPhysics(PHYS_RigidBody);
	if (Base != none)
	{
		Mesh.AddImpulse(Base.Acceleration cross vect(0,0,1), Location);
	}
}
