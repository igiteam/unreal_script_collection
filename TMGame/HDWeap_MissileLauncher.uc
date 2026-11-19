//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_MissileLauncher extends HDWeap_Launcher
    abstract;

var()   float               TrackLockTime;
var transient Actor         LastTrackTarget;
var transient Actor         TrackTarget;
var transient bool          bLockFlag;
var transient bool          bDoLockAction;
var transient int           LogIndex;
var array<String>           InfoLogs;
var()   float               DrawLogTime;

reliable server function ServerLauncherMissile()
{
    LauncherMissile();
}

simulated function LauncherMissile()
{
    FireAmmunition();
    TimeWeaponFiring( CurrentFireModeType );
    bDoLockAction = False;
    bLockFlag = False;
    TrackTarget = None;
}

simulated function StopFire(byte FireModeNum)
{
   	// clear pending fire first;
    Super.StopFire(FireModeNum);

    if ( !IsInState('WeaponFiring') )
        return;

    if ( bLockFlag && TrackTarget != None && (!TrackTarget.bWorldGeometry || !TrackTarget.bStatic) && !TrackTarget.bDeleteMe )
    {
        if ( ROLE < ROLE_Authority )
        {
            ServerLauncherMissile();
        }
        LauncherMissile();
    }
    else if ( ZoomState == ZST_Zoomed )
    {
        SetInfoLog(0);
        HandleFinishedFiring();
    }
}

simulated function DrawMissileLauncher( Hud H )
{
	local float TargetScale;
	local float OldOrgX, OldOrgY, OldClipX, OldClipY;
    local Font OldFont;
    local Color FontColor;
    local HDHUD HUD;
    local float XL, YL;

    if ( DrawLogTime <= 0.f ) return;

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

    TargetScale = H.Canvas.ClipX / 1024;

    H.Canvas.Font=HUD.ChineseFont;
    H.Canvas.StrLen(InfoLogs[LogIndex], XL, YL );

    H.Canvas.SetPos( H.Canvas.ClipX*0.5 - XL*0.5*TargetScale, H.Canvas.ClipY*0.3);
    FontColor = HUD.LightGoldColor;
    FontColor.B = 255*(Sin(20*WorldInfo.TimeSeconds) + 1) * 0.5;
    FontColor.G = 255*(Sin(20*WorldInfo.TimeSeconds) + 1) * 0.5;
    FontColor.R = 200;
    H.Canvas.DrawColor = FontColor;
    H.Canvas.DrawText(InfoLogs[LogIndex], true, 1.0, 1.0, HUD.TextRenderInfo);

   	// restore the canvas parameters
	H.Canvas.OrgX = OldOrgX;
	H.Canvas.OrgY = OldOrgY;
	H.Canvas.ClipX = OldClipX;
	H.Canvas.ClipY = OldClipY;
	H.Canvas.Font = OldFont;
}
simulated function DrawWeaponCrosshair( Hud HUD )
{
	Super.DrawWeaponCrosshair(HUD);
	DrawMissileLauncher(HUD);
}
simulated function TestTargetLocker( float DeltaTime );
simulated function LockTarget();

simulated function SetInfoLog( int index )
{
    if ( index < InfoLogs.Length )
    {
        LogIndex = index;
        DrawLogTime = default.DrawLogTime;
    }
}
simulated function TestInfoLog( float DeltaTime )
{
    if ( DrawLogTime > 0.f )
    {
        DrawLogTime -= DeltaTime;
    }
    if ( DrawLogTime < 0.f )
    {
        DrawLogTime = 0.f;
    }
}

simulated function Projectile ProjectileFire()
{
	local HDProj_BaseMissile	SpawnedProjectile;
	local Projectile            BaseProj;
   	BaseProj = Super.ProjectileFire();
	if( Role == ROLE_Authority )
	{
    	SpawnedProjectile = HDProj_BaseMissile(BaseProj);
    	if ( SpawnedProjectile != None )
    	{
    	   SpawnedProjectile.TrackTarget = TrackTarget;
    	   TrackTarget = None;
    	}
    }
	return BaseProj;
}

simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
	local rotator ret;
    local PlayerController PlayerCtrl;

    if ( ZoomState != ZST_Zoomed )
        return super.GetAdjustedAim(StartFireLoc);

    ret = super(TMWeapon).GetAdjustedAim(StartFireLoc);
    PlayerCtrl = PlayerController(Instigator.Controller);
    if ( PlayerCtrl != none )
    {
        ret = Telescope.CalculateZoomTrace(ret);
    }
    return ret;
}

simulated state WeaponFiring
{
	ignores WeaponSprintOut, WeaponSprintIn;
    simulated function LockTarget()
    {
        local vector StartTrace, EndTrace;
        local vector HitLocation, HitNormal;
        StartTrace = InstantFireStartTrace();
        EndTrace = InstantFireEndTrace(StartTrace);
        TrackTarget = Trace( HitLocation, HitNormal, EndTrace, StartTrace, true, vect(5,5,5), ,TRACEFLAG_Bullet);
    }

    simulated function TestTargetLocker( float DeltaTime )
    {
 	    if ( bLockFlag ) return;
        if ( !bDoLockAction ) return;

        LockTarget();
        if ( TrackTarget != None && LastTrackTarget == TrackTarget )
	    {
	        TrackLockTime -= DeltaTime;
	    }
	    else
	    {
	        TrackLockTime = default.TrackLockTime;
	        LastTrackTarget = TrackTarget;
	    }

	    if ( TrackLockTime <= 0.f )
	    {
	        TrackLockTime = default.TrackLockTime;
	        bLockFlag = True;
	    }
    }

	simulated function BeginState(Name PrevStateName)
	{
		bLockFlag = False;
		TrackLockTime = default.TrackLockTime;
		bDoLockAction = True;
        if ( ZoomState < ZST_ZoomingIn )
		{
		  SetInfoLog(1);
		  GotoState('Active');
		  return;
		}
		LockTarget();
		SetInfoLog(3);
		LastTrackTarget = TrackTarget;
	}

    simulated event EndState( Name NextStateName )
	{
        //local HDProj_BaseMissile Missile;
        ClearTimer('RefireCheckTimer');
		//TriFireCount = 0;
        bLockFlag = False;
        TrackTarget = None;
	}
}

simulated event Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);
    TestTargetLocker(DeltaTime);
    TestInfoLog(DeltaTime);
    if ( TrackTarget != None && bLockFlag )
    {
        SetInfoLog(2);
    }
}

simulated event PostBeginPlay()
{
    Super.PostBeginPlay();
    DrawLogTime = 0.f;
}

simulated state WeaponEquipping
{
    simulated function BeginState(Name PrevStateName)
    {
        Super.BeginState(PrevStateName);
        DrawLogTime = 0.f;
    }
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(Name PrevStateName)
    {
        Super.BeginState(PrevStateName);
        DrawLogTime = 0.f;
        TrackTarget = None;
    }
}

