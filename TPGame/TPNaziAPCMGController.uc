class TPNaziAPCMGController extends TPAIController
	native;

var NaziAPCMG_Persistent	m_APC;
var float					m_FireCooldown;
var float					m_TimeSinceLastFire;

var float					m_OverheatTime ;
var float					m_CurrOverheatTime;
var float					m_CurrCooldownTime;

var Actor					m_TurretTarget;

var int						m_CurrentMuzzle;

// var float					m_TurretProjectileSpeed;
// var float					m_TurretProjectileDamage;
// var float					m_TurretProjectileMomentum;
// var float					m_TurretSpeed;
// var float					m_HowOfftenToDoLOS_Check;
// var float					m_OverheatCooldownTime;
// var float					m_ErrorThresholdForTurretRot;
// var INT						m_MinAngleOffsetForStartFiring;

var float					m_AimAccuracyOffset;


var float					m_LastTimeLOS_CheckDone;
var bool					m_bWasThereLOSLastCheck;

var bool					m_bIsGunPointedAtTarget;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


/* dont think needed any more cause bMakeKynapseEntity=false
simulated function PreBeginPlay()
{
	// don't need this crap, only have 1 active entity definition
	//local KynapseActiveEntityDefinition KAED;
	//
	if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		// don't need this crap, only have 1 active entity definition
		// find the first active entity definition
		//KEntityDefinition = None;
		//foreach AllActors(class 'KynapseActiveEntityDefinition', KAED)
		//{
		//	KEntityDefinition = KAED;
		//}
		//
		//if (KEntityDefinition != None)
		//{
		//	InitKynapseEntity(string(KEntityDefinition.Tag));
		//}
		//else
		//{
		//	`log("NO Kynapse active entity definition!!!!!");
		//}
		//
		InitKynapseEntity("KynapseObstaclePathObjectDefinition");
	}
	Super.PreBeginPlay();
}
*/

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	super.Possess(aPawn,bVehicleTransition);

	m_APC = NaziAPCMG_Persistent(aPawn);

	/* dont think needed any more cause bMakeKynapseEntity=false
	if (APC != None)
	{
		DestroyKynapseEntity(); // fix multiple kynapse entities
	}
	*/
}

//native simulated function TurretSeekTargetBehavior(float DeltaTime);
// {
// 	local Vector myLoc;
// 	local Rotator myRot;
// 	local Vector X, Y, Z;
// 	local Vector LookTarget;
// 	local float myAngle;
// 	local float myDir;
// 	local Rotator actualRot;
// 	local float Threshold;
// 
// 	Threshold = 0.01f;
// 
// 	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " TurretSeekTargetBehavior TurretTarget: " @ TurretTarget @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
// 
// 	FindPlayerController();
// 
// 	if (TurretTarget == None && m_ThePlayerController != None && m_ThePlayerController.Pawn != None )
// 	{
// 		TurretTarget = m_ThePlayerController.Pawn;
// 	}
// 
// 	if (TurretTarget != None)
// 	{
// 		//grab our current "look" vector
// 		APC.Mesh.GetSocketWorldLocationAndRotation('Muzzle_Tip', myLoc, actualRot);
// 
// 		myRot = actualRot;
// 		myRot.Pitch = 0;
// 		GetAxes(myRot, X, Y, Z);
// 		//DrawDebugLine(myLoc, myLoc + X * 5000.0f, 0,255,0);
// 
// 		//now construct a vector from me to the player
// 		LookTarget = Normal((TurretTarget.Location - myLoc)*(vect(1.0f, 1.0f, 0.0f)));
// 		//DrawDebugLine(myLoc, myLoc + LookTarget * 5000.0f, 255,0,0);
// 
// 		myAngle = Y dot LookTarget;
// 		if (abs(myAngle) > Threshold)
// 		{
// 			if (myAngle < 0)
// 				myDir = -1.0f;
// 			else
// 				myDir = 1.0f;
// 
// 			APC.skel_MG_Yaw.BoneRotation.Yaw += myDir*TurretSpeed*DeltaTime;
// 		}
// 
// 		//this part is a little buggy, but what're you gonna do
// 		//grab our current "look" vector
// 		myRot = actualRot;
// 		myRot.Yaw = 0;
// 		myRot.Roll = 0;
// 
// 		GetAxes(myRot, X, Y, Z);
// 
// 		//DrawDebugLine(myLoc, myLoc + X * 5000.0f, 0,255,0);
// 
// 		//now construct a vector from me to the player
// 		LookTarget = Normal((TurretTarget.Location - myLoc)*(vect(1.0f, 0.0f, 1.0f)));
// 		//DrawDebugLine(myLoc, myLoc + LookTarget * 5000.0f, 255,0,0);
// 
// 		myAngle = Z dot LookTarget;
// 		if (abs(myAngle) > Threshold)
// 		{
// 			if (myAngle < 0)
// 				myDir = -1.0f;
// 			else
// 				myDir = 1.0f;
// 
// 			APC.skel_MG_Pitch.BoneRotation.Yaw += myDir*TurretSpeed*DeltaTime*3;
// 		}
// 	}
// }

//native simulated function FireAtTarget(float CurrentGameTime);
// {
// 	local Vector myLoc;
// 	local Rotator myRot;
// 	//local Vector X, Y, Z;
// 	local Vector FireTarget;
// 	local Projectile	SpawnedProjectile;
// 
// 	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " FireAtTarget TurretTarget: " @ TurretTarget @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
// 
// 
// 	if (m_TurretTarget != None)
// 	{
// 		m_APC.Mesh.GetSocketWorldLocationAndRotation(m_APC.MuzzleFlashSocketName[m_CurrentMuzzle], myLoc, myRot);
// 
// 		myLoc += vect(0.0f, 0.0f, 10.0f);
// 		FireTarget = Normal((m_TurretTarget.Location + (VRand() * m_AimAccuracyOffset)) - myLoc);
// 
// 		//DrawDebugLine(myLoc, myLoc + FireTarget * 5000.0f, 255,0,0);
// 
// 		SpawnedProjectile = Spawn(class'Proj_SecBlimpGunnerBullet', m_APC,, myLoc + FireTarget * 10.0f,,, false);
// 
// 		SpawnedProjectile.Speed = m_TurretProjectileSpeed;
// 		SpawnedProjectile.MaxSpeed = m_TurretProjectileSpeed;
// 		SpawnedProjectile.Damage = m_TurretProjectileDamage;
// 		SpawnedProjectile.MomentumTransfer = m_TurretProjectileMomentum;
// 		SpawnedProjectile.Init(FireTarget);
// 		TPProjectile(SpawnedProjectile).SpawnTracer();
// 
// 		m_APC.PlaySound(m_APC.FireEffectSound);
// 
// 		m_APC.MuzzleFlashPSC[m_CurrentMuzzle].ActivateSystem();
// 		SetTimer(0.1f,false,'MuzzleFlashTimer');
// 
// 		m_TimeSinceLastFire=m_FireCoolDown;
// 		m_CurrOverheatTime += m_TimeSinceLastFire;
// 		if (m_CurrOverheatTime >= m_OverheatTime)
// 		{
// 			m_CurrOverheatTime = 0.0f;
// 			m_CurrCooldownTime = m_OverheatCoolDownTime;
// 		}
// 
// 		m_CurrentMuzzle++;
// 		if (m_CurrentMuzzle >= m_APC.NumMuzzles)
// 			m_CurrentMuzzle = 0;
// 	}
// }

simulated function MuzzleFlashTimer()
{
	m_APC.MuzzleFlashPSC[m_CurrentMuzzle].DeactivateSystem();
}

//native function bool ShouldAPCFireAtTarget (float CurrentGameTime);
// {
// 	// how offten between LOS checks
// 	if( m_TurretTarget != None )
// 	{
// 		if( m_LastTimeLOS_CheckDone < 0.0f ||  ( WorldInfo.TimeSeconds - m_LastTimeLOS_CheckDone ) > m_HowOfftenToDoLOS_Check )
// 		{
// 			m_LastTimeLOS_CheckDone = WorldInfo.TimeSeconds;
// 			
// 			if( LineOfSightTo(m_TurretTarget) )
// 			{
// 				m_bWasThereLOSLastCheck = true;
// 				return true;
// 			}
// 			else
// 			{
// 				m_bWasThereLOSLastCheck = false;
// 				return false;
// 			}
// 		}
// 		else
// 		{
// 			return m_bWasThereLOSLastCheck;
// 		}
// 	}
// 
// 	return false;
// }

native final function APC_WithGun_TickLogic( float CurrentGameTime, float DeltaTime);

auto state Waiting
{
	function Tick (float DeltaTime)
    {
		APC_WithGun_TickLogic(WorldInfo.TimeSeconds, DeltaTime);
	}

// 		if ( m_APC != None && m_APC.bTrackPlayer)
// 		{
// 			TurretSeekTargetBehavior(DeltaTime);
// 			if (m_CurrCooldownTime <= 0.0f)
// 			{
// 				if (m_TimeSinceLastFire <= 0.0f)
// 				{
// 					if( ShouldAPCFireAtTarget(WorldInfo.TimeSeconds) )
// 					{
// 						FireAtTarget(WorldInfo.TimeSeconds);
// 					}
// 				}
// 				else
// 					m_TimeSinceLastFire -= DeltaTime;
// 			}
// 			else
// 			{
// 				m_CurrCoolDownTime -= DeltaTime;
// 			}
// 		}
// 	}
}

function OnSetAPCTarget(SeqAct_SetAPCTarget Action)
{
	local array<Object> myTarget;

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " OnSetAPCTarget -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");


	if(Action.InputLinks[0].bHasImpulse)
	{
	   m_APC.bTrackPlayer = true;
	}
    else if(Action.InputLinks[1].bHasImpulse)
	{
	   m_APC.bTrackPlayer = false;
	}

	Action.GetObjectVars(myTarget,"Attack Target");

	if (myTarget.Length > 0)
	{
   		//`log("Setting TurretTarget to"@myTarget[0]);
		if (myTarget[0].IsA('Controller'))
			myTarget[0] = Controller(myTarget[0]).Pawn;
		m_TurretTarget = Actor(myTarget[0]);
	}

	//`log(" ChadAI - Pawn: " @ Pawn @ " Time: " @ WorldInfo.TimeSeconds @ " OnSetAPCTarget TurretTarget: " @ TurretTarget @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

}

function OnSetAPCVariables(SeqAct_SetAPCVariables Action)
{
	//`log("Setting APC variables");
	m_APC.m_TurretSpeed=Action.TurretSpeed;
	m_APC.m_TurretProjectileSpeed=Action.TurretProjectileSpeed;
	m_APC.m_TurretProjectileDamage=Action.TurretProjectileDamage;
	m_APC.m_TurretProjectileMomentum=Action.TurretProjectileMomentum;

	m_FireCooldown=Action.FireCooldown;
	m_OverheatTime=Action.OverheatTime;
	m_APC.m_OverheatCoolDownTime=Action.OverheatCoolDownTime;
	m_AimAccuracyOffset=Action.AimAccuracyOffset;
}

