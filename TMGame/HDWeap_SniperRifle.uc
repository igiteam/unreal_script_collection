//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_SniperRifle extends HDConventionalWeapon
    abstract;

// Recoil
var transient	bool	bRecoilFlag;
var transient   vector  RecoilValue;

var const SceneCapture2DComponent		SceneCapture;
var (HUD) MaterialInstanceConstant		TeleScopeInstance;
var transient float						CurrentReflector, DesiredReflector, ReflectorSpeed;


var editinline export HDTelescope                     Telescope;

var vector  TempEndTrace;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    CurrentReflector=0;
	SetDesiredReflector( 1.0, 0 );
    Telescope.Owner = Self;
}

simulated function ToggleZoomPostProcess();

simulated function vector InstantFireStartTrace()
{
	return GetPhysicalFireStartLoc();
}

simulated function DrawWeaponCrosshair( Hud HUD )
{
	Telescope.DrawWeaponCrosshair(HUD);
}

simulated function PreloadTextures(bool bForcePreload)
{
	Super.PreloadTextures(bForcePreload);
    Telescope.PreloadTextures(bForcePreload);
}

simulated function StartZoom(TMPlayerController PC)
{
	local HDPawn HDP;
	HDP = HDPawn(Instigator);
	if (HDP==none)
		return;

//	if ( HDP.bSprintTag )
//		return;

    Super.StartZoom(PC);
    SetZoomedState(ZST_ZoomingIn);  // set zoom state in ChangeHUD
    SetTimer( ZoomTime-0.1f, false, 'ChangeHUD' );
}

simulated function ChangeHUD()
{
	local TMPlayerController PC;
	PC = TMPlayerController(Instigator.Controller);
    if ( Telescope.ZoomFunction == EZF_HUD )
    {
	     bForceHidden = TRUE;
	     Telescope.SetDispalyCrosshair(TRUE);
     	 if ( PC != None )
	     {
	         SyncSetCurrentSceneFOV(PC.DefaultFOV - SceneFOVDiff);
		     PC.StartZoomNonlinear( CurrentSceneFOV, 0 );
	     }
	     SetZoomedState(ZST_Zoomed);
	}
}

simulated function LeaveZoom( optional bool bFastLeave )
{
    if ( Telescope.ZoomFunction == EZF_HUD )
    {
    	if (IsTimerActive('ChangeHUD'))
	    {
		    ClearTimer('ChangeHUD');
	    }
        bForceHidden = FALSE;
        bPendingShow = TRUE;
        Telescope.SetDispalyCrosshair(FALSE);
    }
    SceneFOVDiff = Default.SceneFOVDiff;
	SetDesiredReflector( 1.0, Abs(CurrentReflector-1.0)*2/ZoomTime );
    Super.LeaveZoom(bFastLeave);
}

reliable sync function SyncWeaponStable( bool flag )
{
    if ( ZoomState == ZST_Zoomed )
        Telescope.TelescopeZoomStable(flag);
}
simulated function WeaponStable( bool flag )
{
    SyncWeaponStable(flag);
}


simulated function UpdateCameraBreath( out rotator out_CamRot )
{
    local float cof;
    cof = 1.0f;
    if ( ZoomState == ZST_Zoomed )
    {
        if ( Instigator.bIsCrouched || Instigator.bWantsToCrouch )  cof = 0.5f;
        else if ( Instigator.bIsProne || Instigator.bWantsToProne )  cof = 0.2f;
        Telescope.UpdateCameraBreath( out_CamRot, cof );
    }
}


// Recoil function
simulated function CalculateRecoil()
{
	CalculateRecoilFuncTwo();
}

simulated function RecoverRecoil( float DeltaTime )
{
	RecoverRecoilFuncTwo(DeltaTime);
}

simulated function CalculateRecoilFuncTwo()
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
	if (Rand(7) == 0)
		direction = 1 - direction;
}

simulated function RecoverRecoilFuncTwo( float DeltaTime )
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
		if ( VSize(punch_angle) > 0.0001f && GetStateName() != 'WeaponFiring' )
		{
		    punch_angle.X = FWeaponInterpConstantTo( punch_angle.X, 0, DeltaTime,  RecoilRecoverTime );
		    punch_angle.Y = FWeaponInterpConstantTo( punch_angle.Y, 0, DeltaTime,  RecoilRecoverTime );
		}
	}
}

reliable server function ServerSendEndTrace( vector EndTrace )
{
    TempEndTrace = EndTrace;
}

simulated function vector InstantFireEndTrace(vector StartTrace)
{
	if ( Role == Role_Authority && !Instigator.IsLocallyControlled() )
	{
	   return TempEndTrace;
	}
    return StartTrace + vector(GetAdjustedAim(StartTrace)) * GetTraceRange();
}

simulated function StartFire(byte FireModeNum)
{
	local vector StartTrace, EndTrace;
    if( Instigator == None || !Instigator.bNoWeaponFiring )
	{
		if( Role < Role_Authority )
		{
            StartTrace = InstantFireStartTrace();
            EndTrace = InstantFireEndTrace(StartTrace);
            ServerSendEndTrace(EndTrace);
		}
	}
    Super.StartFire(FireModeNum);
}

simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
	local rotator ret;
    local PlayerController PlayerCtrl;
    local vector FireDir, HitLocation, HitNormal;

    if ( ZoomState != ZST_Zoomed )
        return super.GetAdjustedAim(StartFireLoc);

    ret = super(TMWeapon).GetAdjustedAim(StartFireLoc);

    // calculate hitlocation in client
    if ( Instigator != None  && Instigator.Role == Role_AutonomousProxy )
    {
        FireDir = vector(ret);
        Trace(HitLocation, HitNormal, StartFireLoc + MaxRange() * FireDir, StartFireLoc, true);
        HitLoc = HitLocation;
    }

    PlayerCtrl = PlayerController(Instigator.Controller);
    if ( PlayerCtrl != none )
    {
        ret = Telescope.CalculateZoomTrace(ret);
    }
    return ret;
}

// change Zoom FOV
simulated function Gotozoom()
{
    SceneFOVDiff = Default.SceneFOVDiff;
	SetDesiredReflector( 0.0, Abs(CurrentReflector-0.0)*2/ZoomTime );
}

simulated function ChangeZoomFunction ( bool bUp )
{
  local TMPlayerController PC;

  if ( ZoomState != ZST_Zoomed ) return;

  PC = TMPlayerController(Instigator.Controller);
  if ( PC != None )
  {
    Telescope.ChangeZoomScale( PC, bUp);
  }
}

simulated event Tick(float DeltaTime)
{
//	local vector out_loc;
//	local rotator out_rot;
//	local TMSkeletalMeshComponent SK;
	Super.Tick(DeltaTime);
/*	SK = TMSkeletalMeshComponent(Mesh);
	if ( SK != none && ZoomState == ZST_Zoomed && ZoomFunction == EZF_GUN )
	{
		SK.GetSocketWorldLocationAndRotation('Camera', out_loc, out_rot, 0);
		if ( SceneCapture != None )
		{
		  SceneCapture.SetCaptureParameters(,CurrentZoomFOV * 0.5);
		  SceneCapture.SetView(out_loc, out_rot);
		}
	}
*/
	AdjustHUDReflector(DeltaTime);
}


simulated function SetDesiredReflector( float DesiredValue, float Speed )
{
	DesiredReflector = DesiredValue;
	ReflectorSpeed = Speed;
}

simulated function AdjustHUDReflector( float DeltaTime )
{
	if ( CurrentReflector != DesiredReflector )
	{
		CurrentReflector = FInterpTo( CurrentReflector, DesiredReflector, DeltaTime , ReflectorSpeed );
		//TeleScopeInstance.SetScalarParameterValue('reflector', CurrentReflector );
	}
}

simulated function EndFire(Byte FireModeNum)
{
	Super.EndFire(FireModeNum);
	//bRecoilFlag = false;
}

simulated function ShakeView()
{
    if ( ZoomState == ZST_Zoomed )
    {
        Super.ShakeView();
    }
    return;
}

