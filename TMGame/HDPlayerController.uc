//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDPlayerController extends TGPC
    native(HDGame);

// sprint
var transient   float   LastSprintRecoverTime;
var             float   SprintRecoverTime;
var             bool    bReadySprint;
var             bool    bJumpSprint;

// night vision
var transient float     LastNVTime;
var             float   NVTime;

// gas mask
var transient float   LastGMTime;
var float   GMTime;

// telescope
var transient float LastTSTime;
var float           TSTime;

// action flag
var bool        bZoomEnable;
var bool        bTelescopeEnable;

// walking codec
var int         OldWalkingCodec;

// fire action flag
var transient   bool        bDisableFireAction;

/** Internal.  Returns intensity scalar in the range [0..1] for a shake originating at Epicenter. */
function float CalcRadialShakeScale(vector Epicenter, float InnerRadius, float OuterRadius, float Falloff)
{
    local Vector            POVLoc;
    local Rotator           POVRot;
    local float             DistPct;

    // using camera location so stuff like spectator cameras get shakes applied sensibly as well
    // need to ensure server has reasonably accurate camera position
    GetPlayerViewPoint(POVLoc, POVRot);
//  POVLoc = (Cam.PCOwner.Pawn != None) ? Cam.PCOwner.Pawn.Location : Cam.PCOwner.Location;

    DistPct = (VSize(Epicenter - POVLoc) - InnerRadius) / (OuterRadius - InnerRadius);
    DistPct = 1.f - FClamp(DistPct, 0.f, 1.f);
    return DistPct ** Falloff;;
}


exec function StartFire( optional byte FireModeNum )
{
    if ( ViewTarget != Pawn || bDisableFireAction )
    {
        return;
    }

    Super.StartFire(FireModeNum);
}

exec function StopFire( optional byte FireModeNum )
{
    Super.StopFire(FireModeNum);
}

// Weapon reload
exec function ReloadWeapon()
{
    local HDPawn HDP;
    if ( ViewTarget != Pawn ) return;

    HDP = HDPawn(Pawn);
    if (HDP == none || WorldInfo.Pauser != none)
       return;

    HDP.ReloadWeapon();
    //HDP.Notify_Reload();
}

// pickup
exec function PickupItem()
{
    local HDPawn HDP;
    local HDWeapon HDW;
    if ( ViewTarget != Pawn ) return;
    HDP = HDPawn(Pawn);
    HDW = HDWeapon(Pawn.Weapon);
    if (HDP == none || WorldInfo.Pauser != none || HDW.HDWeaponType == EWEAPON_GRENADE)
       return;
    HDP.PickupItem();
}

//---------------------------------------------------------
// switch weapon
//---------------------------------------------------------
exec function SwitchConventionalWeaponSroll( byte Value )
{
    local HDWeapon HDW;

    if( Pawn == none )  return;

    HDW = HDWeapon(Pawn.Weapon);

    if ( ViewTarget != Pawn ) return;

    if (HDPawn(Pawn) != None && HDW.ZoomState == ZST_NotZoomed && HDW.IsInState('Active') )
        HDPawn(Pawn).SwitchConventionalWeaponSroll( Value );
}

exec function SwitchConventionalWeapon( byte Type )
{
    if ( ViewTarget != Pawn ) return;
    if (HDPawn(Pawn) != None)
        HDPawn(Pawn).SwitchConventionalWeapon( Type );
}

exec function SwitchSpecialWeapon( byte Type )
{
    if ( ViewTarget != Pawn ) return;
    if (HDPawn(Pawn) != None)
        HDPawn(Pawn).SwitchSpecialWeapon(Type);
}

exec function SwitchWeaponFireMode( byte Type )
{
    if ( ViewTarget != Pawn ) return;
    if (HDPawn(Pawn) != None)
        HDPawn(Pawn).SwitchWeaponFireMode( Type );
}

exec function SwitchToLastConventionalWeapon()
{
    if ( ViewTarget != Pawn ) return;
    if (HDPawn(Pawn) != None)
        HDPawn(Pawn).SwitchToLastConventionalWeapon();
}

// switch to grenade
exec function SwitchToGrenade( byte Type )
{
    local HDPawn HDP;
    local HDWeap_Grenade Grenade;
    local HDWeapon Weapon;

    if ( ViewTarget != Pawn ) return;
    HDP = HDPawn(Pawn);
    if ( HDP == none ) return;

    Grenade = HDWeap_Grenade(HDP.Weapon);
    if ( Grenade != none ) return;

    Weapon = HDWeapon(HDP.Weapon);
    if ( Weapon == None ) return;

    if ( Weapon.GetStateName() != 'Active' ) return;

    HDP.SwitchGrenadeWeapon(Type);
}

// throw grenade
exec function ThrowGrenade( byte Type )
{
    local HDPawn HDP;
    HDP = HDPawn(Pawn);
    if ( ViewTarget != Pawn ) return;
    if (HDP == none || WorldInfo.Pauser != none)
       return;
    HDP.ThrowGrenade( Type );
}

auto state PlayerWaiting
{
    ignores ReloadWeapon;
}

state Spectating
{
    ignores ReloadWeapon;
}

    reliable client function ClientAddGrenadeInfo(optional HDProj_GrenadeBase HDG)
    {
        if(HDG != None && myHUD!= None)
            HDHUD(myHUD).myGFxHUD.AddGrenadeInfo(HDG);
    }

    reliable client function ClientRemoveGrenadeInfo(optional HDProj_GrenadeBase HDG)
    {
        if(HDG != None && myHUD!= None)
            HDHUD(myHUD).myGFxHUD.RemoveGrenadeInfo(HDG);
    }

    reliable client function ClientRemoveAllGrenadeInfo()
    {
        if(myHUD!= None)
            HDHUD(myHUD).myGFxHUD.RemoveAllGrenadeInfo();
    }

state Dead
{
    ignores ReloadWeapon;

    exec function StartFire( optional byte FireModeNum )
    {
        if( TGGameSP_Base(WorldInfo.Game) != none)
            return;
        if ( bDisableFireAction )
            return;

        super.StartFire( FireModeNum );  //would call ServerRestartPlayer
    }

    reliable server function ServerRestartPlayer()
    {
        if( TGGameSP_Base(WorldInfo.Game) != none)
        {
            if( WorldInfo.Game.PlayerCanRestart( Self ) )
            {
                TriggerGlobalEventClass(class'HDSeqEvent_BeforePlayerSpawn', self); //Open Loading etc...

                SetTimer(0.5, false, nameof(DelaySpawnTimer));
            }
        }
        else
        {
            Super.ServerRestartPlayer();
        }
    }

    function DelaySpawnTimer()
    {
        super.ServerRestartPlayer();
    }


    function BeginState(Name PreviousStateName)
    {
        super.BeginState(PreviousStateName);

        if( TGGameSP_Base(WorldInfo.Game) != none && IsLocalPlayerController() )
        {
            SetTimer(3.0, false, 'DisplayExitMenu');
        }
        ClientRemoveAllGrenadeInfo();
    }

    function DisplayExitMenu()
    {
        HDHUD(myHUD).ToggleExitMenu(); //show Exit Menu when play0 died
    }

//    function PlayerMove(float DeltaTime)
//    {
//        ViewShake(DeltaTime);
//        if ( Rotation.Roll > 13454 )
//            bUsePhysicsRotation = false;
//    }
}

// player is climbing ladder
state PlayerClimbing
{
    event BeginState(Name PreviousStateName)
    {
        local HDWeapon HDW;
        Super.BeginState(PreviousStateName);
        bDuck = 0;
        bProne = 0;
        HDPawn(Pawn).ShouldCrouchOrProne(false, false);
        HDW = HDWeapon(Pawn.Weapon);
        if ( HDW != None )
            HDW.GotoState('WeaponHidden');
    }

    event EndState(Name NextStateName)
    {
        local HDWeapon HDW;
        Super.EndState(NextStateName);
        HDW = HDWeapon(Pawn.Weapon);
        if ( HDW != None )
            HDW.GotoState('Active');
    }
}

simulated function DoRecoverSprint();

state PlayerWalking
{
  function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
  {
      if ( ViewTarget != Pawn ) return;
      // do not double click
      Super.ProcessMove(DeltaTime, NewAccel, DCLICK_None, DeltaRot);
      CheckSprint();
      ProcessViewRange();
  }

    function PlayerMove( float DeltaTime )
    {
        local HDPawn  HDP;
        local HDPawn_MP HDPMP;
        local bool bIsMoveBackward, bIsMoveStrafe;
        local int NewWalkingCodec;

        if( Pawn == None )
        {
            GotoState('dead');
            return;
        }

        if ( ViewTarget != Pawn )
        {
            Pawn.Acceleration = vect(0,0,0);
            Pawn.Velocity = vect(0,0,0);
            return;
        }
        HDP = HDPawn(Pawn);
        HDPMP = HDPawn_MP(Pawn);
        if ( PlayerInput.aTurn != 0 && HDPMP != None && HDPMP.TestWalkingForwardCollide( PlayerInput.aTurn ) )
        {
            PlayerInput.aForward = -1.0f;  // backward move while colliding wall
        }
        NewWalkingCodec = 0;
        NewWalkingCodec = NewWalkingCodec | (PlayerInput.aForward > 0)? 1 : 0;
        NewWalkingCodec = NewWalkingCodec | (PlayerInput.aForward < 0)? 2 : 0;
        NewWalkingCodec = NewWalkingCodec | (PlayerInput.aStrafe > 0)? 4 : 0;
        NewWalkingCodec = NewWalkingCodec | (PlayerInput.aStrafe < 0)? 8 : 0;

        if ( HDP.bProneZoomStop == True && NewWalkingCodec != OldWalkingCodec )
            HDP.SetProneZoomStopFlag(False);

        Super.PlayerMove(DeltaTime);
        bIsMoveBackward = PlayerInput.aForward < 0;
        bIsMoveStrafe = Abs(PlayerInput.aStrafe) > 0;

        if ( HDP != none )
            HDP.HandlePawnMove( DeltaTime, bIsMoveBackward, bIsMoveStrafe );

        OldWalkingCodec = NewWalkingCodec;
    }

  // check sprint logic
  function CheckSprint()
  {
    local HDPawn HDP;
    HDP = HDPawn(Pawn);
    if( HDP == none ) return;

    if ( HDP.Physics != PHYS_Falling && PlayerInput != none )
    {
        if ( !HDP.bCanSprint )
        {
            bSprint = 0;
        }
        // crouch out sprint
        if ( !HDP.bIsCrouched && HDP.bWantsToCrouch )
        {
            bSprint = 0;
        }
        if ( bSprint !=0 && PlayerInput.aForward == 0.f && !bReadySprint )
        {
            bSprint = 0;
        }
        HDP.DoSprintCheck( bSprint!=0, PlayerInput.aForward >= 1 );
    }
  }

    simulated function DoRecoverSprint()
    {
        if ( bRecoverSprint == 0 && bReadySprint )
        {
            bSprint = 255;
            bJumpSprint = False;
        }
    }
  // process view range
  function ProcessViewRange()
  {
    local HDPawn HDP;
    HDP = HDPawn(Pawn);

    if ( HDP == none ) return;

    HDP.ProcessViewRange();
  }
}

state PlayerTurreting
{
ignores SeePlayer, HearNoise, Bump;

//  unreliable server function TurretServerMove
//  (
//      float   TimeStamp,
//      vector  ClientLoc,
//      bool    NewbDuck,
//      byte    ClientRoll,
//      int     View
//  )
//  {
//      Global.ServerMove(TimeStamp, Vect(0,0,0), ClientLoc, 0, ClientRoll, View);
//  }

    function PlayerMove(float DeltaTime)
    {
        if( Pawn == None )
        {
            GotoState('dead');
            return;
        }

        UpdateRotation( DeltaTime );

        if( Role < ROLE_Authority ) // then save this move and replicate it
        {
            ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
        }
        else
        {
            ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
        }
    }

    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

    function BeginState(Name PreviousStateName)
    {
        Pawn.MaxPitchLimit = 16384; // extending pitch limit (limits network weapon aiming)
        //TriggerGearEventDelegates( eGED_Turret );
    }

    function EndState(Name NextStateName)
    {
        if ( Pawn != None )
        {
            Pawn.MaxPitchLimit = Pawn.default.MaxPitchLimit; // restoring pitch limit
        }
    }

Begin:
}

state PlayerDriving
{
    function PlayerMove( float DeltaTime )
    {
        // update 'looking' rotation
        UpdateVehRotation(DeltaTime);

        // TODO: Don't send things like aForward and aStrafe for gunners who don't need it
        // Only servers can actually do the driving logic.
        ProcessDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump);
        if (Role < ROLE_Authority)
        {
            ServerDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
        }

        bPressedJump = false;
    }
}

function UpdateVehRotation(float DeltaTime)
{
    local Rotator   DeltaRot, newRotation, ViewRotation;

    ViewRotation = Rotation;
    if (Pawn!=none)
    {
        Pawn.SetDesiredRotation(ViewRotation);
    }

    // Calculate Delta to be applied on ViewRotation
    DeltaRot.Yaw    = PlayerInput.aTurn / 5;
    DeltaRot.Pitch  = PlayerInput.aLookUp / 5;

    ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
    SetRotation(ViewRotation);

    ViewShake( deltaTime );

    NewRotation = ViewRotation;
    NewRotation.Roll = Rotation.Roll;

    if ( Pawn != None )
        Pawn.FaceRotation(NewRotation, deltatime);
}

/* CheckJumpOrDuck()
Called by ProcessMove()
handle jump and duck buttons which are pressed
*/
function CheckJumpOrDuck()
{
    local HDPawn HDP;
    if ( ViewTarget != Pawn ) return;
    HDP = HDPawn(Pawn);
    if ( HDP == None )  return;

    if ( bPressedJump )
    {
        HDP.DoJump( bUpdating );
    }
    if ( HDP.Physics != PHYS_Falling/* && (HDP.bCanCrouch||HDP.bCanProne) */)
    {
        // crouch if pressing duck
        HDP.ShouldCrouchOrProne(bDuck != 0, bProne!= 0 );
    }
}

// knife melee
simulated exec function ToggleMelee()
{
    if ( ViewTarget != Pawn ) return;
    if ( HDPawn(Pawn) != none )
    {
        if ( WorldInfo.Pauser == PlayerReplicationInfo )
        {
            SetPause( false );
            return;
        }
        HDPawn(Pawn).ToggleMelee();
    }
}

simulated exec function ToggleNightVision()
{
    if( WorldInfo.NetMode != NM_Standalone ) return;

    if ( ViewTarget != Pawn ) return;
    if ( HDPawn(Pawn) != none )
    {
        if ( WorldInfo.TimeSeconds - LastNVTime > NVTime )
        {
            if ( HDPawn(Pawn).ToggleNightVision() )
                LastNVTime = WorldInfo.TimeSeconds;
        }
    }
}

//---------------------------------------------------------
// telescope
//---------------------------------------------------------
simulated function OnToggleTelescope( HDSeqAct_ToggleTelescope seq )
{
    local HDPawn HDP;
    HDP = HDPawn(Pawn);
    if ( HDP != None )
    {
        if ( (!HDP.IsInState('Telescope') && seq.bToggleTelescope)
            || (HDP.IsInState('Telescope') && !seq.bToggleTelescope) )
        {
            ToggleTelescope();
        }
    }
}

simulated function OnTelescopeEnable( HDSeqAct_TelescopeEnable seq )
{
    bTelescopeEnable = seq.bTelescopeEnable;
}

exec function ToggleTelescope()
{
    if( WorldInfo.NetMode != NM_Standalone ) return;

    if ( ViewTarget != Pawn ) return;

    if ( !bTelescopeEnable ) return;

    if ( HDPawn(Pawn) != none )
    {
        if ( WorldInfo.TimeSeconds - LastTSTime > TSTime )
        {
            if ( HDPawn(Pawn).ToggleTelescope() )
                LastTSTime = WorldInfo.TimeSeconds;
        }
    }
}

simulated exec function ToggleGasMask()
{
    if( WorldInfo.NetMode != NM_Standalone ) return;

    if ( ViewTarget != Pawn ) return;

    if ( HDPawn(Pawn) != none )
    {
        if ( WorldInfo.TimeSeconds - LastGMTime > GMTime )
        {
            if ( HDPawn(Pawn).ToggleGasMask() )
                LastGMTime = WorldInfo.TimeSeconds;
        }
    }
}

function bool FindVehicleToDrive()
{
    local HDPawn HDP;
    local bool ret;
    HDP = HDPawn(Pawn);
    ret = ( CheckTurretToDrive(true) != none );
    if ( ret && HDP != None )
        HDP.ResetPawn();
    return ret;
}

/** Returns vehicle which can be driven
  * @PARAM bEnterVehicle if true then player enters the found vehicle
  */
function TGTurret CheckTurretToDrive(bool bEnterVehicle)
{
    local TGTurret /*V,*/ PickedVehicle;
    local vector ViewDir, HitLocation, HitNormal, ViewPoint;
    local rotator ViewRotation;
    local Actor HitActor;
    local float CheckDist;

    bJustFoundVehicle = false;

    // first try to get in vehicle I'm standing on
//    PickedVehicle = CheckPickedTurret(TGTurret(Pawn.Base), bEnterVehicle);
//    if ( (PickedVehicle != None) || bJustFoundVehicle )
//    {
//        return PickedVehicle;
//    }

    // see if looking at vehicle
    ViewPoint = Pawn.GetPawnViewLocation();
    ViewRotation = Rotation;
    CheckDist = Pawn.VehicleCheckRadius * VehicleCheckRadiusScaling;
    ViewDir = CheckDist * vector(ViewRotation);
    HitActor = Trace(HitLocation, HitNormal, ViewPoint + ViewDir, ViewPoint, true,,,TRACEFLAG_Blocking);

    PickedVehicle = CheckPickedTurret(TGTurret(HitActor), bEnterVehicle);
    if ( (PickedVehicle != None) || bJustFoundVehicle )
    {
        return PickedVehicle;
    }

    // make sure not just looking above vehicle
    ViewRotation.Pitch = 0;
    ViewDir = CheckDist * vector(ViewRotation);
    HitActor = Trace(HitLocation, HitNormal, ViewPoint + ViewDir, ViewPoint, true,,,TRACEFLAG_Blocking);

    PickedVehicle = CheckPickedTurret(TGTurret(HitActor), bEnterVehicle);
    if ( (PickedVehicle != None) || bJustFoundVehicle )
    {
        return PickedVehicle;
    }

    // make sure not just looking above vehicle
    ViewRotation.Pitch = -5000;
    ViewDir = CheckDist * vector(ViewRotation);
    HitActor = Trace(HitLocation, HitNormal, ViewPoint + ViewDir, ViewPoint, true,,,TRACEFLAG_Blocking);

    PickedVehicle = CheckPickedTurret(TGTurret(HitActor), bEnterVehicle);
    if ( (PickedVehicle != None) || bJustFoundVehicle )
    {
        return PickedVehicle;
    }

    // special case for vehicles like Darkwalker
//  if ( TMGame(WorldInfo.Game) != None )
//  {
//      for ( V=TMGame(WorldInfo.Game).VehicleList; V!=None; V=V.NextVehicle )
//      {
//          if ( V.bHasCustomEntryRadius && V.InCustomEntryRadius(Pawn) )
//          {
//              V = CheckPickedVehicle(V, bEnterVehicle);
//              if ( (V != None) || bJustFoundVehicle )
//              {
//                  return V;
//              }
//          }
//      }
//  }

    return None;
}

function TGTurret GetCurrentTurret()
{
    local TGTurret /*V,*/ PickedVehicle;
    local vector ViewDir, HitLocation, HitNormal, ViewPoint;
    local rotator ViewRotation;
    local Actor HitActor;
    local float CheckDist;

    if( Pawn == none )
    {
        return none;
    }

//    if(Pawn.bIsCrouched || Pawn.bIsProne)
//        return none;

    // first try to get in vehicle I'm standing on
//    PickedVehicle = TGTurret(Pawn.Base);
//    if (PickedVehicle != None)
//    {
//        return PickedVehicle;
//    }

    // see if looking at vehicle
    ViewPoint = Pawn.GetPawnViewLocation();
    ViewRotation = Rotation;
    CheckDist = Pawn.VehicleCheckRadius * VehicleCheckRadiusScaling;
    ViewDir = CheckDist * vector(ViewRotation);
    HitActor = Trace(HitLocation, HitNormal, ViewPoint + ViewDir, ViewPoint, true,,,TRACEFLAG_Blocking);

    PickedVehicle = TGTurret(HitActor);
    if (PickedVehicle != none
        && PickedVehicle.Driver == none
        )
    {
        if(PickedVehicle.LimitUseLoc)
        {
            if(abs(Normalize(Pawn.Rotation).Yaw - Normalize(PickedVehicle.Rotation).Yaw) <= 5460)
                return PickedVehicle;
            else
                return none;
        }
        return PickedVehicle;
    }

//    // make sure not just looking above vehicle
//    ViewRotation.Pitch = 0;
//    ViewDir = CheckDist * vector(ViewRotation);
//    HitActor = Trace(HitLocation, HitNormal, ViewPoint + ViewDir, ViewPoint, true,,,TRACEFLAG_Blocking);
//
//    PickedVehicle = TGTurret(HitActor);
//    if (PickedVehicle != None)
//    {
//        return PickedVehicle;
//    }
//
//    // make sure not just looking above vehicle
//    ViewRotation.Pitch = -5000;
//    ViewDir = CheckDist * vector(ViewRotation);
//    HitActor = Trace(HitLocation, HitNormal, ViewPoint + ViewDir, ViewPoint, true,,,TRACEFLAG_Blocking);
//
//    PickedVehicle = TGTurret(HitActor);
//    if (PickedVehicle != None)
//    {
//        return PickedVehicle;
//    }

    return None;
}

function OnChangeTraceTurretScale(HDSeqAct_ChangeTraceTurretScale inAction)
{
    VehicleCheckRadiusScaling = inAction.NewScale;
}

function TGTurret CheckPickedTurret(TGTurret V, bool bEnterVehicle)
{
    //local TMPlayerReplicationInfo PRI;

    if ( (V == None) || !bEnterVehicle )
    {
        return V;
    }
    // check if I would drop my flag
//  PRI = TMPlayerReplicationInfo(PlayerReplicationInfo);
//  if ( PRI.bHasFlag && !V.bCanCarryFlag && (!V.bTeamLocked || WorldInfo.GRI.OnSameTeam(self,V)) )
//  {
//      if ( V.bRequestedEntryWithFlag )
//      {
//          V.bRequestedEntryWithFlag = false;
//          ClientSetRequestedEntryWithFlag(V, false, 0);
//      }
//      else
//      {
//          V.bRequestedEntryWithFlag = true;
//          ClientSetRequestedEntryWithFlag(V, true, 0);
//          bJustFoundVehicle = true;
//          return None;
//      }
//  }
    if ( V.TryToDrive(Pawn) )
    {
        return V;
    }
    bJustFoundVehicle = true;
    return None;
}

simulated exec function  WeaponStable()
{
    if ( ViewTarget != Pawn ) return;
    if ( HDPawn(Pawn) != none )
    {
        HDPawn(Pawn).WeaponStable( true );
    }
}

simulated exec function UnWeaponStable()
{
    if ( ViewTarget != Pawn ) return;
    if ( HDPawn(Pawn) != none )
    {
        HDPawn(Pawn).WeaponStable( false );
    }
}

function OnHDPossess(HDSeqAct_HDPossess inAction)
{
    //local Pawn        OldPawn;
    local Vehicle   V;
    local HDPlatform_Derrick Derrick;
    local TGTurret  tTGTurret;
    local HDPawn    tHDPawn;
    local HDTurret_Base HDT;

    if(inAction.ActorToPossess != None)
    {
      if( inAction.bTryToLeaveVehicle )
      {
        V = Vehicle(inAction.ActorToPossess);
        if(V != none )
        {
          V.DriverLeave( true );
        }
        else
        {
         Derrick = HDPlatform_Derrick(inAction.ActorToPossess);
         tTGTurret = TGTurret(Pawn);
         if(Derrick != none
           && tTGTurret != none
           && Derrick.TurretActor == tTGTurret)
         {
            Derrick.TurretActor.DriverLeave( true );
         }
        }
      }
      else
      {
        V = Vehicle(inAction.ActorToPossess);
        Derrick = HDPlatform_Derrick(inAction.ActorToPossess);
        tHDPawn = HDPawn(Pawn);
        if( tHDPawn!= none && V != none )
        {
            HDT = HDTurret_Base(V);
            if(HDT != none)
            {
                HDT.DriverEnter(tHDPawn);
            }
            else
            {
                V.TryToDrive( tHDPawn );
            }

        }
        else if(tHDPawn!= none && Derrick != none )
        {
            if(Derrick.TurretActor != none)
            {
                Derrick.TurretActor.DriverEnter(tHDPawn);
            }
        }
      }
    }
}

/** Causes a view shake based on the amount of damage
    Should only be called on the owning client */
function DamageShake(int Damage, class<DamageType> DamageType)
{
    local float BlendWeight;
    local class<TMDamageType> TMDamage;
    local CameraAnim AnimToPlay;

    if(Damage == 0)
        return;

    TMDamage = class<TMDamageType>(DamageType);
    if (TMDamage != None && TMDamage.default.DamageCameraAnim != None)
    {
        AnimToPlay = TMDamage.default.DamageCameraAnim;
    }
    else  //fixme: TGDamageType!!!
    {
        AnimToPlay = DamageCameraAnim;
    }

    if(AnimToPlay != None)
    {
        // don't override other anims unless it's another, weaker damage anim
        //BlendWeight = FClamp(Damage / 80.0 + 0.2, 0.0, 1.2);
        BlendWeight = FClamp(Damage / 100.0 + 0.5, 0.0, 1.5);
        if ( CameraAnimPlayer != None
        && ( CameraAnimPlayer.bFinished ||(bCurrentCamAnimIsDamageShake && CameraAnimPlayer.CurrentBlendWeight < BlendWeight) ) )
        {
            PlayCameraAnim(AnimToPlay, BlendWeight,,,,, true);
        }
    }
}

native final function Pawn CheckTarget(class<Pawn> TargetClass, out float bestAim, out float bestDist, vector FireDir, vector projStart, float MaxRange, float MaxRadius);

/**
 * Adjusts weapon aiming direction.
 * Gives controller a chance to modify the aiming of the pawn. For example aim error, auto aiming, adhesion, AI help...
 * Requested by weapon prior to firing.
 * TMPlayerController implementation doesn't adjust aim, but sets the shottarget (for warning enemies)
 *
 * @param   W, weapon about to fire
 * @param   StartFireLoc, world location of weapon fire start trace, or projectile spawn loc.
 * @param   BaseAimRot, original aiming rotation without any modifications.
 */
function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
    local vector    FireDir, HitLocation, HitNormal;
    local actor     BestTarget, HitActor;
    local float     bestAim, bestDist, MaxRange;
    local rotator   BaseAimRot;
    local HDWeapon  HDW;
    local TGPawn_EnemyBase lEnemy;

    BaseAimRot = (Pawn != None) ? Pawn.GetBaseAimRotation() : Rotation;
    FireDir = vector(BaseAimRot);

    if( W.IsInState(HDWeapon(W).MeleeAttackState) )
        MaxRange = 150;
    else
        MaxRange = W.MaxRange();

    HitActor = Trace(HitLocation, HitNormal, StartFireLoc + MaxRange * FireDir, StartFireLoc, true);
    //DrawDebugLine( StartFireLoc, StartFireLoc + MaxRange * FireDir, 255,0,0, True);
    if ( (HitActor != None) && HitActor.bProjTarget )
    {
        BestTarget = HitActor;
    }
    else if ( ((WorldInfo.Game != None) &&(WorldInfo.Game.Numbots > 0)) || AimingHelp(true) )
    {
        // guess who target is
        // @todo FIXMESTEVE
        bestAim = 0.95;
        BestTarget = PickTarget(class'Pawn', bestAim, bestDist, FireDir, StartFireLoc, MaxRange);
        if (W != None && W.GetProjectileClass() == None)
        {
            InstantWarnTarget(BestTarget, W, vector(BaseAimRot));
        }
    }

    lEnemy = TGPawn_EnemyBase(BestTarget);
    if (lEnemy == none)
    {
        bestAim = 0.95;
        lEnemy = TGPawn_EnemyBase(CheckTarget(class'TGPawn_EnemyBase', bestAim, bestDist, FireDir, StartFireLoc, MaxRange, 50));
        if( lEnemy != none && bestAim < 1.0 && bestDist * bestDist * (1.0 - bestAim * bestAim) < 10000 )
        {
            lEnemy.OnFiredAround(self);
        }
    }

    HDW = HDWeapon(W);
    if (HDW != none )
       HDW.HitLoc = HitLocation;

    ShotTarget = Pawn(BestTarget);

    return BaseAimRot;
}

//---------------------------------------------------------
// Zoom Mode
//---------------------------------------------------------
simulated function OnToggleZoom( HDSeqAct_ToggleZoom seq )
{
    local HDPawn HDP;
    local HDWeapon HDW;

    HDP = HDPawn(Pawn);
    if ( HDP != None )
    {
        HDW = HDWeapon(HDP.Weapon);
        if ( (HDW.ZoomState == ZST_NotZoomed && seq.bToggleZoom)
            || (HDW.ZoomState == ZST_Zoomed && !seq.bToggleZoom) )
        {
            ZoomFireMode();
        }
    }
}

simulated function OnZoomEnable( HDSeqAct_ZoomEnable seq )
{
    bZoomEnable = seq.bZoomEnable;
}

simulated exec function ZoomFireMode()
{
    local HDPawn HDP;
    local HDTurret_Base HDT;
    if ( ViewTarget != Pawn ) return;
    if ( !bZoomEnable ) return;
    HDP = HDPawn(Pawn);
    if ( HDP != none )
       HDP.ZoomFireMode();
    // for Turret
    HDT = HDTurret_Base(Pawn);
    if(HDT != none)
       HDT.ZoomFireMode();
}

// Change Zoom Mode
simulated exec function ChangeZoomFunction( byte value )
{
   local HDPawn HDP;
   local HDWeapon HDW;

   if ( ViewTarget != Pawn ) return;
   HDP = HDPawn(Pawn);
   HDW = HDWeapon(Pawn.Weapon);
   if ( HDP != none && (HDW.ZoomState == ZST_Zoomed || HDP.IsInState('TeleScope')) )
   {
       HDP.ChangeZoomFunction( value != 0 );
   }
}

simulated exec function TankMGunFire()
{
    local HDTurret_Base HDT;
    local HDWeap_TankMainTurret HDW;
    HDT = HDTurret_Base(Pawn);
    if(HDT != none)
    {
       HDW = HDWeap_TankMainTurret(HDT.MyWeapon);
       if( HDW != none)
       {
        HDW.StartFire(1);
       }
    }
}

simulated exec function StopTankMGunFire()
{
    local HDTurret_Base HDT;
    local HDWeap_TankMainTurret HDW;
    HDT = HDTurret_Base(Pawn);
    if(HDT != none)
    {
       HDW = HDWeap_TankMainTurret(HDT.MyWeapon);
       if( HDW != none)
       {
        HDW.StopFire(1);
       }
    }
}

simulated exec function SwitchFireType()
{
    local HDWeap_AssaultRifle   HDWAR;
    HDWAR = HDWeap_AssaultRifle(Pawn.Weapon);
    if ( HDWAR != None )
    {
        HDWAR.SwitchFireType();
    }
}

function DrawHUD( HUD H )
{
    local HDTurret_Base HDT;
    if ( ViewTarget != Pawn && !IsInState('PlayerCallSupport') && !IsInState('PlayerCommandSystem'))
        return;

    super.DrawHUD(H);
    HDT = HDTurret_Base(Pawn);
   	if( (HDT != None) && (HDT.MyWeapon != None) )
	{
		TMWeapon(HDT.MyWeapon).ActiveRenderOverlays(H);
	}
//    if( Pawn != none )
//      Pawn.DrawHUD(H);
}

reliable client function ClientDrawHeadShot()
{
    DrawHeadShot();
}

function DrawHeadShot()
{
    HDHUD(myHUD).DrawHandshoot();
}

function SetCinematicMode( bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons )
{
    if(bAffectsButtons)
    {
        StopFire(0);
        StopFire(1);
        HDPlayerInput(PlayerInput).bDisableIput = bInCinematicMode;
        PlayerInput.ResetInput();
    }

    Super.SetCinematicMode(bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons);
}

/** called by the server to synchronize cinematic transitions with the client */
reliable client function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
    local HDHUD H;

    Super.ClientSetCinematicMode(bInCinematicMode, bAffectsMovement, bAffectsTurning, bAffectsHUD);

    if(bAffectsHUD)
    {
        H = HDHUD(myHUD);
        if(H != none)
        {
            if(bCinematicMode) //??Cinematic?????????????
            {
                H.bFadeOutHitEffect = false;
                H.HitEffect.bShowInGame = false;
            }
            else
            {
                H.HitEffect.bShowInGame = true;
            }
        }
    }

    //HDPawn(Pawn).OnCinematicModeEnd( bInCinematicMode, bAffectsMovement, bAffectsTurning, bAffectsHUD );
}

simulated function PlayBeepSound();

function AcknowledgePossession(Pawn P)
{
    local rotator NewViewRotation;

    Super(PlayerController).AcknowledgePossession(P);

    if ( LocalPlayer(Player) != None )
    {
        ClientEndZoom();
        if (bUseVehicleRotationOnPossess && Vehicle(P) != None && TMWeaponPawn(P) == None)
        {
            NewViewRotation = P.Rotation;
            NewViewRotation.Roll = 0;
            SetRotation(NewViewRotation);
        }
        ServerPlayerPreferences(WeaponHandPreference, bAutoTaunt, bCenteredWeaponFire, AutoObjectivePreference, VehicleControlType);

        if ( (PlayerReplicationInfo != None)
            && (PlayerReplicationInfo.Team != None)
            && (IdentifiedTeam != PlayerReplicationInfo.Team.TeamIndex) )
        {
            // identify your team the first time you spawn on it
            IdentifiedTeam = PlayerReplicationInfo.Team.TeamIndex;
        //  if ( IdentifiedTeam < 2 )  //Disable 'You are on the RED Team'
//          {
//              ReceiveLocalizedMessage( class'TMTeamGameMessage', IdentifiedTeam+1, PlayerReplicationInfo);
//          }
        }
    }
}

simulated event NotifyDirectorControl( bool bNowControlling )
{
   local HDPawn HDP;
   HDP = HDPawn(Pawn);
   if ( HDP != None )
   {
       HDP.DirectorControl( bNowControlling );
   }
   Super.NotifyDirectorControl(bNowControlling);
}

function HandlePickup(Inventory Inv);

state PlayerCallSupport
{
    ignores SeePlayer, HearNoise, Bump, SwitchToGrenade, ThrowGrenade, ToggleGasMask,
    ToggleMelee, ToggleNightVision, ToggleTelescope;
    exec function SwitchConventionalWeaponSroll( byte Value )
    {
        local HDWeapon_CallSupport HDW;

        if( Pawn == none )      return;

        HDW = HDWeapon_CallSupport(Pawn.Weapon);

        if ( ViewTarget != Pawn ) return;
        if (HDPawn(Pawn) != None && HDW != None  && HDW.IsInState('Active') )
            HDW.SwitchAttackFireMode( Value==0 );
    }

    function PlayerMove(float DeltaTime)
    {
        if( Pawn == None )
        {
            GotoState('dead');
            return;
        }

        UpdateRotation( DeltaTime );
        Pawn.Acceleration=vect(0,0,0);
        Pawn.Velocity=vect(0,0,0);
        if( Role < ROLE_Authority ) // then save this move and replicate it
        {
            ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
        }
        else
        {
            ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
        }
    }

    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

    /**
 * Processes the player's ViewRotation
 * adds delta rot (player input), applies any limits and post-processing
 * returns the final ViewRotation set on PlayerController
 *
 * @param   DeltaTime, time since last frame
 * @param   ViewRotation, current player ViewRotation
 * @param   DeltaRot, player input added to ViewRotation
 */
    function ProcessViewRotation( float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot )
    {
        local vector Position;
        // support for using CameraActor views
        if ( Camera(ViewTarget) != None )
        {
            Position = ViewTarget.Location;
            Position.X += DeltaRot.Pitch * 0.01;
            Position.Y += DeltaRot.Yaw * 0.01;
            ViewTarget.SetLocation(Position);
            return;
        }
        Global.ProcessViewRotation( DeltaTime, out_ViewRotation, DeltaRot );
    }

    /* GetPlayerViewPoint: Returns Player's Point of View
    For the AI this means the Pawn's Eyes ViewPoint
    For a Human player, this means the Camera's ViewPoint */
    simulated event GetPlayerViewPoint( out vector POVLocation, out Rotator POVRotation )
    {
        // support for using CameraActor views
        if ( Camera(ViewTarget) != None )
        {
            POVLocation = ViewTarget.Location;
            POVRotation = ViewTarget.Rotation;
            return;
        }
        Global.GetPlayerViewPoint( POVLocation, POVRotation );
    }


    function BeginState(Name PreviousStateName)
    {
        HDPawn_MP(Pawn).StopMoving();
    }

    function EndState(Name NextStateName)
    {
    }
}

// command system
simulated function SetOrthoMode( bool bOrtho );

state PlayerCommandSystem
{
    ignores SeePlayer, HearNoise, Bump, SwitchToGrenade, ThrowGrenade, ToggleGasMask,
    ToggleMelee, ToggleNightVision, ToggleTelescope, StopFire;

    simulated function SetOrthoMode( bool bOrtho )
    {
        local HDLocalPlayer HDLP;
        local HDPawn    HDP;
        HDLP = HDLocalPlayer(Player);
        if ( HDLP != None )
        {
            HDLP.HDCameraType = bOrtho ? ECT_Ortho : ECT_Perspective;
            HDLP.OrthoZoom = HDLP.default.OrthoZoom;
        }

        TMGameReplicationInfo(WorldInfo.GRI).bLocalDisablePawnCastShadow = bOrtho;

        foreach AllActors(class'HDPawn', HDP)
        {
            if ( HDP != None )
                HDP.UpdateShadowSettings(!bOrtho);
        }
    }


    simulated exec function ZoomFireMode()
    {
        Global.StopFire(0);
    }

    function BeginState(Name PreviousStateName)
    {
        HDPawn_MP(Pawn).StopMoving();
    }
    function EndState(Name NextStateName)
    {
        SetOrthoMode(False);
    }

    simulated exec function ChangeZoomFunction( byte Value )
    {
        local float zoom;
        local HDWeapon_CommandSystem HDW;
        local HDLocalPlayer HDLP;

        HDW = HDWeapon_CommandSystem(Pawn.Weapon);
        HDLP = HDLocalPlayer(Player);

        // support for using CameraActor views
        if ( Camera(ViewTarget) != None && HDW != None && HDLP != None )
        {
            zoom = HDLP.OrthoZoom;
            zoom = HDW.ClampCameraZ(Value != 0, zoom);
            HDLP.OrthoZoom = zoom;
            return;
        }
    }

    function PlayerMove(float DeltaTime)
    {
        if( Pawn == None )
        {
            GotoState('dead');
            return;
        }

        UpdateRotation( DeltaTime );
        Pawn.Acceleration=vect(0,0,0);
        Pawn.Velocity=vect(0,0,0);
        if( Role < ROLE_Authority ) // then save this move and replicate it
        {
            ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
        }
        else
        {
            ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
        }
    }

    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

    function ProcessViewRotation( float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot )
    {
        local vector Position;
        local float  zoomscale;
        local HDWeapon_CommandSystem HDW;
        local HDLocalPlayer HDLP;

        HDW = HDWeapon_CommandSystem(Pawn.Weapon);
        HDLP = HDLocalPlayer(Player);

        // support for using CameraActor views
        if ( Camera(ViewTarget) != None && HDW != None )
        {
            Position = ViewTarget.Location;
            zoomscale = 0.1 * HDLP.OrthoZoom * 0.000005;
            Position.X += DeltaRot.Pitch * zoomscale ;
            Position.Y += DeltaRot.Yaw * zoomscale;
            Position = HDW.ClampCameraPosition(Position);
            ViewTarget.SetLocation(Position);
            return;
        }
        Global.ProcessViewRotation( DeltaTime, out_ViewRotation, DeltaRot );
    }

    /* GetPlayerViewPoint: Returns Player's Point of View
    For the AI this means the Pawn's Eyes ViewPoint
    For a Human player, this means the Camera's ViewPoint */
    simulated event GetPlayerViewPoint( out vector POVLocation, out Rotator POVRotation )
    {
        // support for using CameraActor views
        if ( Camera(ViewTarget) != None )
        {
            POVLocation = ViewTarget.Location;
            POVRotation = ViewTarget.Rotation;
            return;
        }
        Global.GetPlayerViewPoint( POVLocation, POVRotation );
    }
}


final function SeqEvent_Used CanUseTrigger(Trigger checkTrigger, const out vector cameraLoc, const out rotator cameraRot, float minDot, bool bUsuableOnly)
{
    local int Idx;
    local SeqEvent_Used UseSeq;
    local float Dir;

    for(Idx = 0; Idx < checkTrigger.GeneratedEvents.Length; Idx++)
    {
        UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[Idx]);
        if( UseSeq != none && UseSeq.bEnabled && (!bUsuableOnly || UseSeq.CheckActivate(checkTrigger, Pawn, true))/* && VSizeSq(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance * UseSeq.InteractDistance*/ )
        {
            Dir = Normal(checkTrigger.Location - cameraLoc) dot vector(cameraRot);
            if( Dir >= minDot && (!UseSeq.bAimToInteract || Dir >= 0.906f) ) //25d
            {
               return UseSeq;
            }
        }
    }

    return none;
}

/**
 * Looks at all nearby triggers, looking for any that can be
 * interacted with.
 *
 * @param       interactDistanceToCheck - distance to search for nearby triggers
 *
 * @param       crosshairDist - distance from the crosshair that
 *              triggers must be, else they will be filtered out
 *
 * @param       minDot - minimum dot product between trigger and the
 *              camera orientation needed to make the list
 *
 * @param       bUsuableOnly - if true, event must return true from
 *              SequenceEvent::CheckActivate()
 *
 * @param       out_useList - the list of triggers found to be
 *              usuable
 */
function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList)
{
    local vector cameraLoc;
    local rotator cameraRot;
    local Trigger checkTrigger;

    if(Pawn != None)
    {
        // grab camera location/rotation for checking crosshairDist
        GetPlayerViewPoint(cameraLoc, cameraRot);

        // search of nearby actors that have use events
        //foreach Pawn.CollidingActors(class'Trigger', checkTrigger, interactDistanceToCheck)
        foreach Pawn.TouchingActors(class'Trigger', checkTrigger)
        {
            if( CanUseTrigger(checkTrigger, cameraLoc, cameraRot, minDot, bUsuableOnly) != none )
            {
                out_useList[out_useList.Length] = checkTrigger;
            }
        }
    }
}

simulated function OnPostProcessEffect( HDSeqAct_PostProcessEffect Action )
{
   local MaterialEffect LDEffect;
   //local MaterialInstanceConstant TempMIC;

    LDEffect = MaterialEffect( LocalPlayer(Player).PlayerPostProcess.FindPostProcessEffect('LDEffect') );
    if(LDEffect != None)
    {
        LDEffect.Material = Action.EffectMaterial;
//        TempMIC = MaterialInstanceConstant(LDEffect.Material);
//        if(TempMIC == None || TempMIC.GetPackageName() != 'Transient')
//       {
//            TempMIC = new(LDEffect) class'MaterialInstanceConstant';
//            LDEffect.Material = TempMIC;
//        }
//        TempMIC.SetParent(Action.EffectMaterial);
//
        LDEffect.bShowInGame = Action.InputLinks[0].bHasImpulse;
    }
}


// forbidden fire
function OnToggleFireAction( HDSeqAct_ToggleFireAction Action )
{
    if ( Action.Targets[0] == Self && Pawn(ViewTarget) != None )
    {
        bDisableFireAction = Action.bDisableFire;
        if ( bDisableFireAction && Pawn(ViewTarget).Weapon != None )
        {
            Pawn(ViewTarget).Weapon.ForceEndFire();
        }
    }
}

//Disable Cheats(e.g. GOD) when Cook/FinalRelease
function AddCheats()
{



}



// exec set foot placement
exec function SetFootPlacement( bool flag )
{
    local HDPawn        HDP;
    foreach AllActors( class'HDPawn', HDP)
    {
        if ( HDP != None )  HDP.bEnableFootPlacement = flag;
    }
}


