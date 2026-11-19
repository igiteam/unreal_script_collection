//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeapon_CallSupport extends HDSpecialWeapon;

var ParticleSystem                          PS_SelectedZone;
var Emitter                                 EM_SelectedPoint;
var ImpactInfo                              HitImpactInfo;

enum ECSFireMode
{
    ECS_Turret,
    ECS_Missiles,
    ECS_TrackMissile,
    ECS_Satellite,
};

var()  ECSFireMode                          CurrentCSFM; // call support fire mode
var()  float                                CoolDownTime[4];
var transient byte                          AttackFlag[4];
var     name                                CSModeStates[4];
var()   float                               SwitchTime;

var MaterialInstanceConstant                WeaponNameShow[4];
var transient MaterialInstanceConstant      WeaponNameShowInstance[4];

var transient bool                          bCanAttack;
var()   float                               MaxAttackDistance;
var()   float                               MinAttackDistance;
var()   float                               WeaponFOV;

var MaterialInstanceConstant                HudMaterial;

var bool                                   bDisplayCrosshair;

// turret
var(Turret) float                          TurretDelayTime;
var(Turret) float                          TurretFireInterval;
var(Turret) float                          TurretFireRange;
var(Turret) float                          TurretFireAngle;
var(Turret) int                            TurretFireCount;
var class<HDWeaponAttachment>              TurretAttachmentClass;
var transient vector                       TurretFireLocation;
var transient rotator                      TurretFireTarget;
var transient bool                         bDoTurretAttack;

// missile
var(Missile) int                           MissileCount;
var(Missile) float                         MissileAttackOffset;
var(Missile) float                         MissileAttackRange;
var(Missile) float                         MissileDelayTime;
var(Missile) float                         MissileFireInterval;
var class<Projectile>                      MissileProjectiles;
var transient vector                       MissileSpawnPosition;
var transient vector                       MissileSpawnDirection;

// track missile
var(TrackMissile) float                     TrackMissileDelayTime;
var(TrackMissile) float                     TrackMissileAttackOffset;
var(TrackMissile) float                     TrackLockTime;
var transient bool                          bLockFlag;
var transient vector                        TrackMissileSpawnPosition;
var transient vector                        TrackMissileSpawnDirection;
var transient Actor                         LastTrackTarget;
var class<Projectile>                       TrackMissileProjectiles;

// satellite
var Camera                                  SatelliteCamera;
var(Satellite) float                        SatelliteDelayTime;
var(Satellite) float                        SatelliteOffset;
var(Satellite) float                        SatelliteMissileSpeed;
var(Satellite) float                        SatelliteCameraFOV;
var class<Projectile>                       SatelliteMissile;
var transient  float                        DefaultFOV;
var transient  float                        SatelliteTime;
var transient vector                        SatelliteMissileSpawnPosition;
var transient vector                        SatelliteMissileSpawnDirection;
var transient bool                          bSatelliteMode;
var transient bool                          bSatelliteTrace;


var(UI) float A,B,C,D,E,F,AG1,AG2, HH, HV;

var MaterialInstanceConstant                    SatelliteHUD;

// do not switch NV and gasmask
simulated  function bool    ToggleNightVision(bool bIsNightVision);
simulated  function bool    ToggleGasMask(bool bIsEquip );
simulated  function         ToggleMelee();

reliable server function    ServerSetCurrentFireState( int index )
{
    SetCurrentFireState( index );
}

simulated function SetCurrentFireState( int index )
{
    CurrentCSFM = ECSFireMode(index);
}
simulated function SwitchAttackFireMode( bool bUp )
{
    local int index;
    index = int(CurrentCSFM);
    index += (bUp)? 1:-1;
    index = Clamp( index, ECS_Turret, ECS_TrackMissile );
    if ( ROLE < ROLE_Authority )
    {
        ServerSetCurrentFireState(index);
    }
    SetCurrentFireState(index);
    GotoState('WeaponFireModeSwitch');
}

simulated function SelectAttackZone()
{
    if ( GetStateName() == 'Inactive' )
    {
        EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
        bCanAttack = FALSE;
        return;
    }
}

//---------------------------------------------------------
// state
//---------------------------------------------------------
simulated function ExitSwitchState();
simulated state WeaponFireModeSwitch
{
    simulated event BeginState(Name PreStateName)
    {
        SetTimer( SwitchTime, false, 'ExitSwitchState');
    }
    simulated function ExitSwitchState()
    {
        GotoState('Active');
    }
    simulated event EndState(Name NextStateName)
    {
        ClearTimer('ExitSaitchState');
    }
}

simulated state WeaponEquipping
{
    ignores WeaponSprintIn, WeaponSprintOut,Reload, StartFire, PutDownWeapon, Activate, ToggleGasMask, ToggleNightVision;
    simulated function BeginState(Name PrevStateName)
    {
        local HDPlayerController HDPC;
        HDPC = HDPlayerController(Instigator.Controller);

        Super.BeginState(PrevStateName);

        bDisplayCrosshair=TRUE;
        if ( HDPC != none )
        {
            HDPC.GotoState('PlayerCallSupport');
            HDPC.StartZoom( WeaponFOV, 0 );
        }
        bForceHidden = True;

        if ( Instigator.IsLocallyControlled() )
            HDPawn(Instigator).SyncInitCSTurretAttachment(TurretAttachmentClass);
    }
}


simulated state WeaponPuttingDown
{
    ignores WeaponSprintIn, WeaponSprintOut, Reload, StartFire, PutDownWeapon, Activate, ToggleGasMask, ToggleNightVision;
    simulated function BeginState(Name PrevStateName)
    {
        TimeWeaponPutDown();
        bWeaponPutDown = false;

        SetTimer( 0.1, false, 'CloseEye' );
        EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
    }

    simulated function CloseEye()
    {
        bDisplayCrosshair=FALSE;
        bForceHidden = False;
        bPendingShow = True;
    }

    simulated event EndState(Name NextStateName)
    {
        Super.EndState(NextStateName);
    }
}

simulated function StartFire(byte FireModeNum)
{
    Super.StartFire(FireModeNum);
}

reliable server function ServerExitWeaponFireMode()
{
    ExitWeaponFireMode();
}

simulated function ExitWeaponFireMode()
{
    GotoState('Active');
}

simulated function StopFire(byte FireModeNum)
{
    Super.StopFire(FireModeNum);
    if ( ROLE < ROLE_Authority )
    {
       ServerExitWeaponFireMode();
    }
    ExitWeaponFireMode();
}


state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        local HDPlayerController HDPC;
        local HDHUD HUD;

        HDPC = HDPlayerController(Instigator.Controller);
        HUD  = HDHUD(HDPC.myHUD);
        Super.BeginState(PreviousStateName);
        HUD.myGFxHUD.DrawTipText(HUD.myGFxHUD.TipText[CurrentCSFM+1]);       //draw Tip Strings
    }

    simulated function BeginFire(byte FireModeNum)
    {
        if ( AttackFlag[CurrentCSFM] == 0 || !bCanAttack )
            return;

        if( !bDeleteMe && Instigator != None )
        {
            Global.BeginFire(FireModeNum);

            // in the active state, fire right away if we have the ammunition
            if( PendingFire(FireModeNum) )
            {
                 // Needs a state name, and ignores a none fire type
                 if( CSModeStates[CurrentCSFM] == '' )
                     return;

            }
            // set current fire mode
            SetCurrentFireMode(FireModeNum);
            // transition to firing mode state
            GotoState(CSModeStates[CurrentCSFM]);
        }
    }

    simulated function SelectAttackZone()
    {
        local vector StartTrace, EndTrace;
        local ImpactInfo    RealImpact;
        local vector HitLocation, HitNormal;
        local rotator HitRotator;
        local float distance;

        StartTrace = InstantFireStartTrace();
        EndTrace = InstantFireEndTrace(StartTrace);
        RealImpact = CalcWeaponFire(StartTrace, EndTrace);
        if ( RealImpact.HitActor != NONE )
        {
            distance = VSizeSq( RealImpact.HitLocation - StartTrace );
            if ( distance < MaxAttackDistance * MaxAttackDistance && distance > MinAttackDistance * MinAttackDistance )
            {
                HitLocation = RealImpact.HitLocation;
                HitNormal = RealImpact.HitNormal;
                EM_SelectedPoint.ParticleSystemComponent.SetActive(TRUE);
                EM_SelectedPoint.SetLocation(HitLocation);
                HitRotator =  rotator(HitNormal) + rot(-16384,0,0);
                EM_SelectedPoint.SetRotation(HitRotator);
                bCanAttack = TRUE;
                return;
            }
        }
        EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
        bCanAttack = FALSE;
    }

}
simulated function ExitCurrentWeaponMode()
{
    local HDPlayerController HDPC;
    HDPC = HDPlayerController(Instigator.Controller);
    if ( HDPC != None )
    {
        HDPC.EndZoom();
        HDPC.GotoState('PlayerWalking');
    }
}
state Inactive
{
    //ignores SelectAttackZone;
    simulated function BeginState(name PreviousStateName)
    {
        local HDPlayerController HDPC;

        HDPC = HDPlayerController(Instigator.Controller);
        HDHUD(HDPC.myHUD).myGFxHUD.CloseTipText();

        ExitCurrentWeaponMode();
        Super.BeginState(PreviousStateName);
        EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
    }
}


//---------------------------------------------------------
// Turret
//---------------------------------------------------------
simulated function TimeTurretAttacking() // only execute on server
{
    if ( Role == Role_Authority )
    {
        if( !IsTimerActive('DoTurretAttack') )
        {
            SetTimer( TurretFireInterval, true, nameof(DoTurretAttack) );
        }
    }
}

reliable client function  ClientSetTurretFireCount( int Count )
{
    TurretFireCount = Count;
}

simulated function DoTurretAttack()  // only execute on server
{
    --TurretFireCount;
    ClientSetTurretFireCount(TurretFireCount);
    TurretFiring();
}

simulated function TurretFiring()
{
    local vector EndTrace;
    local Array<ImpactInfo> ImpactList;
    local ImpactInfo RealImpact;
    local int i;

    local HDPawn HDP;
    HDP = HDPawn(Instigator);

    if ( HDP == none )
        return;

    // define range to use for CalcWeaponFire()
    EndTrace = TurretFireLocation + vector(GetTurretFireRot(TurretFireTarget)) * TurretFireRange;
    // Perform shot
    RealImpact = CalcWeaponFire(TurretFireLocation, EndTrace, ImpactList);

    for (i = 0; i < ImpactList.length; i++)
    {
        ProcessInstantHit(CurrentFireMode, ImpactList[i]);
    }

    if (Role == ROLE_Authority)
    {
       if ( RealImpact.HitLocation != Vect(0,0,0) && (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone ) )
       {
           HDPawn(Instigator).PlayCSTurretAttachment(RealImpact.HitLocation);
       }
    }
    return;
}

simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
    return Super(TMWeapon).GetAdjustedAim(StartFireLoc);
}

simulated function Rotator GetTurretFireRot( rotator Dir )
{
    local rotator r;
    local rotator ret;
    local vector t;
    ret = Dir;

    t.x = FRand() * 2.0 * 3.1415926;
    t.y = cos(t.x);
    t.x = sin(t.x);
    t = t * FRand();
    r.pitch = TurretFireAngle * t.x / 360.0 * 65536.0;
    r.yaw = TurretFireAngle * t.y / 360.0 * 65536.0;
    ret = ret + r;

    return ret;
}

simulated state WeaponTurret
{
    simulated event BeginState(Name PrevStateName)
    {
       ;
    }
    simulated event EndState(Name NextStateName)
    {
        if ( !bCanAttack )
            return;
        TurretFire();
    }
    simulated function TurretFire()
    {
        TurretFireLocation = InstantFireStartTrace();
        TurretFireTarget = GetAdjustedAim(TurretFireLocation);
        CoolDownTime[ECS_Turret] = 0.f;
        AttackFlag[ECS_Turret] = 0;
        SetTimer( TurretDelayTime, false, nameof(TimeTurretAttacking) );
    }
}

//---------------------------------------------------------
// Missile
//---------------------------------------------------------
simulated function TimeMissleAttacking()
{
    if ( Role == Role_Authority )
    {
        if( !IsTimerActive('DoMissileAttack') )
        {
            SetTimer( MissileFireInterval, true, nameof(DoMissileAttack) );
        }
    }
}

reliable client function  ClientSetMissileCount( int Count )
{
    MissileCount = Count;
}

simulated function DoMissileAttack()
{
    --MissileCount;
    ClientSetMissileCount(MissileCount);
    SpwanMissile();
}

simulated function  SpwanMissile()
{
    local Projectile    SpawnedProjectile;
    local vector RandValue;
    local float SpawnRange;

    SpawnRange = (MissileCount%7==0)? MissileAttackRange*0.1 : MissileAttackRange;

    // Spawn projectile
    RandValue.X = RandRange( -SpawnRange, SpawnRange);
    RandValue.Y = RandRange( -SpawnRange, SpawnRange);
    RandValue.Z = 0;

    RandValue = MissileSpawnPosition + RandValue;
    SpawnedProjectile = Spawn(MissileProjectiles,,, RandValue);
    if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
    {
        SpawnedProjectile.Init( MissileSpawnDirection );
    }
}

simulated function TestFinishMissileAttack()
{

   if ( MissileCount <= 0 )
   {
       if (IsTimerActive('DoMissileAttack'))
       {
          ClearTimer('DoMissileAttack');
       }
       MissileCount = default.MissileCount;
       ClientSetMissileCount(MissileCount);
   }

   if ( MissileCount == default.MissileCount && CoolDownTime[ECS_Missiles] == default.CoolDownTime[ECS_Missiles] && AttackFlag[ECS_Missiles] == 0 )
   {
       AttackFlag[ECS_Missiles] = 1;
       ClientSetAttackFlag( ECS_Missiles, 1 );

   }
}


simulated state WeaponMissiles
{
    simulated event BeginState(Name PrevStateName)
    {
       ;
    }
    simulated event EndState(Name NextStateName)
    {
        if ( !bCanAttack )
           return;
        MissileFire();
    }
    simulated function MissileFire()
    {
        local vector StartTrace, EndTrace;
        local Actor  ImpactActor;
        local vector HitLocation, HitNormal;

        StartTrace = InstantFireStartTrace();
        EndTrace = InstantFireEndTrace(StartTrace);
        ImpactActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace, true, , ,TRACEFLAG_Bullet);
        if ( ImpactActor != none )
        {
            MissileSpawnPosition = StartTrace;
            MissileSpawnPosition.Z += MissileAttackOffset;
            MissileSpawnDirection = Normal(HitLocation - MissileSpawnPosition);
            CoolDownTime[ECS_Missiles] = 0.f;
            AttackFlag[ECS_Missiles] = 0;
            SetTimer( MissileDelayTime, false, nameof(TimeMissleAttacking) );
        }
    }
}



simulated function  SpwanTrackMissile()
{
    local HDProj_TrackMissile   SpawnedProjectile;
    SpawnedProjectile = HDProj_TrackMissile(Spawn(TrackMissileProjectiles,,, TrackMissileSpawnPosition));
    if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
    {
        SpawnedProjectile.Init( TrackMissileSpawnDirection );
        SpawnedProjectile.TrackTarget = HitImpactInfo.HitActor;
    }

}


simulated function TimeTrackMissileAttacking()
{
    SpwanTrackMissile();
    LastTrackTarget = None;
}

simulated function TestTargetLocker( float DeltaTime );

simulated function TestFinishTrackMissile()
{
   if ( CoolDownTime[ECS_TrackMissile] == default.CoolDownTime[ECS_TrackMissile] )
   {
       AttackFlag[ECS_TrackMissile] = 1;
   }
}

state WeaponTrackMissile
{
    simulated function SelectAttackZone()
    {
        local vector StartTrace, EndTrace;
        local vector HitLocation, HitNormal;
        local rotator HitRotator;
        local float distance;

        StartTrace = InstantFireStartTrace();
        EndTrace = InstantFireEndTrace(StartTrace);
        HitImpactInfo = CalcWeaponFire(StartTrace, EndTrace);
        if ( HitImpactInfo.HitActor != NONE )
        {
            distance = VSizeSq( HitImpactInfo.HitLocation - StartTrace );
            if ( distance < MaxAttackDistance * MaxAttackDistance && distance > MinAttackDistance * MinAttackDistance )
            {
                HitLocation = HitImpactInfo.HitLocation;
                HitNormal = HitImpactInfo.HitNormal;
                EM_SelectedPoint.ParticleSystemComponent.SetActive(TRUE);
                EM_SelectedPoint.SetLocation(HitLocation);
                HitRotator =  rotator(HitNormal) + rot(-16384,0,0);
                EM_SelectedPoint.SetRotation(HitRotator);
                bCanAttack = TRUE;
                return;
            }
        }
        EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
        bCanAttack = FALSE;
    }

    simulated event BeginState(Name PrevStateName)
    {
        LastTrackTarget = HitImpactInfo.HitActor;
        TrackLockTime = default.TrackLockTime;
        bLockFlag = False;
    }
    simulated function TestTargetLocker( float DeltaTime )
    {
        if ( bLockFlag ) return;

        if ( HitImpactInfo.HitActor != None && LastTrackTarget == HitImpactInfo.HitActor )
        {
            TrackLockTime -= DeltaTime;
        }
        else
        {
            TrackLockTime = default.TrackLockTime;
            LastTrackTarget = HitImpactInfo.HitActor;
        }

        if ( TrackLockTime <= 0.f )
        {
            TrackLockTime = 0.f;
            bLockFlag = True;
        }
    }

    simulated event EndState(Name NextStateName)
    {
        if ( !bCanAttack )
           return;
        if ( bLockFlag && HitImpactInfo.HitActor != None && (!HitImpactInfo.HitActor.bWorldGeometry || !HitImpactInfo.HitActor.bStatic) && !HitImpactInfo.HitActor.bDeleteMe )
        {
            AttackFlag[ECS_TrackMissile]=0;
            CoolDownTime[ECS_TrackMissile]=0;
            TrackMissileSpawnPosition = Instigator.Location;
            TrackMissileSpawnPosition.Z += TrackMissileAttackOffset;
            TrackMissileSpawnDirection = Normal(HitImpactInfo.HitActor.Location - TrackMissileSpawnPosition);
            SetTimer( TrackMissileDelayTime, false, nameof(TimeTrackMissileAttacking) );
        }
    }
}

function TestSatelliteLocker( float DeltaTime );

simulated function DoSatelliteAttack()
{
    SpawnSatelliteMissile();
    bSatelliteMode = False;
}

simulated function  SpawnSatelliteMissile()
{
    local Projectile    SpawnedProjectile;
    local vector        SpawnLocation;
    SpawnLocation = SatelliteCamera.Location;
    SpawnLocation.Z += 200;
    SpawnedProjectile = Spawn(SatelliteMissile,,, SpawnLocation);
    if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
    {
        SpawnedProjectile.Init( Vect(0,0,-1) );
    }
}

simulated function TestFinishSatellite()
{
   if ( CoolDownTime[ECS_Satellite] == default.CoolDownTime[ECS_Satellite] )
   {
       AttackFlag[ECS_Satellite] = 1;
   }
}

state WeaponSatellite
{
    simulated event BeginState(Name PrevStateName)
    {
        local vector StartTrace, EndTrace;
        local vector HitLocation, HitNormal;
        local HDPlayerController HDPC;
        local Actor HitActor;

        StartTrace = InstantFireStartTrace();
        EndTrace = InstantFireEndTrace(StartTrace);
        HitActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace, true, , ,TRACEFLAG_Bullet);
        if ( HitActor != none )
        {
            bSatelliteTrace = True;
            HitLocation.Z += SatelliteOffset;
            SatelliteCamera.SetLocation(HitLocation);
            SatelliteCamera.SetRotation(rot(-16384,0,0));
            SatelliteTime = SatelliteOffset / SatelliteMissileSpeed;
            HDPC = HDPlayerController(Instigator.Controller);
            if ( HDPC != None )
            {
                HDPC.SetViewTarget(SatelliteCamera);
                DefaultFOV = HDPC.FOVAngle;
                HDPC.SetFOV(SatelliteCameraFOV);
                bSatelliteMode = True;
            }
        }
    }

    simulated event EndState(Name NextStateName)
    {
        local HDPlayerController HDPC;
        if ( !bCanAttack )
            return;
        HDPC = HDPlayerController(Instigator.Controller);
        if ( bSatelliteTrace )
        {
            if ( HDPC != None )
            {
                HDPC.SetViewTarget(Instigator);
                HDPC.SetFOV(WeaponFOV);
            }
            AttackFlag[ECS_Satellite]=0;
            CoolDownTime[ECS_Satellite]=0;
            SetTimer( SatelliteDelayTime, false, nameof(DoSatelliteAttack) );
        }
        bSatelliteTrace = False;
    }

    simulated function TestSatelliteLocker( float DeltaTime )
    {
        local vector CameraLocation;

        if ( SatelliteTime > 0.f )
        {
            SatelliteTime -= DeltaTime;
            CameraLocation = SatelliteCamera.Location;
            CameraLocation.Z -= DeltaTime * SatelliteMissileSpeed;
            SatelliteCamera.SetLocation(CameraLocation);
        }
        else
        {
            GotoState('Active');
        }
    }
}

simulated function DrawZoomedOverlay( HUD H )
{
    local float TargetScale;
    local float OldOrgX, OldOrgY, OldClipX, OldClipY;
    local HDHUD HUD;
    local Font OldFont;
    local int index, StateIndex;

    HUD = HDHUD(H);
    if ( HUD == none ) return;

    // the sniper overlay is a special case that we want to ignore the safe region
    OldFont = H.Canvas.Font;
    OldOrgX = H.Canvas.OrgX;
    OldOrgY = H.Canvas.OrgY;
    OldClipX = H.Canvas.ClipX;
    OldClipY = H.Canvas.ClipY;
    H.Canvas.OrgX = 0.0;
    H.Canvas.OrgY = 0.0;
    H.Canvas.ClipX = H.Canvas.SizeX;
    H.Canvas.ClipY = H.Canvas.SizeY;

    H.Canvas.SetDrawColor(255,255,255);

    // draw hud
    H.Canvas.SetPos(0, 0 );
    H.Canvas.DrawMaterialTile( HudMaterial, H.Canvas.ClipX, H.Canvas.ClipY, 0, 0, 1, 1 );
    TargetScale = H.Canvas.ClipX / 1024;
    // draw track time
    if ( CurrentCSFM == ECS_TrackMissile && IsInState('WeaponTrackMissile'))
    {
        H.Canvas.SetPos( H.Canvas.ClipX*0.5 + 16*TargetScale, H.Canvas.ClipY*0.5);
        H.Canvas.Font = HUD.HUDFont;
        H.Canvas.DrawText(""$TrackLockTime, true, 0.5, 0.5, HUD.TextRenderInfo);
    }

    // draw fire mode name
    for ( index = 0; index < ECS_TrackMissile+1; ++index )
    {
        H.Canvas.SetPos(0, 0);
        StateIndex = (index == CurrentCSFM) ? 0:1;
        if ( AttackFlag[index] == 0 || CoolDownTime[index] < default.CoolDownTime[index] )
        {
            StateIndex = 2;
        }
        WeaponNameShowInstance[index].SetScalarParameterValue('WeaponState', StateIndex);
        H.Canvas.DrawMaterialTile( WeaponNameShowInstance[index], H.Canvas.ClipX, 128*H.Canvas.ClipY/1024, 0, 0, 1, 1 );
    }
    // restore the canvas parameters
    H.Canvas.OrgX = OldOrgX;
    H.Canvas.OrgY = OldOrgY;
    H.Canvas.ClipX = OldClipX;
    H.Canvas.ClipY = OldClipY;
    H.Canvas.Font = OldFont;
}

simulated function DrawSatelliteOverlay( Hud H )
{
    local float OldOrgX, OldOrgY, OldClipX, OldClipY;

    // the sniper overlay is a special case that we want to ignore the safe region
    OldOrgX = H.Canvas.OrgX;
    OldOrgY = H.Canvas.OrgY;
    OldClipX = H.Canvas.ClipX;
    OldClipY = H.Canvas.ClipY;
    H.Canvas.OrgX = 0.0;
    H.Canvas.OrgY = 0.0;
    H.Canvas.ClipX = H.Canvas.SizeX;
    H.Canvas.ClipY = H.Canvas.SizeY;

    H.Canvas.SetDrawColor(255,255,255);
    // draw hud
    H.Canvas.SetPos(0,0);
    H.Canvas.DrawMaterialTile( SatelliteHUD, H.Canvas.ClipX, H.Canvas.ClipY, 0, 0, 1, 1 );

    // restore the canvas parameters
    H.Canvas.OrgX = OldOrgX;
    H.Canvas.OrgY = OldOrgY;
    H.Canvas.ClipX = OldClipX;
    H.Canvas.ClipY = OldClipY;
}


simulated function DrawWeaponCrosshair( Hud HUD )
{
    if ( bDisplayCrosshair )
    {
        if ( !bSatelliteMode )
            DrawZoomedOverlay(HUD);
        else
            DrawSatelliteOverlay(HUD);
    }
}

reliable client function ClientSetAttackFlag( ECSFireMode type, byte flag )
{
    AttackFlag[type] = flag;
}

simulated function TestFinishTurretAttack()
{
   if ( TurretFireCount <= 0 )
   {
       if (IsTimerActive('DoTurretAttack'))
       {
          ClearTimer('DoTurretAttack');
       }
       TurretFireCount = default.TurretFireCount;
       ClientSetTurretFireCount(TurretFireCount);
   }

   if ( TurretFireCount == default.TurretFireCount && CoolDownTime[ECS_Turret] == default.CoolDownTime[ECS_Turret] && AttackFlag[ECS_Turret] == 0 )
   {
       AttackFlag[ECS_Turret] = 1;
       ClientSetAttackFlag( ECS_Turret, 1 );
   }
}

simulated event PostBeginPlay()
{
    local int index;
    Super.PostBeginPlay();

    if ( SatelliteCamera == None )
    {
        SatelliteCamera = Spawn( class'Camera', self );
    }

    for ( index = 0; index < 4; ++index )
    {
        if ( WeaponNameShow[index] != None )
        {
            WeaponNameShowInstance[index] = new(Self) class'MaterialInstanceConstant';
            WeaponNameShowInstance[index].SetParent(WeaponNameShow[index]);
        }
    }
    // initialize flag
    AttackFlag[0]=1;
    AttackFlag[1]=1;
    AttackFlag[2]=1;
    AttackFlag[3]=1;

    if ( EM_SelectedPoint == none )
    {
        EM_SelectedPoint = Spawn(class'TMEmitter',Instigator,, Location);
        EM_SelectedPoint.LifeSpan = 0;
        EM_SelectedPoint.SetOnlyOwnerSee(TRUE);
        EM_SelectedPoint.SetTemplate(PS_SelectedZone);
        EM_SelectedPoint.ParticleSystemComponent.ActivateSystem();
        EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
    }

}

simulated event Destroyed()
{
    local HDPlayerController HDPC;

    if ( EM_SelectedPoint != none )
    {
        EM_SelectedPoint.Destroy();
        EM_SelectedPoint = none;
    }

    if ( SatelliteCamera != None )
    {
        SatelliteCamera.Destroy();
        SatelliteCamera = None;
    }

    HDPC = HDPlayerController(Instigator.Controller);

    if ( HDPC != None )
    {
        ExitCurrentWeaponMode();
        HDPC.SwitchConventionalWeapon(0);
        HDHUD(HDPC.myHUD).myGFxHUD.CloseTipText();
    }

    Super.Destroyed();
}

reliable client function ClientSetCoolDownTime( int index )
{
    CoolDownTime[index] = default.CoolDownTime[index];
}
simulated function CoolDownWeapon( float DeltaTime )
{
    local int index;
    for ( index = 0; index < 4; ++index )
    {
        if ( CoolDownTime[index] < default.CoolDownTime[index] )
        {
            CoolDownTime[index] += DeltaTime;
            CoolDownTime[index] = FClamp( CoolDownTime[index], 0, default.CoolDownTime[index] );
            if ( CoolDownTime[index] == default.CoolDownTime[index] )
            {
                ClientSetCoolDownTime(index);
            }
        }
    }
}
simulated event Tick( float DeltaTime )
{
    super.Tick(DeltaTime);
    SelectAttackZone();
    // cool down recover
    // only execute on server
    if ( ROLE == ROLE_Authority )
    {
       CoolDownWeapon( DeltaTime );
       TestFinishTurretAttack();
       TestFinishMissileAttack();
       TestTargetLocker( DeltaTime );
       TestFinishTrackMissile();
       TestSatelliteLocker( DeltaTime );
       TestFinishSatellite();
    }
}

