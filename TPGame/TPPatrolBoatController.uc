class TPPatrolBoatController extends TPAIController
    dependson(TPPatrolBoat_Persistent);


var TPPatrolBoat_Persistent Boat;

var int CurrentMuzzle;
var float TurretProjectileSpeed, TurretProjectileDamage, TurretProjectileMomentum;

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

	Boat = TPPatrolBoat_Persistent(aPawn);

	//FireEffectSoundCmpt.SoundCue = Boat.FireEffectSound;
	//Boat.AttachComponent(FireEffectSoundCmpt);
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
		Boat.Mesh.GetSocketWorldLocationAndRotation(Boat.MuzzleFlashSocketName[CurrentMuzzle], myLoc, myRot);

		myLoc += vect(0.0f, 0.0f, 10.0f);
		FireTarget = Normal((TurretTarget.Location + vect(0.0f, 0.0f, 10.0f)) - myLoc);

		//DrawDebugLine(myLoc, myLoc + FireTarget * 5000.0f, 255,0,0);

		SpawnedProjectile = Spawn(class'Proj_BoatBullet', Boat,, myLoc + FireTarget * 10.0f,,, false);

		SpawnedProjectile.Speed = TurretProjectileSpeed;
		SpawnedProjectile.MaxSpeed = TurretProjectileSpeed;
		SpawnedProjectile.Damage = TurretProjectileDamage;
		SpawnedProjectile.MomentumTransfer = TurretProjectileMomentum;
		SpawnedProjectile.Init(FireTarget);
		TPProjectile(SpawnedProjectile).SpawnTracer();

		Boat.MuzzleFlashPSC[CurrentMuzzle].ActivateSystem();
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

// 		if (!FireEffectSoundCmpt.bWasPlaying)
// 	        FireEffectSoundCmpt.Play();
		Boat.PlaySound(Boat.FireEffectSound);
	}

	CurrentMuzzle++;
	if (CurrentMuzzle >= Boat.NumMuzzles)
		CurrentMuzzle = 0;
}

simulated function UpdateGunPosition(float DeltaTime)
{
	local Vector muzzleLoc;
	local Rotator muzzleRot;
	local Vector X, Y, Z;
	local float myAngle;
	local float myDir;
	local float Threshold;
	local Actor TurretTarget;
	local int muzzleI;
		
	local Vector Delta;

	Threshold = 0.01f;

	for (muzzleI = 0; muzzleI < Boat.NumMuzzles; muzzleI++)
	{
		if (muzzleI < CurrentTurretTarget.Length)
			TurretTarget = CurrentTurretTarget[muzzleI];
		if (TurretTarget != None)
		{
			// Grab our current "look" vector
			Boat.Mesh.GetSocketWorldLocationAndRotation(Boat.MuzzleFlashSocketName[muzzleI], muzzleLoc, muzzleRot);

			GetAxes(muzzleRot, X, Y, Z);
			//DrawDebugLine(muzzleLoc, muzzleLoc + X * 5000.0f, 0,255,0);

			// Now construct a vector from me to the player
			Delta = Normal(TurretTarget.Location - muzzleLoc);
			
			// Determine whether to turn left or right, or just keep looking in our current direction
			myAngle = Y dot Delta;
			
			if (abs(myAngle) > Threshold)
			{
				if (myAngle < 0)
					myDir = -1.0f;
				else
					myDir = 1.0f;

				Boat.GunRotateControl[muzzleI].BoneRotation.Yaw += myDir*TurretFollowRate*DeltaTime;
			}

			// Finally determine whether to look up or down
			myAngle = Z dot Delta;
			if (abs(myAngle) > Threshold)
			{
				// this is a hack for incorrect bones
				if (myAngle < 0)
					myDir = -1.0f * Boat.GunPitchDir[muzzleI];
				else
					myDir = 1.0f * Boat.GunPitchDir[muzzleI];

				Boat.GunPitchControl[muzzleI].BoneRotation.Pitch += myDir*TurretFollowRate*DeltaTime;
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
	local int i;
	Action.GetObjectVars(myTarget,"Attack Target");

	if (myTarget.Length > 0)
	{
		//`log("Setting RightTarget to"@RightTarget[0]);
		for (i = 0; i < 2; i++)
		{
			if (myTarget.Length == 1)
			{
				if (myTarget[0].IsA('Controller'))
					myTarget[0] = Controller(myTarget[0]).Pawn;
				CurrentTurretTarget[i] = Actor(myTarget[0]);
			}
			else
			{
				if (myTarget[i].IsA('Controller'))
					myTarget[i] = Controller(myTarget[i]).Pawn;
				CurrentTurretTarget[i] = Actor(myTarget[i]);
			}

			bCurrentTurretFiring[i] = true;
		}
		bTurretShootingAtTarget = true;
		CurrOverheatTime = 0.0f;
		CurrCooldownTime = 0.0f;
	}
}

function OnZepStopFire(SeqAct_ZepStopFire Action)
{
	bTurretShootingAtTarget = false;
// 	if (FireEffectSoundCmpt.bWasPlaying)
// 		FireEffectSoundCmpt.Stop();
}

function OnBoatFireAtTargets(SeqAct_BoatFireAtTargets Action)
{
	local array<Object> frontTarget;
	local array<Object> backTarget;
	Action.GetObjectVars(frontTarget,"Front Target");
	Action.GetObjectVars(backTarget,"Back Target");

	if (frontTarget.Length > 0)
	{
		if (frontTarget[0].IsA('Controller'))
			frontTarget[0] = Controller(frontTarget[0]).Pawn;
		
		CurrentTurretTarget[0] = Actor(frontTarget[0]);
		bCurrentTurretFiring[0] = true;

		bTurretShootingAtTarget = true;
		CurrOverheatTime = 0.0f;
		CurrCooldownTime = 0.0f;
	}

	if (backTarget.Length > 0)
	{
		if (backTarget[0].IsA('Controller'))
			backTarget[0] = Controller(backTarget[0]).Pawn;
		
		CurrentTurretTarget[1] = Actor(backTarget[0]);
		bCurrentTurretFiring[1] = true;

		bTurretShootingAtTarget = true;
		CurrOverheatTime = 0.0f;
		CurrCooldownTime = 0.0f;
	}
}

function OnBoatStopFiring(SeqAct_BoatStopFiring Action)
{
	bCurrentTurretFiring[0] = !Action.StopFrontTurret;
	bCurrentTurretFiring[1] = !Action.StopBackTurret;

// 	if (!bCurrentTurretFiring[0] && !bCurrentTurretFiring[1] && FireEffectSoundCmpt.bWasPlaying)
// 		FireEffectSoundCmpt.Stop();
}

function OnBoatSetParameters(SeqAct_BoatSetParameters Action)
{
	TurretProjectileSpeed = Action.TurretProjectileSpeed;
	TurretProjectileDamage = Action.TurretProjectileDamage;
	TurretProjectileMomentum = Action.TurretProjectileMomentum;
	TurretRefireTimer = Action.TurretRefireTimer;
	TurretFollowRate = Action.TurretFollowRate;
}

simulated function MuzzleFlashTimer()
{
	Boat.MuzzleFlashPSC[CurrentMuzzle].DeactivateSystem();
}

