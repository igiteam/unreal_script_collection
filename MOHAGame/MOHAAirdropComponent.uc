class MOHAAirdropComponent extends ActorComponent
    native;

var(Airdrop) float AirdropMaxLateralSpeedChute;
var(Airdrop) float AirdropMaxLateralSpeedFreefall;
var(Airdrop) float AirdropMaxLateralSpeedFlared;
var(Airdrop) float AirdropMaxPendulumSwing;
var(Airdrop) float AirdropTimerChuteFlare;
var(Airdrop) float AirdropTerminalVelocityFreeFall;
var(Airdrop) float AirdropTerminalVelocityChuteOpen;
var(Airdrop) float AirdropTerminalVelocityChute;
var(Airdrop) float AirdropTerminalVelocityChuteFlare;
var(Airdrop) float AirdropPendulumLengthChute;
var(Airdrop) float AirdropPendulumLengthFreeFall;
var(Airdrop) float AirdropMaxPitchAirDrop;
var(Airdrop) float AirdropMinPitchAirDrop;
var(Airdrop) float AirdropMaxPendulumLateralSpeed;
var(Airdrop) float AirdropMaxPendulumLateralAcceleration;
var(Airdrop) float AirdropMaxPendulumSwingLateralSpeed;
var(Airdrop) float AirdropMaxPendulumSwingLateralAcceleration;
var(Airdrop) float AirdropChuteOpenLerpTime;
var(Airdrop) float AirdropChuteFlaringLerpTime;
var(Airdrop) float AirdropFreefallLerpTime;
var(Airdrop) float AirdropMaxLandingSpeed;
var(Airdrop) float AirdropMaxLandingAngle;
var(Airdrop) float AirdropPendulumSwingScale;
var(Airdrop) float AirdropChuteStrapLength;
var(Airdrop) float AirdropLandedMoveScale;
var(Airdrop) Vector AidropLandingPosition;
var(Airdrop) float AirdropChuteOpenBlurAmount;
var(Airdrop) float AirdropTurnSpeedScale;
var(Airdrop) float AirdropLookSpeedScale;
var(Airdrop) float AirdropVMLagRestore;
var(Airdrop) float AirdropVMMaxLagDelta;
var(Airdrop) float AirdropVMPitchOffsetMax;
var(Airdrop) float AirdropVMPitchOffsetMin;
var(Airdrop) SoundCue AirdropParachuteOpenSoundCue;
var(Airdrop) SoundCue AirdropParachuteFlareSoundCue;
var(Airdrop) SoundCue AirdropParachuteCutSoundCue;
var(Airdrop) bool bAirdropParachuteHungUp;
var(Airdrop) float AirdropMaxPendulumLateralAccelerationHeight;
var float AirdropLastDeltaTime;
var float AirdropDragCoefficientLateral;
var float AirdropDragCoefficientSwing;
var Vector AirdropCurrentPendulumPosition;
var Vector AirdropLastPendulumPosition;
var Vector AirdropCurrentPlayerLocalVelocity;
var Vector AirdropCurrentPlayerLocalPosition;
var Vector AirdropCurrentPlayerPreviousLocalPosition;
var float AirdropCurrentTerminalVelocity;
var float AirdropCurrentPendulumLength;
var Vector AirdropCurrentPendulumNormal;
var float AirdropInitialDropHeight;
var float AirdropElapsedTimeSinceLerpStart;
var float AirdropTotalLerpTime;
var float AirdropDeltaMaxLateralSpeed;
var float AirdropDeltaTerminalVelocity;
var float AirdropDeltaPendulumLength;
var float AirdropDesiredMaxLateralSpeed;
var float AirdropDesiredTerminalVelocity;
var float AirdropDesiredPendulumLength;
var transient bool bIsNetDirty;

// Export UMOHAAirdropComponent::execTick(FFrame&, void* const)
native function Tick(float DeltaTime);

simulated function InitializeAirdropComponent()
{
    AirdropCurrentPendulumPosition = (AirdropCurrentPendulumNormal * AirdropCurrentPendulumLength) + Owner.Location;
    AirdropCurrentPlayerLocalPosition = -AirdropCurrentPendulumNormal * AirdropCurrentPendulumLength;
    AirdropCurrentPlayerPreviousLocalPosition = AirdropCurrentPlayerLocalPosition;
    AirdropLastDeltaTime = 0.0166000;
    AirdropLastPendulumPosition = AirdropCurrentPendulumPosition - (Owner.Velocity * AirdropLastDeltaTime);
    AirdropInitialDropHeight = AirdropCurrentPendulumPosition.Z;
    SetChuteOpenAirdropParameters(true);
    //return;    
}

simulated function SetLerpParameters(float lerpTime)
{
    local float totalDeltaMaxLateralSpeed, totalDeltaTerminalVelocity, totalDeltaPendulumLength;

    // End:0x94
    if(lerpTime > 0.0000000)
    {
        totalDeltaMaxLateralSpeed = AirdropDesiredMaxLateralSpeed - AirdropMaxPendulumLateralSpeed;
        totalDeltaTerminalVelocity = AirdropDesiredTerminalVelocity - AirdropCurrentTerminalVelocity;
        totalDeltaPendulumLength = AirdropDesiredPendulumLength - AirdropCurrentPendulumLength;
        AirdropDeltaMaxLateralSpeed = totalDeltaMaxLateralSpeed / lerpTime;
        AirdropDeltaTerminalVelocity = totalDeltaTerminalVelocity / lerpTime;
        AirdropDeltaPendulumLength = totalDeltaPendulumLength / lerpTime;
        AirdropTotalLerpTime = lerpTime;
        AirdropElapsedTimeSinceLerpStart = 0.0000000;        
    }
    else
    {
        AirdropTotalLerpTime = 0.0000000;
        AirdropElapsedTimeSinceLerpStart = 0.0000000;
    }
    //return;    
}

simulated function SetChuteOpenAirdropParameters(optional bool noLerp = false)
{
    AirdropDesiredMaxLateralSpeed = AirdropMaxLateralSpeedChute;
    AirdropDesiredTerminalVelocity = AirdropTerminalVelocityChuteOpen;
    AirdropDesiredPendulumLength = AirdropPendulumLengthChute;
    AirdropDragCoefficientLateral = -1.0000000;
    // End:0x4E
    if(!noLerp)
    {
        SetLerpParameters(AirdropChuteOpenLerpTime);        
    }
    else
    {
        SetLerpParameters(0.0000000);
    }
    //return;    
}

simulated function SetFreefallAirdropParameters(optional bool noLerp = false)
{
    AirdropDesiredMaxLateralSpeed = AirdropMaxLateralSpeedFreefall;
    AirdropDesiredTerminalVelocity = AirdropTerminalVelocityFreeFall;
    AirdropDesiredPendulumLength = AirdropPendulumLengthFreeFall;
    AirdropDragCoefficientLateral = -1.0000000;
    // End:0x4E
    if(!noLerp)
    {
        SetLerpParameters(AirdropFreefallLerpTime);        
    }
    else
    {
        SetLerpParameters(0.0000000);
    }
    //return;    
}

simulated function SetChuteFlaringAirdropParameters(optional bool noLerp = false)
{
    AirdropDesiredMaxLateralSpeed = AirdropMaxLateralSpeedFlared;
    AirdropDesiredTerminalVelocity = AirdropTerminalVelocityChuteFlare;
    AirdropDesiredPendulumLength = AirdropPendulumLengthChute;
    AirdropDragCoefficientLateral = -1.0000000;
    // End:0x4E
    if(!noLerp)
    {
        SetLerpParameters(AirdropChuteFlaringLerpTime);        
    }
    else
    {
        SetLerpParameters(0.0000000);
    }
    //return;    
}

defaultproperties
{
    AirdropMaxLateralSpeedChute=800.0000000
    AirdropMaxLateralSpeedFreefall=400.0000000
    AirdropMaxLateralSpeedFlared=400.0000000
    AirdropMaxPendulumSwing=0.6000000
    AirdropTimerChuteFlare=2.4500000
    AirdropTerminalVelocityFreeFall=1200.0000000
    AirdropTerminalVelocityChuteOpen=900.0000000
    AirdropTerminalVelocityChute=800.0000000
    AirdropTerminalVelocityChuteFlare=300.0000000
    AirdropPendulumLengthChute=200.0000000
    AirdropMaxPitchAirDrop=45.0000000
    AirdropMinPitchAirDrop=85.0000000
    AirdropMaxPendulumLateralSpeed=800.0000000
    AirdropMaxPendulumLateralAcceleration=3000.0000000
    AirdropMaxPendulumSwingLateralSpeed=500.0000000
    AirdropMaxPendulumSwingLateralAcceleration=1500.0000000
    AirdropChuteOpenLerpTime=1.0000000
    AirdropChuteFlaringLerpTime=1.0000000
    AirdropFreefallLerpTime=1.0000000
    AirdropMaxLandingSpeed=6.0000000
    AirdropMaxLandingAngle=40.0000000
    AirdropPendulumSwingScale=1.0000000
    AirdropChuteStrapLength=2.0000000
    AirdropLandedMoveScale=0.1000000
    AirdropTurnSpeedScale=0.7500000
    AirdropLookSpeedScale=0.7500000
    AirdropVMLagRestore=1.5000000
    AirdropVMMaxLagDelta=35.0000000
    AirdropVMPitchOffsetMax=-600.0000000
    AirdropVMPitchOffsetMin=-4000.0000000
    AirdropParachuteOpenSoundCue=SoundCue'Aud_GCm_FakeWAV.Parachute.Parachute_Open_PC'
    AirdropParachuteFlareSoundCue=SoundCue'Aud_GCm_FakeWAV.Parachute.Parachute_Flare_PC'
    AirdropParachuteCutSoundCue=SoundCue'Aud_GCm_FakeWAV.Parachute.Parachute_Cut_PC'
    AirdropLastDeltaTime=-1.0000000
    AirdropDragCoefficientLateral=-1.0000000
    AirdropDragCoefficientSwing=0.0500000
    AirdropCurrentPlayerLocalPosition=(X=0.0000000,Y=0.0000000,Z=-200.0000000)
    AirdropCurrentPlayerPreviousLocalPosition=(X=0.0000000,Y=0.0000000,Z=-200.0000000)
    AirdropCurrentTerminalVelocity=700.0000000
    AirdropCurrentPendulumLength=200.0000000
    AirdropCurrentPendulumNormal=(X=0.0000000,Y=0.0000000,Z=1.0000000)
    AirdropDesiredMaxLateralSpeed=800.0000000
    AirdropDesiredTerminalVelocity=700.0000000
    AirdropDesiredPendulumLength=200.0000000
}