class PhantomGunner extends Actor
							placeable
							native;

enum PG_GUNNER_STATE   {PGGS_IDLE, PGGS_FIRING, PGGS_COOLING};

var Actor AimTarget;

var float RefireTimer;
var float RefireRate;

var float OverheatTimer;
var float OverheatRate;

var float CooldownTimer;
var float CooldownRate;
var bool  bGunnerActive;

var PG_GUNNER_STATE m_GunnerState;

var SeqAct_PhantomGunner FireAction;
var() ParticleSystem MuzzleFlashTemplate;
var() SoundCue GunFireSound;

var EmitterSpawnable MuzzleFlashEmitter;

var class<TPProjectile> ProjectileClass;

var AudioComponent FireAudioCmpt;

simulated function PostBeginPlay()
{
    MuzzleFlashEmitter = Spawn(class'EmitterSpawnable');
	MuzzleFlashEmitter.ParticleSystemComponent.bAutoActivate = false;
	MuzzleFlashEmitter.SetTemplate( MuzzleFlashTemplate, false);

	if (GunFireSound != none)
	{
		FireAudioCmpt.SoundCue = GunFireSound;
		AttachComponent(FireAudioCmpt);
	}
	AttachComponent(MuzzleFlashEmitter.ParticleSystemComponent);
}

native final function TP_GotoState( name NewState, optional name Label, optional bool bForceEvents, optional bool bKeepStack );

function OnPhantomGunner(SeqAct_PhantomGunner Act)
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

			//MuzzleFlashEmitter.SetRelativeRotation(rotator(AimTarget.Location - Location));
			SetRotation(rotator(AimTarget.Location - Location) + rot(-16384, 0, 0));
            bGunnerActive = true;
			GotoState('GunnerFiring');
		}
	}
	else if (Act.InputLinks[1].bHasImpulse)
	{
        bGunnerActive = false;
		GotoState('Idle');
	}
}

auto state Idle
{
	function BeginState(name PrevStateName)
	{
		m_GunnerState = PGGS_IDLE;
	}

	function PushedState()
	{
		m_GunnerState = PGGS_IDLE;
	}
}

state GunnerCooldown
{
	function BeginState(name PrevStateName)
	{
		m_GunnerState = PGGS_COOLING;
		FireAudioCmpt.FadeOut(1.0, 0.0);
		CooldownTimer = 0.0;
		CooldownRate = RandRange(FireAction.CooldownTimeMin, FireAction.CooldownTimeMax);
	}
	function EndState(name NextStateName)
	{
		OverheatTimer = 0.0;
		OverheatRate = RandRange(FireAction.OverheatTimeMin, FireAction.OverheatTimeMax);
	}
	function PushedState()
	{
		m_GunnerState = PGGS_COOLING;
	}

	function Tick(float dt)
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
	function BeginState(Name PreviousStateName)
	{
		m_GunnerState = PGGS_FIRING;
		FireAudioCmpt.Play();
	}

	function EndState(Name NextStateName)
	{
	    FireAudioCmpt.Stop();
	}

	function PushedState()
	{
		m_GunnerState = PGGS_FIRING;
	}

	function CreateTracer()
	{
		local TPProjectile Bullet;
		local vector AimNormal, AimLoc;

		AimLoc = AimTarget.Location + (VRand() * FireAction.AimAccuracyOffset);

		// Target near player's chest
        AimLoc.Z = (AimLoc.Z + 36.0);
		AimNormal = Normal(AimLoc - Location);

		// Uses the Zeppelin Bullet for now cause it looks like a tracer
		Bullet = Spawn(ProjectileClass,self,,Location);

		//Don't spam the log if the spawn fails.
		if ( Bullet != None )
		{
			Bullet.Speed = 0;
			Bullet.MyDamageType = FireAction.DamageType;
			Bullet.Damage = FireAction.BulletDamage;
			Bullet.MomentumTransfer = FireAction.MomentumTransfer;
			Bullet.SetDrawScale3D(FireAction.TracerDrawScale);
			Bullet.Speed = FireAction.TracerSpeed;
			Bullet.MaxSpeed = FireAction.TracerSpeed;
			Bullet.SpawnTracer();
			Bullet.TPInit(AimNormal, false, false);

    		//MuzzleFlashEmitter.SetLocation(Location);
    		//MuzzleFlashEmitter.SetRotation(Rotator(AimNormal) + Rot(-16384,0,0));
			MuzzleFlashEmitter.ParticleSystemComponent.ActivateSystem();
		}

	}
	// GunnerID is used for later if we have multiple gunners
	function bool CanGunnerFire(optional int GunnerID)
	{
		if (OverheatTimer > OverheatRate)
			return false;
		return true;
	}

	function Tick(float dt)
	{
		RefireTimer += dt;
		OverheatTimer += dt;

		if (RefireTimer > RefireRate)
		{
			//PlaySound(GunFireSound,,,,Location);
			CreateTracer();
			RefireTimer = 0;
		}
		if (!CanGunnerFire())
			GotoState('GunnerCooldown');
	}
}

