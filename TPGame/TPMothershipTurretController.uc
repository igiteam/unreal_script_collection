class TPMothershipTurretController extends TPAIController
    dependson(TPMothershipTurret_Persistent);


var TPMothershipTurret_Persistent MothershipTurret;

var int CurrentMuzzle;
var() float TurretProjectileSpeed, TurretProjectileDamage, TurretProjectileMomentum;

var float FireCooldown;
var float TimeSinceLastFire;
var float OverheatTime;
var float OverheatCooldownTime;
var float CurrOverheatTime;
var float CurrCooldownTime;

var array<Actor> CurrentTurretTarget;
var float TurretRefireTimer;
var float CurrentTurretRefire;
var bool bTurretShootingAtTarget;
var array<bool> bCurrentTurretFiring;

var AudioComponent FireEffectSoundCmpt;

var float TurretFollowRate;

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	super.Possess(aPawn,bVehicleTransition);

	MothershipTurret = TPMothershipTurret_Persistent(aPawn);

	FireEffectSoundCmpt.SoundCue = MothershipTurret.FireEffectSound;
	MothershipTurret.AttachComponent(FireEffectSoundCmpt);
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

	if (TurretTarget != None && bCurrentTurretFiring[CurrentMuzzle])
	{
		CurrentTurretTarget[CurrentMuzzle] = TurretTarget;
		MothershipTurret.Mesh.GetSocketWorldLocationAndRotation(MothershipTurret.MuzzleFlashSocketName[CurrentMuzzle], myLoc, myRot);

		myLoc += vect(0.0f, 0.0f, 10.0f);
		FireTarget = Normal((TurretTarget.Location + vect(0.0f, 0.0f, 10.0f)) - myLoc);

		//DrawDebugLine(myLoc, myLoc + FireTarget * 5000.0f, 255,0,0);

		SpawnedProjectile = Spawn(class'Proj_MP50', MothershipTurret,, myLoc + FireTarget * 10.0f,,, false);

		SpawnedProjectile.Speed = TurretProjectileSpeed;
		SpawnedProjectile.MaxSpeed = TurretProjectileSpeed;
		SpawnedProjectile.Damage = TurretProjectileDamage;
		SpawnedProjectile.MomentumTransfer = TurretProjectileMomentum;
		SpawnedProjectile.Init(FireTarget);
		TPProjectile(SpawnedProjectile).SpawnTracer();

		MothershipTurret.MuzzleFlashPSC[CurrentMuzzle].ActivateSystem();
		SetTimer(0.02f,false,'MuzzleFlashTimer');

		TimeSinceLastFire=FireCoolDown;
		CurrOverheatTime += TimeSinceLastFire;
		/*if (CurrOverheatTime >= OverheatTime)
		{
			CurrOverheatTime = 0.0f;
			CurrCooldownTime = OverheatCoolDownTime;
			if (FireEffectSoundCmpt.bWasPlaying)
				FireEffectSoundCmpt.Stop();
		}*/

		if (!FireEffectSoundCmpt.bWasPlaying)
	        FireEffectSoundCmpt.Play();
	}

	CurrentMuzzle++;
	if (CurrentMuzzle >= MothershipTurret.NumMuzzles)
		CurrentMuzzle = 0;
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

	for (muzzleI = 0; muzzleI < MothershipTurret.NumMuzzles; muzzleI++)
	{
		if (muzzleI < CurrentTurretTarget.Length)
			TurretTarget = CurrentTurretTarget[muzzleI];
		if (TurretTarget != None)
		{
			//grab our current "look" vector
			MothershipTurret.Mesh.GetSocketWorldLocationAndRotation(MothershipTurret.MuzzleFlashSocketName[muzzleI], myLoc, actualRot);

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

				MothershipTurret.GunRotateControl[muzzleI].BoneRotation.Yaw += myDir*TurretFollowRate*DeltaTime;
			}

			//this part is a little buggy, but what're you gonna do
			//grab our current "look" vector
			myRot = actualRot;
			//myRot.Yaw = 0;
			//myRot.Roll = 0;

			GetAxes(myRot, X, Y, Z);

			//DrawDebugLine(myLoc, myLoc + X * 5000.0f, 0,255,0);

			//now construct a vector from me to the player
			LookTarget = Normal((TurretTarget.Location - myLoc)*(vect(1.0f, 0.0f, 1.0f)));
			//DrawDebugLine(myLoc, myLoc + LookTarget * 5000.0f, 255,0,0);

			myAngle = Z dot LookTarget;
			if (abs(myAngle) > Threshold)
			{
				// this is a hack for incorrect bones
				if (myAngle > 0)
					myDir = -1.0f * MothershipTurret.GunPitchDir[muzzleI];
				else
					myDir = 1.0f * MothershipTurret.GunPitchDir[muzzleI];

				MothershipTurret.GunPitchControl[muzzleI].BoneRotation.Pitch += myDir*TurretFollowRate*DeltaTime;
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
				FireShotAtTarget(CurrentTurretTarget[CurrentMuzzle]);
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
		if (myTarget[0].IsA('Controller'))
			myTarget[0] = Controller(myTarget[0]).Pawn;
		
		CurrentTurretTarget[0] = Actor(myTarget[0]);
		bCurrentTurretFiring[0] = true;

		bTurretShootingAtTarget = true;
		CurrOverheatTime = 0.0f;
		CurrCooldownTime = 0.0f;
	}
}

function OnZepStopFire(SeqAct_ZepStopFire Action)
{
	bTurretShootingAtTarget = false;
	if (FireEffectSoundCmpt.bWasPlaying)
		FireEffectSoundCmpt.Stop();
}

simulated function MuzzleFlashTimer()
{
	MothershipTurret.MuzzleFlashPSC[CurrentMuzzle].DeactivateSystem();
}

