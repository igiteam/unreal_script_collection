class PandoraPlayerCamera extends Camera
    native;

/** MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS set to editinline so we can access it through the "editactor" command in-game */
var(Camera) editinline PandoraCamMod_ScreenShake PandoraCamMod_ScreenShake;
var Vector fp_Offset;
var Vector tp_Offset;
var Vector CameraPivot;
var bool bZoomIn;
var bool bZoomOut;
var transient bool bTesting;
var transient Emit_CameraBlood CameraBloodEmitter;
var transient Vector viewPosOffset;

// Export UPandoraPlayerCamera::execIsThirdPerson(FFrame&, void* const)
native static function bool IsThirdPerson(PlayerPawn thePawn);

// Export UPandoraPlayerCamera::execGetFirstPersonBaseInfo(FFrame&, void* const)
native static function GetFirstPersonBaseInfo(PlayerPawn thePawn, out Vector pos, out Rotator Rot);

// Export UPandoraPlayerCamera::execGetFirstPersonBaseInfoFromConstants(FFrame&, void* const)
native static function bool GetFirstPersonBaseInfoFromConstants(PlayerPawn thePawn, out Vector outPos, out Rotator outRot);

// Export UPandoraPlayerCamera::execApplyADSLag(FFrame&, void* const)
native function ApplyADSLag(PlayerPawn thePawn, out Vector camPos);

// Export UPandoraPlayerCamera::execGetCameraViewPoint(FFrame&, void* const)
native function GetCameraViewPoint(out Vector OutCamLoc, out Rotator OutCamRot);

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    // End:0x25
    if(PandoraCamMod_ScreenShake == none)
    {
        PandoraCamMod_ScreenShake = new (Outer) Class'PandoraCamMod_ScreenShake';
    }
    PandoraCamMod_ScreenShake.Init();
    PandoraCamMod_ScreenShake.AddCameraModifier(self);
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local PlayerPawn thePlayerPawn;

    super(Actor).Tick(DeltaTime);
    // End:0x73
    if((PendingViewTarget.Target != none) && !PendingViewTarget.Target.bDeleteMe)
    {
        // End:0x70
        if(PendingViewTarget.Target != Owner)
        {
            SetOwner(PendingViewTarget.Target);
        }        
    }
    else
    {
        // End:0xD8
        if((ViewTarget.Target != none) && !ViewTarget.Target.bDeleteMe)
        {
            // End:0xD8
            if(ViewTarget.Target != Owner)
            {
                SetOwner(ViewTarget.Target);
            }
        }
    }
    thePlayerPawn = GetThePawn();
    // End:0x10C
    if(thePlayerPawn != none)
    {
        thePlayerPawn.UpdateLookDownSitePercent(DeltaTime);
    }
    //return;    
}

function SetDepthPriorityGroup(Scene.ESceneDepthPriorityGroup Priority)
{
    // End:0x90
    if(PCOwner.Pawn != none)
    {
        PCOwner.Pawn.Mesh.super(PandoraPlayerCamera).SetDepthPriorityGroup(Priority);
        // End:0x90
        if(PCOwner.Pawn.Weapon != none)
        {
            PCOwner.Pawn.Weapon.Mesh.super(PandoraPlayerCamera).SetDepthPriorityGroup(Priority);
        }
    }
    //return;    
}

simulated function PlayerPawn GetThePawn()
{
    local PlayerPawn thePlayerPawn;
    local PandoraPlayerController thePlayerController;

    thePlayerController = PandoraPlayerController(PCOwner);
    // End:0x1D
    if(thePlayerController == none)
    {
        return none;
    }
    thePlayerPawn = PlayerPawn(thePlayerController.Pawn);
    return thePlayerPawn;
    //return ReturnValue;    
}

simulated function SetCameraStyle(name newStyle, optional float Time = 0.0000000)
{
    local Scene.ESceneDepthPriorityGroup DPGroup;
    local PlayerPawn thePlayerPawn;

    thePlayerPawn = GetThePawn();
    switch(newStyle)
    {
        // End:0x6C
        case 'LookDownSite':
            thePlayerPawn.BeginLookDownSiteCameraMode(Time);
            DPGroup = ((PCOwner.IsLocalPlayerController()) ? 2 : 1);
            // End:0x118
            break;
        // End:0xCD
        case 'FirstPerson':
            thePlayerPawn.BeginFirstPersonCameraMode(Time, !thePlayerPawn.GetIsPartiallyLookingDownSite());
            DPGroup = ((PCOwner.IsLocalPlayerController()) ? 2 : 1);
            // End:0x118
            break;
        // End:0xFFFF
        default:
            DPGroup = 1;
            // End:0x115
            if(thePlayerPawn != none)
            {
                thePlayerPawn.SetLookDownSitePercent(0.0000000);
                thePlayerPawn.SetLookDownSitePercentChangeRate(0.0000000);
            }
            // End:0x118
            break;
            break;
    }
    SetDepthPriorityGroup(DPGroup);
    super.SetCameraStyle(newStyle);
    //return;    
}

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
    local Vector Loc, pos, HitLocation, HitNormal;
    local Rotator Rot;
    local Actor HitActor;
    local CameraActor CamActor;
    local PandoraPlayerController spPlayaController;
    local PlayerPawn thePlayerPawn;

    OutVT.POV.FOV = DefaultFOV;
    CamActor = CameraActor(OutVT.Target);
    // End:0xE1
    if(CamActor != none)
    {
        CamActor.GetCameraView(DeltaTime, OutVT.POV);
        bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
        OutVT.AspectRatio = CamActor.AspectRatio;
        bCamOverridePostProcess = CamActor.bCamOverridePostProcess;
        CamPostProcessSettings = CamActor.CamOverridePostProcess;        
    }
    else
    {
        spPlayaController = PandoraPlayerController(PCOwner);
        // End:0x131
        if(((spPlayaController != none) && spPlayaController.Pawn == none) && int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            return;
        }
        // End:0x37D
        if(spPlayaController != none)
        {
            // End:0x1F4
            if(((spPlayaController.Pawn != none) && spPlayaController.Pawn.GetStateName() == 'Dying') && int(WorldInfo.NetMode) == int(NM_Standalone))
            {
                DoDeathCamera(OutVT, Loc, Rot);
                OutVT.POV.Location = Loc;
                OutVT.POV.Rotation = Rot;
                return;                
            }
            else
            {
                // End:0x37D
                if(int(WorldInfo.NetMode) != int(NM_Standalone))
                {
                    // End:0x305
                    if(((SPPlayerReplicationInfo(spPlayaController.PlayerReplicationInfo).DeadLocation.X != float(0)) && SPPlayerReplicationInfo(spPlayaController.PlayerReplicationInfo).DeadLocation.Y != float(0)) && SPPlayerReplicationInfo(spPlayaController.PlayerReplicationInfo).DeadLocation.Z != float(0))
                    {
                        DoDeathCamera(OutVT, Loc, Rot);
                        OutVT.POV.Location = Loc;
                        OutVT.POV.Rotation = Rot;
                        return;                        
                    }
                    else
                    {
                        // End:0x37D
                        if(spPlayaController.GetStateName() == 'Dead')
                        {
                            DoMultiplayerDeathCamera(OutVT, Loc, Rot);
                            OutVT.POV.Location = Loc;
                            OutVT.POV.Rotation = Rot;
                            return;
                        }
                    }
                }
            }
        }
        switch(CameraStyle)
        {
            // End:0x429
            case 'Fixed':
                // End:0x426
                if(Pawn(OutVT.Target) != none)
                {
                    Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV);
                }
                // End:0x7BC
                break;
            // End:0x435
            case 'ThirdPerson':
            // End:0x687
            case 'FreeCam':
                // End:0x4D6
                if(Pawn(OutVT.Target) != none)
                {
                    Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV);
                }
                Loc = OutVT.Target.Location;
                Rot = OutVT.Target.Rotation;
                // End:0x53E
                if(CameraStyle == 'FreeCam')
                {
                    Rot = PCOwner.Rotation;
                }
                Loc += (FreeCamOffset >> Rot);
                // End:0x571
                if(bZoomIn)
                {
                    FreeCamDistance -= (DeltaTime * 400.0000000);                    
                }
                else
                {
                    // End:0x58D
                    if(bZoomOut)
                    {
                        FreeCamDistance += (DeltaTime * 400.0000000);
                    }
                }
                pos = Loc - (Vector(Rot) * FreeCamDistance);
                HitActor = Trace(HitLocation, HitNormal, pos, Loc, false, vect(0.0000000, 0.0000000, 0.0000000));
                // End:0x5FC
                if(HitActor != none)
                {
                    Loc = HitLocation + (HitNormal * float(2));                    
                }
                else
                {
                    Loc = pos;
                }
                OutVT.POV.Location = Loc;
                OutVT.POV.Rotation = Rot;
                // End:0x684
                if(CameraStyle == 'FreeCam')
                {
                    OutVT.POV.Rotation.Roll = 0;
                }
                // End:0x7BC
                break;
            // End:0x693
            case 'LookDownSite':
            // End:0x69F
            case 'FirstPerson':
            // End:0xFFFF
            default:
                thePlayerPawn = GetThePawn();
                // End:0x749
                if(thePlayerPawn != none)
                {
                    GetFirstPersonBaseInfo(thePlayerPawn, OutVT.POV.Location, OutVT.POV.Rotation);
                    // End:0x746
                    if(int(WorldInfo.NetMode) == int(NM_Standalone))
                    {
                        ApplyADSLag(thePlayerPawn, OutVT.POV.Location);
                    }                    
                }
                else
                {
                    // End:0x7B9
                    if(int(WorldInfo.NetMode) != int(NM_Standalone))
                    {
                        OutVT.POV.Location = spPlayaController.Location;
                        OutVT.POV.Rotation = spPlayaController.Rotation;
                    }
                }
                // End:0x7BC
                break;
                break;
        }
    }
    // End:0x82C
    if(CameraBloodEmitter != none)
    {
        CameraBloodEmitter.UpdateLocation(OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV);
    }
    ApplyCameraModifiers(DeltaTime, OutVT.POV);
    //return;    
}

simulated function DoMultiplayerDeathCamera(TViewTarget VT, out Vector OutCamLoc, out Rotator OutCamRot)
{
    local Vector pos, HitLocation, HitNormal;
    local Rotator Rot;
    local float CamDist;
    local Pawn P;
    local SPMonsterMachinePersistent MonsterMachine;

    CamDist = 200.0000000;
    VT.Target.GetActorEyesViewPoint(OutCamLoc, Rot);
    P = Pawn(VT.Target);
    // End:0x22F
    if(P != none)
    {
        // End:0x10D
        if(PlayerPawn(P) != none)
        {
            OutCamLoc = P.Mesh.GetBoneLocation('JO_head');
            OutCamLoc.X = P.Location.X;
            OutCamLoc.Y = P.Location.Y;
            OutCamRot = PCOwner.Rotation;
            CamDist = 125.0000000;            
        }
        else
        {
            OutCamLoc = P.Mesh.GetBoneLocation('JO_head');
            OutCamLoc.X = P.Location.X;
            OutCamLoc.Y = P.Location.Y;
            OutCamRot = P.Rotation;
            OutCamLoc += (vect(0.0000000, 0.0000000, 50.0000000) >> P.Rotation);
            LookAt(OutCamLoc, P.Mesh.GetBoneLocation('JO_head') + (vect(0.0000000, 0.0000000, 30.0000000) >> P.Rotation), OutCamRot);
            CamDist = 150.0000000;
        }        
    }
    else
    {
        MonsterMachine = SPMonsterMachinePersistent(VT.Target);
        // End:0x29F
        if(MonsterMachine != none)
        {
            OutCamLoc = MonsterMachine.Location + (vect(0.0000000, 0.0000000, 2.0000000) * MonsterMachine.CollisionComponent.Bounds.SphereRadius);
        }
        OutCamRot = PCOwner.Rotation;
        CamDist = 0.0000000;
    }
    pos = OutCamLoc - (Vector(OutCamRot) * CamDist);
    // End:0x323
    if(Trace(HitLocation, HitNormal, pos, OutCamLoc, false, vect(0.0000000, 0.0000000, 0.0000000)) != none)
    {
        OutCamLoc = HitLocation + (HitNormal * float(2));        
    }
    else
    {
        OutCamLoc = pos;
    }
    //return;    
}

simulated function DoDeathCamera(TViewTarget VT, out Vector OutCamLoc, out Rotator OutCamRot)
{
    local PandoraPlayerController spPlaya;
    local Vector pos, HitLocation, HitNormal;

    spPlaya = PandoraPlayerController(PCOwner);
    // End:0x15D
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x6F
        if(((spPlaya == none) || spPlaya.Pawn == none) || spPlaya.Pawn.Mesh == none)
        {
            return;
        }
        VT.Target.GetActorEyesViewPoint(OutCamLoc, OutCamRot);
        pos = spPlaya.Pawn.Mesh.GetBoneLocation('JO_neck');
        pos.Z += float(30);
        // End:0x12B
        if(Trace(HitLocation, HitNormal, pos, OutCamLoc, false, vect(0.0000000, 0.0000000, 0.0000000)) != none)
        {
            OutCamLoc = HitLocation + (HitNormal * float(2));            
        }
        else
        {
            OutCamLoc = pos;
        }
        OutCamRot = spPlaya.Pawn.GetViewRotation();        
    }
    else
    {
        SetKillerPOV(VT, OutCamLoc, OutCamRot);
    }
    //return;    
}

simulated function SetKillerPOV(TViewTarget VT, out Vector OutCamLoc, out Rotator OutCamRot)
{
    local Vector pos, HitLocation, HitNormal;
    local float CamDist;
    local Pawn P;
    local SPPlayerReplicationInfo SPPRI;

    P = Pawn(VT.Target);
    SPPRI = SPPlayerReplicationInfo(PCOwner.PlayerReplicationInfo);
    // End:0x1C7
    if(((P != none) && P != PCOwner.Pawn) && !P.bPlayedDeath)
    {
        OutCamLoc = P.Mesh.GetBoneLocation('JO_head');
        OutCamLoc.X = P.Location.X;
        OutCamLoc.Y = P.Location.Y;
        OutCamLoc += (vect(0.0000000, 0.0000000, 50.0000000) >> P.Rotation);
        LookAt(OutCamLoc, SPPRI.DeadLocation + vect(0.0000000, 0.0000000, 30.0000000), OutCamRot);
        CamDist = 150.0000000;
        pos = OutCamLoc - (Vector(OutCamRot) * CamDist);
        // End:0x1B9
        if(Trace(HitLocation, HitNormal, pos, OutCamLoc, false, vect(0.0000000, 0.0000000, 0.0000000)) != none)
        {
            OutCamLoc = HitLocation + (HitNormal * float(2));            
        }
        else
        {
            OutCamLoc = pos;
        }        
    }
    else
    {
        OutCamLoc = SPPRI.DeadLocation;
        OutCamLoc.Z += float(30);
        OutCamRot = PCOwner.Rotation;
    }
    //return;    
}

simulated function LookAt(Vector camPos, Vector lookAtPos, out Rotator OutCamRot)
{
    local float xDist, yDist, zDist, xyDist, pitchFloat, yawFloat;

    xDist = lookAtPos.X - camPos.X;
    yDist = lookAtPos.Y - camPos.Y;
    zDist = lookAtPos.Z - camPos.Z;
    xyDist = Sqrt((xDist * xDist) + (yDist * yDist));
    yawFloat = Atan(yDist, xDist);
    pitchFloat = Atan(zDist, xyDist);
    OutCamRot.Yaw = int(((yawFloat * float(65536)) / (float(2) * 3.1415930)) % float(65536));
    OutCamRot.Pitch = int(((pitchFloat * float(65536)) / (float(2) * 3.1415930)) % float(65536));
    OutCamRot.Roll = 0;
    //return;    
}

simulated function RemoveCameraBlood(Emit_CameraBlood BloodEmitter)
{
    // End:0x16
    if(CameraBloodEmitter == BloodEmitter)
    {
        CameraBloodEmitter = none;
    }
    //return;    
}

simulated function ClearCameraBlood()
{
    // End:0x1F
    if(CameraBloodEmitter != none)
    {
        CameraBloodEmitter.Destroy();
        CameraBloodEmitter = none;
    }
    //return;    
}
