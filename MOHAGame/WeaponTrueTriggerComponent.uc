class WeaponTrueTriggerComponent extends ActorComponent
    native
    config(Weapon);

var EALASmallArms Weap;
var() SoundCue HoldBreathSound;
var() SoundCue TakeBreathSound;
var bool bJustFired;
var bool bPCTrueTriggerDown;
var bool bPendingPCTrueTriggerDown;
var float FireDown;
var() config float TTResetThreshold;
var() config float TTMinFireDown;
var() config float TTFireThreshold;
var() config float fTrueTriggerScalarSpeed;
var transient float fCurrentTrueTriggerScalar;
var float fDesiredTrueTriggerScalar;
var() config float ScopeMovementSensitivityMultiplierMin;
var() config float ScopeMovementSensitivityMultiplierMax;
var() config float AbsoluteMinScopeSensitivityMultiplier;
var(Tuning_SniperViewBob) config float LateralAmplitude;
var(Tuning_SniperViewBob) config float LateralFrequency;
var float LateralAccumulation;
var float LateralPos;
var float LatSinVal;
var float LateralCurrentAmp;
var float LateralCurrentFreq;
var(Tuning_SniperViewBob) config float VerticalAmplitude;
var(Tuning_SniperViewBob) config float VerticalFrequency;
var float VerticalAccumulation;
var float VerticalPos;
var float VertSinVal;
var float VerticalCurrentAmp;
var float VerticalCurrentFreq;
var const localized string WEAPONTRUETRIGGERCOMPONENT_TRUETRIGGERINSTRUCTIONTEXT;
var transient float TimeInTrueTriggerZone;
var transient float LastTrueTriggerDetectionTime;
var transient bool bHoldingBreath;
var transient float trueTriggerGlowTheta;

simulated function Init(EALASmallArms MyWeap)
{
    Weap = MyWeap;
    //return;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x1A
    if(!Weap.IsActiveWeapon())
    {
        return;
    }
    // End:0x35
    if(MOHAPlayerPawn(Weap.Instigator) == none)
    {
        return;
    }
    // End:0x5B
    if(MOHAPlayerPawn(Weap.Instigator).IsWeaponDisabled())
    {
        return;
    }
    // End:0x7A
    if(!Weap.Instigator.IsLocallyControlled())
    {
        return;
    }
    // End:0x9A
    if(int(Weap.GetIronsightsState()) != int(3))
    {
        return;
    }
    // End:0xCA
    if(fCurrentTrueTriggerScalar > 0.9800000)
    {
        trueTriggerGlowTheta += (((2.0000000 * 3.1415930) * DeltaTime) * 2.0000000);
    }
    FireDown = MOHAPlayerPawn(Weap.Instigator).GetFireAxis();
    // End:0x11D
    if((FireDown < TTFireThreshold) && bPCTrueTriggerDown)
    {
        FireDown = TTFireThreshold - 0.0100000;
    }
    // End:0x14F
    if((FireDown > 0.8000000) && FireDown < TTFireThreshold)
    {
        FireDown = TTFireThreshold - 0.0100000;
    }
    // End:0x181
    if(bJustFired && FireDown < TTResetThreshold)
    {
        Weap.ScopeStopFire(0);        
    }
    else
    {
        // End:0x18C
        if(bJustFired)
        {
            return;
        }
    }
    // End:0x1B0
    if(FireDown >= TTFireThreshold)
    {
        Weap.ScopeStartFire(0);
    }
    // End:0x1D8
    if(!bJustFired && bPendingPCTrueTriggerDown)
    {
        PCTrueTriggerDown();
        bPendingPCTrueTriggerDown = false;
    }
    //return;    
}

simulated function ToggleHoldBreath()
{
    bHoldingBreath = !bHoldingBreath;
    //return;    
}

simulated function IronsightsBeginState(name PreviousStateName)
{
    local int I;
    local MOHAPlayerPawn PlayerPawn;
    local MOHAPlayerController PlayerController;

    I = 0;
    J0x07:

    // End:0x4B [Loop If]
    if(I < Weap.InvManager.PendingFire.Length)
    {
        Weap.ClearPendingFire(I);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0xA7
    if(PreviousStateName != 'IronsightWeaponRechamber')
    {
        VertSinVal = 0.0000000;
        LatSinVal = 3.1415930 * 0.5000000;
        LateralCurrentFreq = LateralFrequency;
        LateralCurrentAmp = LateralAmplitude;
        VerticalCurrentFreq = VerticalFrequency;
        VerticalCurrentAmp = VerticalAmplitude;
    }
    PlayerPawn = MOHAPlayerPawn(Weap.Instigator);
    PlayerController = MOHAPlayerController(PlayerPawn.Controller);
    // End:0x12D
    if(PreviousStateName == 'IronsightsIn')
    {
        MOHAHUD(PlayerController.myHUD).DisplayMessage(WEAPONTRUETRIGGERCOMPONENT_TRUETRIGGERINSTRUCTIONTEXT, 1.5000000, 0.5000000, 0.2100000);
        trueTriggerGlowTheta = 0.0000000;
    }
    //return;    
}

simulated function IronsightsEndState(name NextStateName)
{
    local MOHAPlayerPawn PlayerPawn;
    local MOHAPlayerController PlayerController;

    LastTrueTriggerDetectionTime = 0.0000000;
    TimeInTrueTriggerZone = 0.0000000;
    fDesiredTrueTriggerScalar = 0.0000000;
    PlayerPawn = MOHAPlayerPawn(Weap.Instigator);
    PlayerController = MOHAPlayerController(PlayerPawn.Controller);
    // End:0x87
    if(NextStateName == 'IronsightsOut')
    {
        MOHAHUD(PlayerController.myHUD).RemoveMessage();
    }
    //return;    
}

simulated function UpdateDesiredTrueTriggerScalar(float DeltaTime)
{
    local float LastTimeInTrueTriggerZone;

    fDesiredTrueTriggerScalar = 0.0000000;
    // End:0x3D
    if(Weap.GetStateName() == 'IronsightWeaponRechamber')
    {
        LastTrueTriggerDetectionTime = 0.0000000;
        TimeInTrueTriggerZone = 0.0000000;
        return;
    }
    // End:0x73
    if(int(Weap.GetIronsightsState()) != int(3))
    {
        LastTrueTriggerDetectionTime = 0.0000000;
        TimeInTrueTriggerZone = 0.0000000;
        return;
    }
    LastTimeInTrueTriggerZone = TimeInTrueTriggerZone;
    // End:0x1FE
    if(bJustFired != true)
    {
        // End:0x1A1
        if((FireDown > TTMinFireDown) || bHoldingBreath)
        {
            // End:0x181
            if(LastTrueTriggerDetectionTime > 0.0000000)
            {
                TimeInTrueTriggerZone += DeltaTime;
                // End:0x114
                if((LastTimeInTrueTriggerZone < 0.2500000) && TimeInTrueTriggerZone >= 0.2500000)
                {
                    Weap.BreathingAudioComponent.SoundCue = HoldBreathSound;
                    Weap.BreathingAudioComponent.Play();
                }
                // End:0x181
                if(TimeInTrueTriggerZone > 0.2500000)
                {
                    // End:0x13A
                    if(bHoldingBreath)
                    {
                        fDesiredTrueTriggerScalar = 1.0000000;                        
                    }
                    else
                    {
                        fDesiredTrueTriggerScalar = (FireDown - TTMinFireDown) / (1.0000000 - TTMinFireDown);
                    }
                    fDesiredTrueTriggerScalar = FClamp(Sin(fDesiredTrueTriggerScalar * (3.1415930 * 0.5000000)), 0.0000000, 1.0000000);
                }
            }
            LastTrueTriggerDetectionTime = Weap.WorldInfo.TimeSeconds;            
        }
        else
        {
            // End:0x1E5
            if(LastTimeInTrueTriggerZone >= 0.2500000)
            {
                Weap.BreathingAudioComponent.SoundCue = TakeBreathSound;
                Weap.BreathingAudioComponent.Play();
            }
            LastTrueTriggerDetectionTime = 0.0000000;
            TimeInTrueTriggerZone = 0.0000000;
        }        
    }
    else
    {
        LastTrueTriggerDetectionTime = 0.0000000;
        TimeInTrueTriggerZone = 0.0000000;
    }
    //return;    
}

simulated function StartFire(byte FireModeNum)
{
    bHoldingBreath = false;
    bJustFired = true;
    //return;    
}

simulated function StopFire(byte FireModeNum)
{
    bPCTrueTriggerDown = false;
    bJustFired = false;
    //return;    
}

simulated function float GetStanceModifier()
{
    // End:0x28
    if(!Weap.Instigator.IsA('MOHAPlayerPawn'))
    {
        return 1.0000000;
    }
    switch(MOHAPlayerPawn(Weap.Instigator).eCurrentStance)
    {
        // End:0x54
        case 1:
            return 1.0000000;
            // End:0x6E
            break;
        // End:0x62
        case 2:
            return 1.0000000;
            // End:0x6E
            break;
        // End:0xFFFF
        default:
            return 1.0000000;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x06E
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x06E    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x06E
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x06E
}

simulated function PCTrueTriggerDown()
{
    // End:0x16
    if(!bJustFired)
    {
        bPCTrueTriggerDown = true;        
    }
    else
    {
        bPendingPCTrueTriggerDown = true;
    }
    //return;    
}

simulated function PCTrueTriggerRelease()
{
    bPCTrueTriggerDown = false;
    bPendingPCTrueTriggerDown = false;
    //return;    
}

simulated function UpdateAimOffsetCam(float DeltaTime, float TrueTriggerScalar)
{
    local MOHAPlayerPawn MPP;
    local AnimNodeAimOffset aimNodeArms;

    MPP = MOHAPlayerPawn(Weap.Instigator);
    aimNodeArms = AnimNodeAimOffset(MPP.FPArms.Animations.FindAnimNode('Keeb_CameraAimOffset'));
    // End:0xD0
    if(aimNodeArms != none)
    {
        LateralPos += (DeltaTime * (1.0000000 - TrueTriggerScalar));
        aimNodeArms.Aim.X = Cos(LateralPos);
        VerticalPos += (DeltaTime * (1.0000000 - TrueTriggerScalar));
        aimNodeArms.Aim.Y = Sin(VerticalPos);        
    }
    //return;    
}

simulated function InternalProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local float Temp, fScopeInOutPercent, fCurrentSensitivity;

    // End:0x14
    if(Weap.bViewKickActive)
    {
        return;
    }
    UpdateDesiredTrueTriggerScalar(DeltaTime);
    // End:0x5B
    if(fDesiredTrueTriggerScalar > fCurrentTrueTriggerScalar)
    {
        fCurrentTrueTriggerScalar += FClamp(fTrueTriggerScalarSpeed * DeltaTime, 0.0000000, fDesiredTrueTriggerScalar - fCurrentTrueTriggerScalar);        
    }
    else
    {
        fCurrentTrueTriggerScalar -= FClamp(fTrueTriggerScalarSpeed * DeltaTime, 0.0000000, fCurrentTrueTriggerScalar - fDesiredTrueTriggerScalar);
    }
    fScopeInOutPercent = Weap.ScopeComponent.GetScopeInOutPercent();
    fCurrentSensitivity = Lerp(ScopeMovementSensitivityMultiplierMax, ScopeMovementSensitivityMultiplierMin, fScopeInOutPercent);
    Temp = Lerp(1.0000000 - fCurrentTrueTriggerScalar, 1.0000000, fScopeInOutPercent);
    Temp = fCurrentSensitivity * Temp;
    // End:0x104
    if(Temp < AbsoluteMinScopeSensitivityMultiplier)
    {
        Temp = AbsoluteMinScopeSensitivityMultiplier;
    }
    out_DeltaRot *= Temp;
    LateralPos += (GetLateralPos(DeltaTime * (1.0000000 - fCurrentTrueTriggerScalar), LateralCurrentFreq, LateralCurrentAmp));
    out_DeltaRot.Yaw += int(LateralPos);
    LateralPos -= float(int(LateralPos));
    VerticalPos += (GetVerticalPos(DeltaTime * (1.0000000 - fCurrentTrueTriggerScalar), VerticalCurrentFreq, VerticalCurrentAmp));
    out_DeltaRot.Pitch += int(VerticalPos);
    VerticalPos -= float(int(VerticalPos));
    //return;    
}

simulated function float GetLateralPos(float DeltaTime, float Frequency, float Amplitude)
{
    local float Move;

    LatSinVal += (DeltaTime * Frequency);
    Move = Sin(LatSinVal) * Amplitude;
    Move -= LateralAccumulation;
    LateralAccumulation += Move;
    return Move;
    //return ReturnValue;    
}

simulated function float GetVerticalPos(float DeltaTime, out float Frequency, float Amplitude)
{
    local float Move;

    VertSinVal += (DeltaTime * Frequency);
    Move = Sin(VertSinVal) * Amplitude;
    Move -= VerticalAccumulation;
    VerticalAccumulation += Move;
    return Move;
    //return ReturnValue;    
}

simulated function OnShotFired()
{
    VertSinVal = 0.0000000;
    LatSinVal = 3.1415930 * 0.5000000;
    //return;    
}

defaultproperties
{
    HoldBreathSound=SoundCue'Aud_GCm_FakeWAV.TrueTrigger.WpnMvmt_PC_TrueTrigger_Inhale'
    TakeBreathSound=SoundCue'Aud_GCm_FakeWAV.TrueTrigger.WpnMvmt_PC_TrueTrigger_Exhale'
    TTResetThreshold=0.8000000
    TTMinFireDown=0.2000000
    TTFireThreshold=1.0000000
    fTrueTriggerScalarSpeed=10.0000000
    ScopeMovementSensitivityMultiplierMin=0.8000000
    ScopeMovementSensitivityMultiplierMax=0.2500000
    AbsoluteMinScopeSensitivityMultiplier=0.1000000
    LateralAmplitude=25.0000000
    LateralFrequency=2.0000000
    VerticalAmplitude=75.0000000
    VerticalFrequency=2.0000000
}