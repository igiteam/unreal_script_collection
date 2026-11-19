
class Shotgun extends TPWeaponUniqueReload;

var config byte         NumPellets;

var ParticleSystem	        SmokeTemplate;
var Emitter                 SmokeEmitter;
var int                     FireCount;

simulated event PostBeginPlay()
{
    Super.PostBeginPlay();

    if (SmokeTemplate != none)
	{
		SmokeEmitter = spawn(class'EmitterSpawnable');
		SmokeEmitter.ParticleSystemComponent.bAutoActivate = false;
		SmokeEmitter.bDestroyOnSystemFinish = false;
		if (SkeletalMeshComponent(Mesh) != none)
			SkeletalMeshComponent(Mesh).AttachComponentToSocket(SmokeEmitter.ParticleSystemComponent,'MuzzleFlash1P');

		SmokeEmitter.SetTemplate(SmokeTemplate, false);
	}
}

function ResetFireCount()
{
    FireCount = 0;
}

function SpawnSmoke()
{
    if (FireCount >= 4)
    {
        SmokeEmitter.ParticleSystemComponent.ActivateSystem();
        ResetFireCount();
    }
}

simulated function float GetFireInterval( byte FireModeNum )
{
	if (!bIsNPCWeapon)
	{
		return FireInterval[FireModeNum] > 0 ? FireInterval[FireModeNum] : 0.01;
	}
	else
	{
		return 0.5;
	}
}

simulated function FireAmmunition()
{
	local int i, idx;
	local vector			StartTrace, EndTrace;
	local ImpactInfo		RealImpact;
	local TPPawn			HitTPPawn;
	local Array<ImpactInfo>	ImpactList;
	local bool				bHitCreditGiven;

	//`log(" ChadAI - Shotgun: " @ Self @ " FireAmmunition --------------------------------------------------------------------------------------------------------------------------");

	bHitCreditGiven = false;

    ClearTimer('SpawnSmoke');
    ClearTimer('ResetFireCount');
    FireCount++;

    Super.FireAmmunition();

    for (i = 0; i < NumPellets-1; ++i)
    {
	    //This is taken from TPWeapon::InstantFire() and slightly modified...
		StartTrace = Instigator.GetWeaponStartTraceLocation();
		EndTrace = StartTrace + vector(GetAdjustedAim(StartTrace)) * GetTraceRange();

		// Perform shot
		RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);

		HitTPPawn = TPPawn(RealImpact.HitActor);

		if (!bHitCreditGiven && HitTPPawn != None && HitTPPawn.TeamAssignment != TPPawn(Owner).TeamAssignment)
		{
			if (WorldInfo.NetMode == NM_Standalone && PlayerPawn(Owner) != None && PlayerPawn(Owner).Controller != None && TPPlayerController(PlayerPawn(Owner).Controller) != None  ) // only in standalone
			{
				TPPlayerController(TPPawn(Owner).Controller).HitEnemyWithBullet();
			}
			else if (Role == ROLE_Authority && PlayerPawn(Owner) != None && PlayerPawn(Owner).Controller != None && TPPlayerController(PlayerPawn(Owner).Controller) != None  ) // only on the server
			{
				TPPlayerReplicationInfo(TPPlayerController(TPPawn(Owner).Controller).PlayerReplicationInfo).IncrementBulletsHitThisRound();
			}
			bHitCreditGiven = true;
		}

		// Added for Decals on Instant Fire Shots
		SpawnDecalEffect(RealImpact);

		if (Role == ROLE_Authority)
			SetFlashLocation(RealImpact.HitLocation);

		// Process all Instant Hits on local player and server (gives damage, spawns any effects).
		for (Idx = 0; Idx < ImpactList.Length; Idx++)
		{
			ProcessInstantHit(CurrentFireMode, ImpactList[Idx]);
		}

		Instigator.MakeNoise(m_FiringLoudness, AudioEventType_SMALL_ARMS_FIRING );
	}
}

simulated function float FireRecoilProcess (float Percent, float FireAngle)
{
    FireAngle = Super.FireRecoilProcess (Percent, FireAngle);
    return FireAngle / Percent;
}

// Overriden from parent so shell is not spawned when weapon is fired
simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	CauseMuzzleFlash();
}

simulated state WeaponFiring
{
    simulated function EndState( Name NextState )
    {
        SetTimer(0.7,,'SpawnSmoke');
        SetTimer(3.0,,'ResetFireCount');
        Super.EndState(NextState);
    }
}



