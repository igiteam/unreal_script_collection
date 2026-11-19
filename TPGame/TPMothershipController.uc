class TPMothershipController extends TPAIController
    dependson(Mothership_Persistent);


var Mothership_Persistent Blimp;

var int CurrentMuzzle;
var float TurretProjectileSpeed, TurretProjectileDamage, TurretProjectileMomentum;

var float FireCooldown;
var float TimeSinceLastFire;
var float OverheatTime;
var float OverheatCooldownTime;
var float CurrOverheatTime;
var float CurrCooldownTime;

var Actor CurrentTurretTarget;
var float TurretRefireTimer;
var float CurrentTurretRefire;
var bool bTurretShootingAtTarget;

var AudioComponent FireEffectSoundCmpt;

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	super.Possess(aPawn,bVehicleTransition);

	Blimp = Mothership_Persistent(aPawn);

	FireEffectSoundCmpt.SoundCue = Blimp.FireEffectSound;

	FindPlayerController();

	if( m_ThePlayerController != None && m_ThePlayerController.Pawn != None )
	{
		m_ThePlayerController.Pawn.AttachComponent(FireEffectSoundCmpt);
	}
}

auto state Patroling
{
    function Tick (float DeltaTime)
    {
		if (bTurretShootingAtTarget)
		{
			ShootingAtTarget(DeltaTime);
		}
    }
}

function FireShotAtTarget(Actor TurretTarget)
{
	local Vector myLoc;
	local Rotator myRot;
	//local Vector X, Y, Z;
	local Vector FireTarget;
	local Projectile	SpawnedProjectile;

	if (TurretTarget != None)
	{
		CurrentTurretTarget = TurretTarget;
		Blimp.Mesh.GetSocketWorldLocationAndRotation(Blimp.MuzzleFlashSocketName[CurrentMuzzle], myLoc, myRot);

		myLoc += vect(0.0f, 0.0f, 10.0f);
		FireTarget = Normal((TurretTarget.Location + vect(0.0f, 0.0f, 10.0f)) - myLoc);

		//DrawDebugLine(myLoc, myLoc + FireTarget * 5000.0f, 255,0,0);

		SpawnedProjectile = Spawn(class'Proj_MothershipBullet', Blimp,, myLoc + FireTarget * 10.0f,,, false);

		SpawnedProjectile.Speed = TurretProjectileSpeed;
		SpawnedProjectile.MaxSpeed = TurretProjectileSpeed;
		SpawnedProjectile.Damage = TurretProjectileDamage;
		SpawnedProjectile.MomentumTransfer = TurretProjectileMomentum;
		SpawnedProjectile.Init(FireTarget);
		TPProjectile(SpawnedProjectile).SpawnTracer();

		Blimp.MuzzleFlashPSC[CurrentMuzzle].ActivateSystem();
		SetTimer(0.02f,false,'MuzzleFlashTimer');

		TimeSinceLastFire=FireCoolDown;
		CurrOverheatTime += TimeSinceLastFire;
		if (CurrOverheatTime >= OverheatTime)
		{
			CurrOverheatTime = 0.0f;
			CurrCooldownTime = OverheatCoolDownTime;
			if (FireEffectSoundCmpt.bWasPlaying)
				FireEffectSoundCmpt.Stop();
		}

		CurrentMuzzle++;
		if (CurrentMuzzle >= Blimp.NumMuzzles)
			CurrentMuzzle = 0;
	}
}

simulated function UpdateGunPosition(float DeltaTime)
{
	local Vector myLoc;
	local Rotator myRot;
	local Vector X, Y, Z;
	local Vector LookTarget;
	local float myAngle;
	local float myDir;
	local Rotator actualRot;
	local float Threshold;
	local Actor TurretTarget;
	local int muzzleI;

	Threshold = 0.01f;

	TurretTarget = CurrentTurretTarget;

	for (muzzleI = 0; muzzleI < Blimp.NumMuzzles; muzzleI++)
	{
		if (TurretTarget != None)
		{
			//grab our current "look" vector
			Blimp.Mesh.GetSocketWorldLocationAndRotation(Blimp.MuzzleFlashSocketName[muzzleI], myLoc, actualRot);

			myRot = actualRot;
			myRot.Pitch = 0;
			GetAxes(myRot, X, Y, Z);
			//DrawDebugLine(myLoc, myLoc + X * 5000.0f, 0,255,0);

			//now construct a vector from me to the player
			LookTarget = Normal((TurretTarget.Location - myLoc)*(vect(1.0f, 1.0f, 0.0f)));
			//DrawDebugLine(myLoc, myLoc + LookTarget * 5000.0f, 255,0,0);

			myAngle = Y dot LookTarget;
			if (abs(myAngle) > Threshold)
			{
				if (myAngle < 0)
					myDir = -1.0f;
				else
					myDir = 1.0f;

				Blimp.GunRotateControl[muzzleI].BoneRotation.Yaw += myDir*7000*DeltaTime;
			}
		}
	}
}

simulated function ShootingAtTarget(float DeltaTime)
{
	UpdateGunPosition(DeltaTime);
	CurrentTurretRefire+=DeltaTime;

	if (CurrentTurretRefire > TurretRefireTimer)
	{
		CurrentTurretRefire=0.0f;
		if (CurrCooldownTime <= 0.0f)
		{
			if (TimeSinceLastFire <= 0.0f)
			{
				if (!FireEffectSoundCmpt.bWasPlaying)
				        FireEffectSoundCmpt.Play();

				FireShotAtTarget(CurrentTurretTarget);
			}
			else
				TimeSinceLastFire -= DeltaTime;
		}
		else
		{
			CurrCoolDownTime -= DeltaTime;
		}
	}
}

function OnZepFireAtTarget(SeqAct_ZepFireAtTarget Action)
{
	local array<Object> myTarget;
	Action.GetObjectVars(myTarget,"Attack Target");

	if (myTarget.Length > 0)
	{
		//`log("Setting RightTarget to"@RightTarget[0]);
		if (myTarget[0].IsA('Controller'))
			myTarget[0] = Controller(myTarget[0]).Pawn;
		CurrentTurretTarget = Actor(myTarget[0]);
		bTurretShootingAtTarget = true;
		CurrOverheatTime = 0.0f;
		CurrCooldownTime = 0.0f;
	}
}

function OnZepStopFire(SeqAct_ZepStopFire Action)
{
	bTurretShootingAtTarget = false;
}

simulated function MuzzleFlashTimer()
{
	Blimp.MuzzleFlashPSC[CurrentMuzzle].DeactivateSystem();
}

