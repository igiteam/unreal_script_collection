//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_RifleM16A4_ACOG extends HDWeap_RifleM16A4;

var editinline export HDTelescope                     Telescope;
var vector  TempEndTrace;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    Telescope.Owner = Self;
}

simulated function vector InstantFireStartTrace()
{
	return GetPhysicalFireStartLoc();
}

simulated function DrawWeaponCrosshair( Hud HUD )
{
	if ( ZoomState != ZST_Zoomed )
	{
	   Super.DrawWeaponCrosshair(HUD);
	   return;
	}
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
    Super.LeaveZoom(bFastLeave);
}

simulated function UpdateCameraBreath( out rotator out_CamRot )
{
    if ( ZoomState == ZST_Zoomed )
    {
        Telescope.UpdateCameraBreath( out_CamRot );
    }
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

simulated function ShakeView()
{
    if ( ZoomState == ZST_Zoomed )
    {
        Super.ShakeView();
    }
    return;
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

simulated function FireAmmunition()
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
    Super.FireAmmunition();
}


