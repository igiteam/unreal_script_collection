class CameraActor extends Actor
    native
    placeable
    hidecategories(lighting);

var() bool bConstrainAspectRatio;
var() interp float AspectRatio;
var() interp float FOVAngle;
var export editinline DrawFrustumComponent DrawFrustum;
var export editinline StaticMeshComponent MeshComp;
var() array< class<CameraModifier> > CameraModifiers;
var array<CameraModifier> ModifierList;
var native const Pointer SceneViewState;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        AspectRatio, FOVAngle;
}

event GetPIPInfo(out sPIPInfo pipInfo)
{
    GetCameraInfo(pipInfo.vLocation, pipInfo.rRotation, pipInfo.fFov);
    pipInfo.EVisionMode = 0;
    pipInfo.fAspectRatio = AspectRatio;
    pipInfo.bDistortionEnable = false;
    return;
}

// Export UCameraActor::execGetCameraInfo(FFrame&, void* const)
native function GetCameraInfo(out Vector vLoc, out Rotator rRot, out float fFov);

// Export UCameraActor::execAddModifiers(FFrame&, void* const)
native function AddModifiers(array< class<CameraModifier> > arrModifierClasses);

// Export UCameraActor::execRemoveModifiers(FFrame&, void* const)
native function RemoveModifiers(array< class<CameraModifier> > arrModifierClasses);

simulated function OnR6AddCameraModifier(SeqAct_R6AddCameraModifier Action)
{
    // End:0x31
    if(Action.InputLinks[0].bHasImpulse)
    {
        AddModifiers(Action.ModifiersType);        
    }
    else
    {
        // End:0x5F
        if(Action.InputLinks[1].bHasImpulse)
        {
            RemoveModifiers(Action.ModifiersType);
        }
    }
    return;
}

simulated function OnR6CameraShake(SeqAct_R6CameraShake Action)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x53 [Loop If]
    if(I < ModifierList.Length)
    {
        ModifierList[I].Shake(Action.m_damageType, Action.m_fStrengthRatio);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

simulated function OnR6CustomCameraShake(SeqAct_R6CustomCameraShake Action)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xB6 [Loop If]
    if(I < ModifierList.Length)
    {
        ModifierList[I].CustomShake(Action.m_fCustomShakeDuration, Action.m_fCustomShakeRollFreq, Action.m_fCustomShakePitchFreq, Action.m_fCustomShakeYawFreq, Action.m_iCustomShakeRollAmp, Action.m_iCustomShakePitchAmp, Action.m_iCustomShakeYawAmp, Action.m_CustomShakeInterpParams, Action.m_bCustomShakeInverted);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

simulated function OnR6PerlinNoiseCameraShake(SeqAct_R6PerlinNoiseCameraShake Action)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x10A [Loop If]
    if(I < ModifierList.Length)
    {
        ModifierList[I].PerlinNoiseShake(Action.m_fShakeDuration, Action.m_fPitchShakeScale, Action.m_iPitchShakeAmplitude, Action.m_fYawShakeScale, Action.m_iYawShakeAmplitude, Action.m_fRollShakeScale, Action.m_iRollShakeAmplitude, Action.m_fLocXShakeScale, Action.m_fLocXShakeAmplitude, Action.m_fLocYShakeScale, Action.m_fLocYShakeAmplitude, Action.m_fLocZShakeScale, Action.m_fLocZShakeAmplitude, Action.m_ShakeInterpParams, Action.m_bShakeInverted);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

simulated function PostBeginPlay()
{
    AddModifiers(CameraModifiers);
    return;
}

simulated function GetCameraView(float DeltaTime, out TPOV OutPOV)
{
    GetCameraInfo(OutPOV.Location, OutPOV.Rotation, OutPOV.FOV);
    return;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local float XL;
    local Canvas Canvas;

    Canvas = HUD.Canvas;
    DisplayDebug(HUD, out_YL, out_YPos);
    Canvas.__NFUN_464__("TEST", XL, out_YL);
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__("FOV:" $ string(FOVAngle), false);
    return;
}

defaultproperties
{
    bConstrainAspectRatio=true
    AspectRatio=1.7777780
    FOVAngle=73.6400000
    // Reference: DrawFrustumComponent'Default__CameraActor.DrawFrust0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DrawFrust0" class=Class'DrawFrustumComponent'
    end object
    DrawFrustum=DrawFrust0
    // Reference: StaticMeshComponent'Default__CameraActor.CamMesh0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CamMesh0" class=Class'StaticMeshComponent'
        HiddenGame=true
        CastShadow=false
        CollideActors=false
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    MeshComp=CamMesh0
    bNoDelete=true
    Components[0]=CamMesh0
    Components[1]=DrawFrust0
    Physics=7
    TickGroup=1
    NetUpdateFrequency=1.0000000
}