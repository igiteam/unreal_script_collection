//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeapon_CommandSystem extends HDSpecialWeapon;

var ParticleSystem					        PS_SelectedZone[2];
var Emitter             			        EM_SelectedPoint;
var transient bool                          bAttackFlag;
var transient bool                          bDoFiring;
var Camera                                  SatelliteCamera;
var(Satellite) float                        SatelliteDelayTime;
var(Satellite) float                        SatelliteVMaxOffset;
var(Satellite) float                        SatelliteVMinOffset;
var(Satellite) float                        SatelliteFOVSpeed;
var(Satellite) float                        SatelliteFOVDiff;
var(Satellite) float                        SatelliteCameraFOV;
var(Satellite) float                        SatelliteHOffset;
var transient  float                        DefaultFOV;
var transient bool                          bSatelliteTrace;
var MaterialInstanceConstant                SatelliteHUD;
var transient vector                        SatelliteInitLocation;

var ParticleSystem                          PS_LaserEffect[2];
var Emitter                                 EM_LaserEffect;
var vector                                  LaserEffectLocation;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if ( EM_SelectedPoint == none )
    {
		EM_SelectedPoint = Spawn(class'TMEmitter',Self,, Location);
		EM_SelectedPoint.LifeSpan = 0;
		EM_SelectedPoint.SetOnlyOwnerSee(TRUE);

        if ( Role == ROLE_Authority && Instigator != None )
        {
            EM_SelectedPoint.SetTemplate(PS_SelectedZone[Instigator.GetTeam().TeamIndex]);
            EM_SelectedPoint.ParticleSystemComponent.ActivateSystem();
		    EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
		}
    }

    if ( SatelliteCamera == None )
    {
        SatelliteCamera = Spawn( class'Camera', self );
        SatelliteCamera.CamOverridePostProcessAlpha = 1.0f;
    }

    if ( EM_LaserEffect == None )
    {
		EM_LaserEffect = Spawn(class'TMEmitter',Self,, Location);
		EM_LaserEffect.LifeSpan = 0;
		EM_LaserEffect.SetOnlyOwnerSee(FALSE);

        if ( Role == ROLE_Authority && Instigator != None )
        {
            EM_LaserEffect.SetTemplate(PS_LaserEffect[Instigator.GetTeam().TeamIndex]);
            EM_LaserEffect.ParticleSystemComponent.ActivateSystem();
	   	    EM_LaserEffect.ParticleSystemComponent.SetActive(FALSE);
	   	}
    }
}

simulated function ResetCommandSystem()
{
    local int index;
    local TeamInfo info;

    if (IsTimerActive('ResetCommandSystem'))
        ClearTimer('ResetCommandSystem');

    info = Instigator.GetTeam();

    if ( info == None )
    {
        SetTimer( 0.1, false, 'ResetCommandSystem' );
        return;
    }

    index = info.TeamIndex;

    if ( EM_SelectedPoint != None )
    {
        EM_SelectedPoint.SetTemplate(PS_SelectedZone[index]);
        EM_SelectedPoint.ParticleSystemComponent.ActivateSystem();
	    EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
	}
    if ( EM_LaserEffect != None )
    {
        EM_LaserEffect.SetTemplate(PS_LaserEffect[index]);
        EM_LaserEffect.ParticleSystemComponent.ActivateSystem();
  	    EM_LaserEffect.ParticleSystemComponent.SetActive(FALSE);
  	}
}

reliable client function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
    local TeamInfo info;

    Super.ClientGivenTo( NewOwner, bDoNotActivate );

    info = Instigator.GetTeam();
    if ( info == None )
    {
        SetTimer( 0.1, false, 'ResetCommandSystem' );
        return;
    }

    ResetCommandSystem();
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

    if ( EM_LaserEffect != None )
    {
        EM_LaserEffect.Destroy();
        EM_LaserEffect = None;
    }

    HDPC = HDPlayerController(Instigator.Controller);
    if ( HDPC != None )
    {
        ExitCurrentWeaponMode();
        //HDPC.SwitchConventionalWeapon(0);
    }
    Super.Destroyed();
}


simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
    return super(TMWeapon).GetAdjustedAim(StartFireLoc);
}

simulated event Tick( float DeltaTime )
{
	super.Tick(DeltaTime);
    SelectAttackZone();
}

simulated function SelectAttackZone();

simulated state Active
{
    simulated function SelectAttackZone()
    {
       	local vector StartTrace, EndTrace;
	    local ImpactInfo	RealImpact;
	    local vector HitLocation, HitNormal;
	    local rotator HitRotator;

	    if ( bDoFiring )
        {
            EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
            return;
        }

        StartTrace = InstantFireStartTrace();
    	EndTrace = InstantFireEndTrace(StartTrace);
    	RealImpact = CalcWeaponFire(StartTrace, EndTrace);
    	if ( RealImpact.HitActor != NONE )
    	{
            //DrawDebugLine( StartTrace, EndTrace, 255,0,0, FALSE );
            HitLocation = RealImpact.HitLocation;
            HitNormal = RealImpact.HitNormal;
            EM_SelectedPoint.ParticleSystemComponent.SetActive(TRUE);
            EM_SelectedPoint.SetLocation(HitLocation);
            HitRotator =  rotator(HitNormal) + rot(-16384,0,0);
            EM_SelectedPoint.SetRotation(HitRotator);
            bAttackFlag = TRUE;
        }
        else
        {
            EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
            bAttackFlag = FALSE;
        }

    }
    simulated function BeginFire(byte FireModeNum)
	{
		if ( !bAttackFlag )
			return;

		if( !bDeleteMe && Instigator != None )
		{
			Global.BeginFire(FireModeNum);
			// in the active state, fire right away if we have the ammunition
			if( PendingFire(FireModeNum) && HasAmmo(FireModeNum) )
			{
				SendToFiringState(FireModeNum);
			}
		}
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
    simulated function BeginState(name PreviousStateName)
    {
         ExitCurrentWeaponMode();
         Super.BeginState(PreviousStateName);
         EM_SelectedPoint.ParticleSystemComponent.SetActive(FALSE);
    }
}


/**
 * Called on the LocalPlayer, Fire sends the shoot request to the server (ServerStartFire)
 * and them simulates the firing effects locally.
 * Call path: PlayerController::StartFire -> Pawn::StartFire -> InventoryManager::StartFire
 * Network: LocalPlayer
 */
simulated function StartFire(byte FireModeNum)
{
	if( Instigator == None || !Instigator.bNoWeaponFiring )
	{
		// Start fire locally
		BeginFire(FireModeNum);
	}
}

/**
 * This initiates the shutdown of a weapon that is firing.
 * Network: Local Player
 */

simulated function StopFire(byte FireModeNum)
{
	// Locally shut down the fire sequence
	EndFire(FireModeNum);
	if ( GetStateName() == 'WeaponFiring')
        GotoState('Active');
}

simulated function ChangeZoomFunction( bool bUp );

state WeaponFiring
{
	simulated event BeginState(Name PrevStateName)
	{
        local vector StartTrace, EndTrace;
        local vector HitLocation, HitNormal;
        local HDPlayerController HDPC;
        local Actor HitActor;
        local HDTeamHud TeamHud;

        StartTrace = InstantFireStartTrace();
        EndTrace = InstantFireEndTrace(StartTrace);
        HitActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace, true, , ,TRACEFLAG_Bullet);
        if ( HitActor != none )
        {
            bSatelliteTrace = True;
            HitLocation.Z = SatelliteVMaxOffset;
            SatelliteInitLocation = HitLocation;
            SatelliteCamera.SetLocation(SatelliteInitLocation);
            SatelliteCamera.SetRotation(rot(-16384,0,0));
            HDPC = HDPlayerController(Instigator.Controller);
            if ( HDPC != None )
            {
                HDPC.SetViewTarget(SatelliteCamera);
                DefaultFOV = HDPC.FOVAngle;
                HDPC.SetFOV(SatelliteCameraFOV);
                HDPC.SetOrthoMode(True);
            }
            FireAmmunition();
        }

        TeamHud = HDTEAMHUD(HDPC.myHUD);
        if ( TeamHud != None )
            TeamHUD.SetPawnNameVisible(True);

        SetLaserEffectActive(True);

        //HDPawn_MP(Instigator).SetCommandSystem(True);

        SetTimer( 0.5, true, 'UpdateLaserEffectLocation' );
	}

    simulated event EndState(Name NextStateName)
	{
	    local HDPlayerController HDPC;
	    local HDTeamHud TeamHud;

        HDPC = HDPlayerController(Instigator.Controller);
        if ( bSatelliteTrace )
        {
            if ( HDPC != None )
            {
                HDPC.SetOrthoMode(False);
                HDPC.SetViewTarget(Instigator);
                HDPC.SetFOV(DefaultFOV);
            }
        }
        bSatelliteTrace = False;

        TeamHud = HDTEAMHUD(HDPC.myHUD);
        if ( TeamHud != None )
            TeamHUD.SetPawnNameVisible(False);

        SetLaserEffectActive(False);

        //HDPawn_MP(Instigator).SetCommandSystem(False);

        ClearTimer('UpdateLaserEffectLocation');
	}


    simulated function DrawWeaponCrosshair( Hud HUD )
    {
        DrawSatelliteOverlay(HUD);
    }


    simulated function ChangeZoomFunction( bool bUp )
    {
         local float value;
         local TMPlayerController PC;
         PC = TMPlayerController(Instigator.Controller);
         value = PC.FOVAngle;

         if ( bUp )
            value -= SatelliteFOVDiff;
         else
            value += SatelliteFOVDiff;

         value = FClamp( value, 10, SatelliteCameraFOV );
         PC.StartZoomNonlinear( value, SatelliteFOVSpeed );
    }

    simulated function CustomFire();

    simulated event Tick( float DeltaTime )
    {
        DrawLaserEffect();
        Global.Tick(DeltaTime);
    }

    simulated function DrawLaserEffect()
    {
        local vector StartTrace, EndTrace;
        local vector HitLocation, HitNormal;
        local Actor HitActor;

        StartTrace = SatelliteCamera.Location;
        EndTrace = StartTrace + vect(0,0,-1) * 10000;
        HitActor = Trace( HitLocation, HitNormal, EndTrace, StartTrace, true, , ,TRACEFLAG_Bullet);
        if ( HitActor != none )
        {
            EndTrace = HitLocation;
        }

        EM_LaserEffect.SetLocation(EndTrace);

        LaserEffectLocation = EndTrace;
    }

    simulated function UpdateLaserEffectLocation()
    {
        HDPawn_MP(Instigator).SetCommandSystemLocation(LaserEffectLocation);
    }
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

simulated state WeaponEquipping
{
	ignores WeaponSprintIn, WeaponSprintOut,Reload, StartFire, PutDownWeapon, Activate, ToggleGasMask, ToggleNightVision;
	simulated function BeginState(Name PrevStateName)
	{
		local HDPlayerController HDPC;
		HDPC = HDPlayerController(Instigator.Controller);

		Super.BeginState(PrevStateName);

		if ( HDPC != none )
		{
		    HDPC.GotoState('PlayerCommandSystem');
		}
	}
}

// do not switch NV and gasmask
simulated   function bool ToggleNightVision(bool bIsNightVision);
simulated   function bool ToggleGasMask(bool bIsEquip );
simulated   function ToggleMelee();


/**
 * Consumes some of the ammo
 */
simulated function ConsumeAmmo( byte FireModeNum )
{
	// Subtract the Ammo
	if ( bDoFiring == FALSE && bAttackFlag == TRUE )
	{
        AddBulletCount( -ShotCost[FireModeNum], FireModeNum );
    }
}

simulated function vector ClampCameraPosition( vector inPosition )
{
    local vector ret;
    ret = inPosition;
    ret.X = FClamp( ret.X, SatelliteInitLocation.X - SatelliteHOffset, SatelliteInitLocation.X + SatelliteHOffset );
    ret.Y = FClamp( ret.Y, SatelliteInitLocation.Y - SatelliteHOffset, SatelliteInitLocation.Y + SatelliteHOffset );
    return ret;
}

simulated function float ClampCameraZ( bool bUp , float inZ )
{
    local float value;
    value = inZ;
    if ( bUp )
        value -= SatelliteFOVDiff;
    else
        value += SatelliteFOVDiff;

    value = FClamp( value, 2000, 200000 );
    return value;
}


// laser effect
simulated function SetLaserEffectActive( bool bActive )
{
    HDPawn_MP(Instigator).SetCommandSystemActived(bActive);
    EM_LaserEffect.ParticleSystemComponent.SetActive(bActive);
}


