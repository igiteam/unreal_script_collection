class Zeppelin_Persistent extends SkeletalMeshActor
		notplaceable;

var Actor AimTarget;

var float RefireTimer;
var float RefireRate;

var float OverheatTimer;
var float OverheatRate;

var float CooldownTimer;
var float CooldownRate;

var SeqAct_ZeppelinFire FireAction;
var SeqAct_ZeppelinBomb BombAction;

var array<name> GunnerBones;
var array<name> BombBones;

var	ParticleSystem MuzzleFlashTemplate;
var SoundCue GunFireSound;

var ParticleSystem               TurbineExhTemplate;
var EmitterSpawnable             TurbineExh_01,TurbineExh_02,TurbineExh_03,TurbineExh_04,TurbineExh_05,TurbineExh_06;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	
	if (TurbineExhTemplate != None)
	{
		TurbineExh_01 = spawn(class'EmitterSpawnable');
		TurbineExh_01.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_01.bDestroyOnSystemFinish = false;
		SkeletalMeshComponent.AttachComponentToSocket(TurbineExh_01.ParticleSystemComponent,'prop01');
		TurbineExh_01.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_01.ParticleSystemComponent.ActivateSystem();

		TurbineExh_02 = spawn(class'EmitterSpawnable');
		TurbineExh_02.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_02.bDestroyOnSystemFinish = false;
		SkeletalMeshComponent.AttachComponentToSocket(TurbineExh_02.ParticleSystemComponent,'prop02');
		TurbineExh_02.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_02.ParticleSystemComponent.ActivateSystem();

		TurbineExh_03 = spawn(class'EmitterSpawnable');
		TurbineExh_03.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_03.bDestroyOnSystemFinish = false;
		SkeletalMeshComponent.AttachComponentToSocket(TurbineExh_03.ParticleSystemComponent,'prop03');
		TurbineExh_03.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_03.ParticleSystemComponent.ActivateSystem();

		TurbineExh_04 = spawn(class'EmitterSpawnable');
		TurbineExh_04.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_04.bDestroyOnSystemFinish = false;
		SkeletalMeshComponent.AttachComponentToSocket(TurbineExh_04.ParticleSystemComponent,'prop04');
		TurbineExh_04.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_04.ParticleSystemComponent.ActivateSystem();

		TurbineExh_05 = spawn(class'EmitterSpawnable');
		TurbineExh_05.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_05.bDestroyOnSystemFinish = false;
		SkeletalMeshComponent.AttachComponentToSocket(TurbineExh_05.ParticleSystemComponent,'prop05');
		TurbineExh_05.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_05.ParticleSystemComponent.ActivateSystem();

		TurbineExh_06 = spawn(class'EmitterSpawnable');
		TurbineExh_06.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_06.bDestroyOnSystemFinish = false;
		SkeletalMeshComponent.AttachComponentToSocket(TurbineExh_06.ParticleSystemComponent,'prop06');
		TurbineExh_06.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_06.ParticleSystemComponent.ActivateSystem();
	}
}
function OnPlaySceneAnimation(SeqAct_PlaySceneAnimation action)
{
	SkeletalMeshComponent.PlayAnim(action.m_animSeqName);
}

function OnZeppelinFire(SeqAct_ZeppelinFire Act)
{
	FireAction = Act;
	if (Act.InputLinks[0].bHasImpulse)
	{
		if (Act.AimTarget != none)
		{
			if (Act.AimTarget.IsA('Controller'))
				Act.AimTarget = Controller(Act.AimTarget).Pawn;

			AimTarget = Act.AimTarget;

			RefireTimer = 0.0;
			RefireRate = Act.RefireRate;
			OverheatTimer = 0.0;
			OverheatRate = RandRange(Act.OverheatTimeMin, Act.OverheatTimeMax);
			CooldownTimer = 0.0;
			CooldownRate = RandRange(Act.CooldownTimeMin, Act.CooldownTimeMax);

			GotoState('GunnerFiring');
		}
	}
	else if (Act.InputLinks[1].bHasImpulse)
	{
		GotoState('');
	}
}

state GunnerCooldown
{
	function BeginState(name PrevStateName)
	{
		CooldownTimer = 0.0;
		CooldownRate = RandRange(FireAction.CooldownTimeMin, FireAction.CooldownTimeMax);
	}
	function EndState(name NextStateName)
	{
		OverheatTimer = 0.0;
		OverheatRate = RandRange(FireAction.OverheatTimeMin, FireAction.OverheatTimeMax);
	}

	simulated function Tick(float dt)
	{
		CooldownTimer += dt;
		if (CooldownTimer > CooldownRate)
		{
			CooldownTimer = 0.0;
			GotoState('GunnerFiring');
		}
	}
}

state GunnerFiring
{
	function CreateTracer()
	{
		local Proj_ZeppelinBullet ZepBullet;
		local EmitterSpawnable E;
		local vector AimNormal, AimLoc;
		local vector GunnerPosition;

		AimLoc = AimTarget.Location + (VRand() * FireAction.AimAccuracyOffset);
		GunnerPosition = SkeletalMeshComponent.GetBoneLocation(GunnerBones[0]);
		AimNormal = Normal(AimLoc - GunnerPosition);

		ZepBullet = Spawn(class'Proj_ZeppelinBullet',,,GunnerPosition);
		ZepBullet.MyDamageType = FireAction.DamageType;
		ZepBullet.Damage = FireAction.BulletDamage;
		ZepBullet.MomentumTransfer = FireAction.MomentumTransfer;
		ZepBullet.SetDrawScale3D(FireAction.TracerDrawScale);
		ZepBullet.Speed = FireAction.TracerSpeed;
		ZepBullet.MaxSpeed = FireAction.TracerSpeed;
		ZepBullet.Init(AimNormal);
		E = Spawn(class'EmitterSpawnable',,,GunnerPosition,rotator(AimNormal) + rot(-16384,0,0));
		E.SetTemplate( MuzzleFlashTemplate, true);
		E.ParticleSystemComponent.ActivateSystem();

	}
	// GunnerID is used for later if we have multiple gunners
	function bool CanGunnerFire(optional int GunnerID)
	{
		if (OverheatTimer > OverheatRate)
			return false;
		return true;
	}

	simulated function Tick(float dt)
	{
		RefireTimer += dt;
		OverheatTimer += dt;

		if (RefireTimer > RefireRate)
		{
			PlaySound(GunFireSound,,,,Location);
			CreateTracer();
			RefireTimer = 0;
		}
		if (!CanGunnerFire())
			GotoState('GunnerCooldown');
	}
}

// Sequence Action Functions
function OnZeppelinBomb(SeqAct_ZeppelinBomb Act)
{
	local float Interval;
	BombAction = Act;
	Interval = RandRange(Act.MinInterval, Act.MaxInterval);
	if (Act.InputLinks[0].bHasImpulse)
        SetTimer(Interval, false, 'DropBomb');
	else if (Act.InputLinks[1].bHasImpulse)
		ClearTimer('DropBomb');
}

// Bombing Function
function DropBomb()
{
	local int Index;
	local float Interval;

	Index = Rand(BombBones.Length);
	Spawn(class'ZeppelinGrenade',,,SkeletalMeshComponent.GetBoneLocation(BombBones[Index]));

	Interval = RandRange(BombAction.MinInterval, BombAction.MaxInterval);
	SetTimer(Interval, false, 'DropBomb');
}

