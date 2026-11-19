//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_ShotGun extends HDConventionalWeapon
      abstract;

var int              ShotCountMax, ShotCountMin;
var name             ArmReloadBegin, ArmReloadLoop, ArmReloadEnd;
var name             WeaponReloadLoop, WeaponReloadEnd;
var float            ReloadBeginTime, ReloadLoopTime, ReloadEndTime;

var transient bool   bReloadContinue;

var() float          FireEndEffectDelayTime;

// Recoil
var transient	bool	bRecoilFlag;
var transient   vector  RecoilValue;

reliable sync function SyncReload()
{
	if( Role == Role_Authority || Instigator.IsLocallyControlled() )
	{
		SendToReloadState();
	}

    // Play TPS Animation
    HDPawn(Instigator).PlayReloadAnim();
}

simulated state WeaponReload
{
    ignores StartZoom;

    simulated function BeginFire( byte FireModeNum )
    {
        Super.BeginFire( FireModeNum );
		if ( ClipBulletCount[CurrentFireModeType] > 0 )
		{
		    bReloadContinue = FALSE;
		}
    }

    simulated function AddBullet()
    {
    	if ( Role != ROLE_Authority ) return;
        // if we have enough or more ammo than the weapon needs
		if(AmmoBulletCount[CurrentFireModeType] > 0)
		{
			// subtrack the ammo from our inventory
			AmmoBulletCount[CurrentFireModeType] -= 1;
    		ClipBulletCount[CurrentFireModeType] += 1;
		    if ( !Instigator.IsLocallyControlled() )
		    {
		        ClientSyncWeaponBullet( CurrentFireModeType, AmmoBulletCount[CurrentFireModeType], ClipBulletCount[CurrentFireModeType] );
		    }
		}
    	//ReloadRepInfo[CurrentFireModeType].BulletCount = ClipBulletCount[CurrentFireModeType];
		//ReloadRepInfo[CurrentFireModeType].Finished = TRUE;
    }

	simulated function HandleFinishedReload()
	{
		global.HandleFinishedReload();
	}

    simulated function bool ContinueReload()
    {
        return ( ClipBulletCount[CurrentFireMode] < default.ClipBulletCount[CurrentFireMode] && bReloadContinue && AmmoBulletCount[CurrentFireMode] > 0 );
    }

    simulated function StepInEnd()
    {
        HandleFinishedReload();
    }

    simulated function ProcessWeaponReloadEnd()
    {
		 if (WorldInfo.NetMode != NM_DedicatedServer)
         {
			// Handle Animations
			PlayArmAnimation(ArmReloadEnd, 0);
			PlayWeaponAnimation(WeaponReloadEnd, 0);
			SetTimer( ReloadEndTime, false, 'StepInEnd' );
		 }
    }

    simulated function StepInCheckLoop()
    {
        if ( ContinueReload() )
        {
            ProcessWeaponReloadLoop();
        }
        else
        {
            ProcessWeaponReloadEnd();
        }
    }
    simulated function ProcessWeaponReloadLoop()
    {
		 if (WorldInfo.NetMode != NM_DedicatedServer)
         {
			// Handle Animations
			PlayArmAnimation(ArmReloadLoop, 0);
			PlayWeaponAnimation(WeaponReloadLoop, 0);
			SetTimer( ReloadLoopTime, false, 'StepInCheckLoop' );
			SetTimer( AddBulletTime[CurrentFireModeType], false, 'AddBullet' );
		 }
    }

    simulated function StepInLoop()
    {
        ProcessWeaponReloadLoop();
    }
    simulated function ProcessWeaponReloadBegin()
    {
		 if (WorldInfo.NetMode != NM_DedicatedServer)
         {
			// Handle Animations
			PlayArmAnimation(ArmReloadBegin, 0);
			SetTimer( ReloadBeginTime, false, 'StepInLoop');
		 }
    }
	simulated event BeginState( Name PreviousStateName )
	{
        // not zoom
        TerminateZoomMode();
		// not sprint
		HDPawn(Instigator).LeaveSprint();
        bReloadContinue=TRUE;
        ProcessWeaponReloadBegin();
		bShowHud = FALSE;
	}

	simulated event EndState( Name NextStateName )
	{
		ClearTimer('HandleFinishedReload');
		ClearTimer('StepInLoop');
		ClearTimer('StepInCheckLoop');
    	ClearTimer('AddBullet');
    	ClearTimer('StepInEnd');

    	if ( Role == Role_Authority )
    		SyncReloadEnd();
	}
}

unreliable server function  ServerSetFlashLocation( vector HitLocation )
{
    local HDPawn HDP;
    HDP = HDPawn(Instigator);
    if( HDP != None )
	{
		HDP.SyncSetFlashLocation( Self, CurrentFireMode, HitLocation );
	}
}

simulated function InstantFire()
{
	local vector StartTrace, EndTrace;
	local Array<ImpactInfo>	ImpactList;
	local ImpactInfo RealImpact, NearImpact;
	local int i, FinalImpactIndex;

    local HDPawn HDP;
    local HDWeaponAttachment   HDWA;
	local int subShotCount, shotindex;
	local float cof;
    cof = 0.2f;
    HDP = HDPawn(Instigator);
    HDWA = HDWeaponAttachment(HDP.CurrentWeaponAttachment);
    subShotCount = int(RandRange( ShotCountMin, ShotCountMax ));
    if ( HDP == none )//|| ReloadRepInfo[CurrentFireModeType].Finished == FALSE )
        return;

	if (ClipBulletCount[CurrentFireMode] >= 0)
	{
		CrosshairScaling = max_scaling;

        for ( shotindex = 0; shotindex < subShotCount; ++ shotindex )
        {
        	if ( shotindex < 5 ) cof = 0.2f;
            else if ( shotindex < 10 ) cof = 0.8f;
            else cof = 1.5f;
            angle = 0.1 + cof * shotindex;
            angle_zoom = angle;
            // define range to use for CalcWeaponFire()
        	StartTrace = InstantFireStartTrace();
        	EndTrace = InstantFireEndTrace(StartTrace);
        	bUsingAimingHelp = false;
        	// Perform shot
        	RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
        	FinalImpactIndex = ImpactList.length - 1;

        	if (FinalImpactIndex >= 0 && (ImpactList[FinalImpactIndex].HitActor == None || !ImpactList[FinalImpactIndex].HitActor.bProjTarget))
        	{
        		// console aiming help
        		NearImpact = InstantAimHelp(StartTrace, EndTrace, RealImpact);
        		if ( NearImpact.HitActor != None )
        		{
        			bUsingAimingHelp = true;
        			ImpactList[FinalImpactIndex] = NearImpact;
        		}
        	}
        }
	    angle = default.angle;
    	angle_zoom = default.angle_zoom;
        for (i = 0; i < ImpactList.length; i++)
        {
        	ProcessInstantHit(CurrentFireMode, ImpactList[i]);
        }

        // play first person fire recoil locally
        if ( HDWA != None )
            HDWA.PlayFPFireEffect(Self);

    	if (Role == ROLE_Authority)
    	{
    		// Set flash location to trigger client side effects.
    		// if HitActor == None, then HitLocation represents the end of the trace (maxrange)
    		// Remote clients perform another trace to retrieve the remaining Hit Information (HitActor, HitNormal, HitInfo...)
    		// Here, The final impact is replicated. More complex bullet physics (bounce, penetration...)
    		// would probably have to run a full simulation on remote clients.
    		if ( NearImpact.HitActor != None )
    		{
    			SetFlashLocation(NearImpact.HitLocation);
    		}
    		else
    		{
    			SetFlashLocation(ImpactList[0].HitLocation);
                for (i = 1; i < ImpactList.length; i++)
                {
        	       // only for other decals and impacts particle
                   ServerSetFlashLocation(ImpactList[i].HitLocation);
                }
    		}
			if (HDP.CurrentWeaponAttachment != none)
			{
				for (i = 1; i < ImpactList.length; i++)
				{
					if (ImpactList[i].HitLocation != Vect(0,0,0) && (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone) )
					{
						HDWeaponAttachment(HDP.CurrentWeaponAttachment).TPlayImpactEffects(ImpactList[i]);
					}
				}
			}
    	}

		shots_fired ++;
		CalculateRecoil();
	}

	if ( ClipBulletCount[CurrentFireModeType] == 0 )
	{
		SetTimer( FireInterval[CurrentFireModeType], false, 'ReloadWeapon' );
		//ReloadRepInfo[CurrentFireModeType].Finished = FALSE;
	}
	return;
}

// Play Fire Effect
simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	Super(TMWeapon).PlayFireEffects( FireModeNum, HitLocation );
}

simulated function StopFireEffects(byte FireModeNum)
{
	Super.StopFireEffects(FireModeNum);
}

simulated state WeaponFiring
{
	ignores WeaponSprintOut, WeaponSprintIn;

	simulated function BeginState(Name PrevStateName)
	{
	    super.BeginState( PrevStateName );
	    SetTimer( FireEndEffectDelayTime, false, 'PlayFireEndEffect' );
	}

	simulated function PlayFireEndEffect()
    {
		PlayWeaponAnimation( 'WeaponFireEnd', 0 );
		PlayArmAnimation( 'WeaponFireEnd', 0 );
		bRecoilFlag = false;
    }
}

// Recoil function
simulated function CalculateRecoil()
{
	CalculateRecoilFuncShotgun();
}

simulated function RecoverRecoil( float DeltaTime )
{
	RecoverRecoilFuncShotgun(DeltaTime);
}

// Recoil function 2
simulated function CalculateRecoilFuncShotgun()
{
	local vector tmp;

    bRecoilFlag = true;
	// delay calculate recoil
	tmp = (ZoomState == ZST_Zoomed)? RecoilZoomMax : RecoilMax;
	RecoilValue = punch_angle + RecoilPerShoot;
	RecoilValue.X = FClamp( RecoilValue.X, 0, tmp.X );
   	RecoilValue.Y = FClamp( RecoilValue.Y, 0, tmp.Y );
    if ( direction == 0 )
		RecoilValue.y = - RecoilValue.y;
	if (Rand(RecoilRandSeed) == 0)
		direction = 1 - direction;
}

simulated function RecoverRecoilFuncShotgun( float DeltaTime )
{
	if ( bRecoilFlag )
	{
		punch_angle.X = FWeaponInterpConstantTo( punch_angle.X, RecoilValue.X, DeltaTime,  RecoilTime );
		punch_angle.Y = FWeaponInterpConstantTo( punch_angle.Y, RecoilValue.Y, DeltaTime,  RecoilTime );
        if ( Abs(VSize(punch_angle) - VSize(RecoilValue)) < 0.0001f )
			bRecoilFlag = false;
	}
	else if ( !bRecoilFlag )
	{
		if ( VSize(punch_angle) > 0.0001f )
		{
		    punch_angle.X = FWeaponInterpConstantTo( punch_angle.X, 0, DeltaTime,  RecoilRecoverTime );
		    punch_angle.Y = FWeaponInterpConstantTo( punch_angle.Y, 0, DeltaTime,  RecoilRecoverTime );
		}
	}
}

