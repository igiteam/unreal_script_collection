class Camera extends Actor
    native
    notplaceable
    hidecategories(lighting);

struct TCameraCache
{
    var float TimeStamp;
    var TPOV POV;

    structdefaultproperties
    {
        TimeStamp=0.0000000
        POV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=0.0000000)
    }
};

struct TViewTarget
{
    var() Actor Target;
    var() Controller Controller;
    var() TPOV POV;
    var() float AspectRatio;
    var() PlayerReplicationInfo PRI;

    structdefaultproperties
    {
        Target=none
        Controller=none
        POV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=0.0000000)
        AspectRatio=0.0000000
        PRI=none
    }
};

var PlayerController PCOwner;
var name CameraStyle;
var float DefaultFOV;
var bool bLockedFOV;
var bool bConstrainAspectRatio;
var bool bEnableFading;
var bool bOverrideBlurSettings;
var bool bEnableColorScaling;
var bool bEnableDOF;
var float LockedFOV;
var float ConstrainedAspectRatio;
var float DefaultAspectRatio;
var Color FadeColor;
var float FadeAmount;
var float BlurAlpha;
var Vector ColorScale;
var TCameraCache CameraCache;
var TViewTarget ViewTarget;
var TViewTarget PendingViewTarget;
var float BlendTimeToGo;
var float BlendLength;
var array<CameraModifier> ModifierList;
var float FreeCamDistance;
var Vector FreeCamOffset;

// Export UCamera::execInitializeFor(FFrame&, void* const)
native function InitializeFor(PlayerController PC);

// Export UCamera::execGetFOVAngle(FFrame&, void* const)
native function float GetFOVAngle();

// Export UCamera::execGetAspectRation(FFrame&, void* const)
native function float GetAspectRation();

function SetFOV(float NewFOV)
{
    // End:0x27
    if((NewFOV < float(1)) || NewFOV > float(170))
    {
        bLockedFOV = false;
        return;
    }
    bLockedFOV = true;
    LockedFOV = NewFOV;
    return;
}

// Export UCamera::execGetCameraViewPoint(FFrame&, void* const)
native function GetCameraViewPoint(out Vector vOutCamLoc, out Rotator rOutCamRot);

// Export UCamera::execGetCameraViewPointWithModifiers(FFrame&, void* const)
native function GetCameraViewPointWithModifiers(out Vector vOutCamLoc, out Rotator rOutCamRot, out float fViewMatrixOffset);

simulated event UpdateCamera(float DeltaTime)
{
    local TPOV NewPOV;
    local float DurationPct, BlendPct;

    bConstrainAspectRatio = false;
    CheckViewTarget(ViewTarget);
    UpdateViewTarget(ViewTarget, DeltaTime);
    NewPOV = ViewTarget.POV;
    ConstrainedAspectRatio = ViewTarget.AspectRatio;
    // End:0x156
    if(PendingViewTarget.Target != none)
    {
        BlendTimeToGo -= DeltaTime;
        CheckViewTarget(PendingViewTarget);
        UpdateViewTarget(PendingViewTarget, DeltaTime);
        // End:0x108
        if(BlendTimeToGo > float(0))
        {
            DurationPct = BlendTimeToGo / BlendLength;
            BlendPct = FCubicInterp(0.0000000, 0.0000000, 1.0000000, 0.0000000, 1.0000000 - DurationPct);
            NewPOV = BlendViewTargets(ViewTarget, PendingViewTarget, BlendPct);
            ConstrainedAspectRatio = Lerp(ViewTarget.AspectRatio, PendingViewTarget.AspectRatio, BlendPct);            
        }
        else
        {
            ViewTarget = PendingViewTarget;
            PendingViewTarget.Target = none;
            PendingViewTarget.Controller = none;
            BlendTimeToGo = 0.0000000;
            NewPOV = PendingViewTarget.POV;
            ConstrainedAspectRatio = PendingViewTarget.AspectRatio;
        }
    }
    FillCameraCache(NewPOV);
    return;
}

final function TPOV BlendViewTargets(TViewTarget A, TViewTarget B, float Alpha)
{
    local TPOV POV;

    POV.Location = VLerp(A.POV.Location, B.POV.Location, Alpha);
    POV.FOV = Lerp(A.POV.FOV, B.POV.FOV, Alpha);
    POV.Rotation = RLerp(A.POV.Rotation, B.POV.Rotation, Alpha, true);
    return POV;
    return;
}

final function FillCameraCache(TPOV NewPOV)
{
    CameraCache.TimeStamp = WorldInfo.TimeSeconds;
    CameraCache.POV = NewPOV;
    return;
}

// Export UCamera::execCheckViewTarget(FFrame&, void* const)
native function CheckViewTarget(out TViewTarget VT);

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
    local Vector Loc, pos, HitLocation, HitNormal;
    local Rotator Rot;
    local Actor HitActor;
    local CameraActor CamActor;
    local bool bDoNotApplyModifiers;
    local float fFov;

    OutVT.POV.FOV = DefaultFOV;
    CamActor = CameraActor(OutVT.Target);
    // End:0x91
    if(CamActor != none)
    {
        CamActor.GetCameraView(DeltaTime, OutVT.POV);
        bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
        OutVT.AspectRatio = CamActor.AspectRatio;        
    }
    else
    {
        // End:0x2B2
        if((Pawn(OutVT.Target) == none) || !Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV))
        {
            bDoNotApplyModifiers = true;
            switch(CameraStyle)
            {
                // End:0x113
                case 'Fixed':
                    // End:0x2B2
                    break;
                // End:0x11B
                case 'ThirdPerson':
                // End:0x232
                case 'FreeCam':
                    Loc = OutVT.Target.Location;
                    Rot = OutVT.Target.Rotation;
                    // End:0x178
                    if(CameraStyle == 'FreeCam')
                    {
                        Rot = PCOwner.Rotation;
                    }
                    Loc += (FreeCamOffset >> Rot);
                    pos = Loc - (Vector(Rot) * FreeCamDistance);
                    HitActor = Trace(HitLocation, HitNormal, pos, Loc, false, vect(0.0000000, 0.0000000, 0.0000000));
                    // End:0x1FA
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
                    // End:0x2B2
                    break;
                // End:0x23A
                case 'FirstPerson':
                // End:0xFFFF
                default:
                    OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
                    fFov = OutVT.Target.GetViewFOV();
                    // End:0x2AF
                    if(fFov != 0.0000000)
                    {
                        OutVT.POV.FOV = fFov;
                    }
                    // End:0x2B2
                    break;
                    break;
            }
        }
    }
    // End:0x2D3
    if(!bDoNotApplyModifiers)
    {
        ApplyCameraModifiers(DeltaTime, OutVT.POV);
    }
    return;
}

// Export UCamera::execSetViewTarget(FFrame&, void* const)
native function SetViewTarget(Actor NewViewTarget, optional float TransitionTime);

// Export UCamera::execProcessViewRotation(FFrame&, void* const)
native function ProcessViewRotation(float fDeltaTime, out Rotator rOutViewRotation, out Rotator rOutDeltaRot);

function ApplyCameraModifiers(float DeltaTime, out TPOV OutPOV)
{
    local int ModifierIdx;

    ModifierIdx = 0;
    J0x07:

    // End:0x77 [Loop If]
    if(ModifierIdx < ModifierList.Length)
    {
        // End:0x6D
        if((ModifierList[ModifierIdx] != none) && ModifierList[ModifierIdx].IsDisabled() == false)
        {
            // End:0x6D
            if(ModifierList[ModifierIdx].ModifyCamera(self, DeltaTime, OutPOV))
            {
                // [Explicit Break]
                goto J0x77;
            }
        }
        ModifierIdx++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x77:

    return;
}

function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Vector EyesLoc;
    local Rotator EyesRot;
    local Canvas Canvas;

    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    Canvas.__NFUN_465__((("	Camera Style:" $ string(CameraStyle)) @ "main ViewTarget:") $ string(ViewTarget.Target));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__((((("   CamLoc:" $ string(CameraCache.POV.Location)) @ "CamRot:") $ string(CameraCache.POV.Rotation)) @ "FOV:") $ string(CameraCache.POV.FOV));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("   AspectRatio:" $ string(ConstrainedAspectRatio));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    // End:0x1FF
    if(ViewTarget.Target != none)
    {
        ViewTarget.Target.GetActorEyesViewPoint(EyesLoc, EyesRot);
        Canvas.__NFUN_465__((("   EyesLoc:" $ string(EyesLoc)) @ "EyesRot:") $ string(EyesRot));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    return;
}

simulated function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool m_bAnimDebugRelevantOnly)
{
    return;
}

defaultproperties
{
    DefaultFOV=59.8400000
    DefaultAspectRatio=1.3333330
    FreeCamDistance=256.0000000
    bHidden=true
    Components=none
}