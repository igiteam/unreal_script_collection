class NaziAPCMG_Persistent extends NaziAPC_Persistent
    native
	abstract;

var array<ParticleSystemComponent>	MuzzleFlashPSC;
var ParticleSystem			MuzzleFlashPSCTemplate;
var class<TPProjectile>		ProjectileClass;
var array<name> MuzzleFlashSocketName;
var float FireRate, CurrentTime, LastTime;

var SkelControlSingleBone GunControl;
var SkelControlSingleBone TurretControl;
var float MaxGunPitchAngle;
var float MaxGunYawAngle;

var SkeletalMeshSocket			 m_Gun1_Socket;

var Actor Focus;
var() bool bTrackPlayer;

var TPSkelControlPlayerYaw skel_MG_Yaw;
var TPSkelControlPlayerYaw skel_MG_Pitch;

var int NumMuzzles;
var SoundCue FireEffectSound;

var () float					m_TurretProjectileSpeed;
var () float					m_TurretProjectileDamage;
var () float					m_TurretProjectileMomentum;
var () float					m_TurretSpeed;
var () float					m_HowOfftenToDoLOS_Check;
var () float					m_OverheatCooldownTime;
var () float					m_ErrorThresholdForTurretRot;
var () INT						m_MinAngleOffsetForStartFiring;

simulated function PostBeginPlay()
{
	local int i;

	super.PostBeginPlay();
	GunControl = SkelControlSingleBone(Mesh.FindSkelControl('MachineGun'));
	TurretControl = SkelControlSingleBone(Mesh.FindSkelControl('Gunner_Turret'));

	for (i = 0; i < NumMuzzles; i++)
	{
		if (MuzzleFlashPSCTemplate != none)
		{
			MuzzleFlashPSC[i] = new(Outer) class'ParticleSystemComponent';
			MuzzleFlashPSC[i].SetTemplate(MuzzleFlashPSCTemplate);
			Mesh.AttachComponentToSocket(MuzzleFlashPSC[i], MuzzleFlashSocketName[i]);
			MuzzleFlashPSC[i].SetDepthPriorityGroup(SDPG_World);
			MuzzleFlashPSC[i].DeactivateSystem();
		}
	}

	skel_MG_Yaw = TPSkelControlPlayerYaw(Mesh.FindSkelControl('TurretYaw'));
	skel_MG_Yaw.SetSkelControlActive(true);

	skel_MG_Pitch = TPSkelControlPlayerYaw(Mesh.FindSkelControl('TurretPitch'));
	skel_MG_Pitch.SetSkelControlActive(true);

	if ( Controller == None )
	{
    	if ( ControllerClass != None )
	    	Controller = Spawn(ControllerClass);

    	if ( Controller != None )
	       	Controller.Possess( Self, false );
	}

	m_Gun1_Socket = Mesh.GetSocketByName('Muzzle_Tip');

}

function OnTankTurretLookAt(SeqAct_TankTurretLookAt Action)
{
	local rotator LookAt;
	local vector SocketLoc;
	local rotator SocketRot;

	bTrackPlayer=false;
	Mesh.GetSocketWorldLocationAndRotation(MuzzleFlashSocketName[0], SocketLoc, SocketRot);
	//LookAt = rotator(Normal(Action.Destination.Location - SocketLoc));
	LookAt.Pitch = rotator(Normal(Action.Destination.Location - SocketLoc)).Yaw;
	TurretControl.BoneRotation = LookAt;
}

// Once we get the NPC's in the turret this function will change its name 
// and use the functionality of the body.

//simulated function StartFire(byte FireModeNum)
//{
//	local vector Loc;
//	local rotator Rot;
//	local TPProjectile Proj;
//
//	CurrentTime = WorldInfo.TimeSeconds;
//	
//	if (CurrentTime - LastTime > FireRate)
//	{
//		Mesh.GetSocketWorldLocationAndRotation(MuzzleFlashSocketName, Loc, Rot);
//		MuzzleFlashPSC.ActivateSystem();
//		Proj = Spawn(ProjectileClass, Self,, Loc);
//		Proj.SpawnTracer();
//		Proj.Init(vector(Rot));
//		LastTime = WorldInfo.TimeSeconds;
//	}
//}

event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local bool CanDamage;	
	
	if (DestructComponent != None)
	{
		CanDamage = DestructComponent.CanDoDamageType(damageType);
	}
	else
	{
		CanDamage = true;
	}

	if (CanDamage && ((Health - Damage) <= 0))
	{
		DetachFromController(true);
	}

	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo, DamageCauser);
}

State Dying
{
	function BeginState(Name PreviousStateName)
	{
		DetachFromController(true);
	}

	simulated function FinishDeath()
	{
		Destroy();
	}
}


