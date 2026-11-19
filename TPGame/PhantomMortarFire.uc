class PhantomMortarFire extends Actor
							placeable;

var array<Actor> AimTargets;
var float FireRate, FireTimer;
var bool  bGunnerActive;
var int CurrentTargetIndex;

var SeqAct_PhantomMortarFire FireAction;
//var	ParticleSystem MuzzleFlashTemplate;
var() SoundCue FireSound;
//var EmitterSpawnable MuzzleFlashEmitter;
var class<TPProjectile> ProjectileClass;
var AudioComponent FireAudioCmpt;

simulated function PostBeginPlay()
{
 //   MuzzleFlashEmitter = Spawn(class'EmitterSpawnable');
	//MuzzleFlashEmitter.ParticleSystemComponent.bAutoActivate = false;
	//MuzzleFlashEmitter.SetTemplate( MuzzleFlashTemplate, false);

	if (FireSound != none)
	{
		FireAudioCmpt.SoundCue = FireSound;
		AttachComponent(FireAudioCmpt);
	}
	//AttachComponent(MuzzleFlashEmitter.ParticleSystemComponent);
}

function OnAssignAimTargets(SeqAct_AssignAimTargets Act)
{
	local int i;
	if (Act.AimTargets.Length > 0)
	{
		AimTargets.Insert(0,Act.AimTargets.Length);
		for (i = 0; i < Act.AimTargets.Length; i++)
		{
			if (Act.AimTargets[i] != none)
			{
				if (Act.AimTargets[i].IsA('Controller'))
					Act.AimTargets[i] = Controller(Act.AimTargets[i]).Pawn;
				AimTargets[i] = Act.AimTargets[i];
			}
		}
	}
}
function OnPhantomMortarFire(SeqAct_PhantomMortarFire Act)
{
	local int i;
	FireAction = Act;
	if (Act.InputLinks[0].bHasImpulse)
	{
		AimTargets.Insert(0, Act.AimTargets.Length);
		for (i = 0; i < Act.AimTargets.Length; i++)
		{
			if (Act.AimTargets[i] != none)
			{
				if (Act.AimTargets[i].IsA('Controller'))
					Act.AimTargets[i] = Controller(Act.AimTargets[i]).Pawn;
				AimTargets[i] = Act.AimTargets[i];
			}
		}
		FireTimer = 0.0;
		FireRate = Act.FireRate;
		bGunnerActive = true;
		GotoState('GunnerFiring');
	}
	else if (Act.InputLinks[1].bHasImpulse)
	{
        bGunnerActive = false;
		GotoState('Idle');
	}
}

// Used for just activating one fire per toggle
simulated function OnToggle(SeqAct_Toggle Act)
{
	if (Act.InputLinks[0].bHasImpulse || Act.InputLinks[2].bHasImpulse && AimTargets.Length > 0)
		CreateTracer();
}

function CreateTracer()
{
	local TPProjectile Bullet;
	local vector AimNormal, AimLoc;
	local float RangeToTarget, MortarSpeed;
	AimLoc = AimTargets[CurrentTargetIndex].Location;

	AimNormal = AimLoc - Location;
	RangeToTarget = VSize(AimNormal);
	AimNormal = Normal(AimNormal + (vect(0,0,1) * RangeToTarget));
	Bullet = Spawn(ProjectileClass,self,,Location);

	//Don't spam the log if the spawn fails.
	if ( Bullet != None )
	{
		if (FireAction != none)
		{
			Bullet.MyDamageType = FireAction.DamageType;
			Bullet.Damage = FireAction.ShellDamage;
			Bullet.MomentumTransfer = FireAction.MomentumTransfer;
		}
		//MortarSpeed = Sqrt(RangeToTarget*-WorldInfo.WorldGravityZ);
		//Bullet.Speed = MortarSpeed*1.4;
		//Bullet.MaxSpeed = MortarSpeed*1.4;

		MortarSpeed = Sqrt(-WorldInfo.WorldGravityZ)*RangeToTarget/Sqrt(2*0.707*(RangeToTarget-(AimLoc.Z-Location.Z)*0.707));
		//MortarSpeed = Sqrt(-WorldInfo.WorldGravityZ*RangeToTarget/(2*0.707));
		Bullet.PhysicsVolume.TerminalVelocity = 10000000.0f;

		Bullet.Speed = MortarSpeed*1.675;
		Bullet.MaxSpeed = MortarSpeed*1.675;
		//Bullet.Acceleration = MortarSpeed * AimNormal;
		Bullet.SpawnTracer();
		// this bullet is a Proj_MortarShell and needs to get its Physics initialized to phys_falling
        Bullet.Init(AimNormal);

		//Bullet.Velocity = vect(0,0,0);
		//SetRotation(rotator(AimNormal) + rot(-16384, 0, 0));
    	//MuzzleFlashEmitter.ParticleSystemComponent.ActivateSystem();
		CurrentTargetIndex++;
		if (CurrentTargetIndex > AimTargets.Length-1)
			CurrentTargetIndex = 0;
	}
}

auto state Idle
{

}

state GunnerFiring
{
	function BeginState(Name PreviousStateName)
	{
		FireAudioCmpt.Play();
	}

	function Tick(float dt)
	{
		FireTimer += dt;

		if (FireTimer > FireRate)
		{
			CreateTracer();
			FireTimer = 0;
		}
	}
}

