class EvilPlayerHitEffects extends Object within EvilLocalPlayer;

var() CameraShake Shake;
var() array<CameraAnim> HitCameraAnim;
var protected float BBOpacity;

function ShowScar()
{
    //return;    
}

simulated function ProcessHitEffects(float Damage, optional bool bBBPass = true, optional class<DamageType> DamageType = none)
{
    local float Ratio;
    local EvilPlayerController PC;
    local EvilPlayer_interface EPI;

    PC = EvilPlayerController(Outer.Actor);
    // End:0x1A3
    if(PC != none)
    {
        EPI = PC.GetPlayer();
        // End:0x1A3
        if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
        {
            Ratio = Damage / EPI.GetPlayerPawn().DefaultHealth;
            Outer.GetPPManager().EnableMediumBlood(FClamp(Ratio * 0.6500000, 0.0500000, 0.6000000), int(FClamp(float(int(Ratio * (0.2500000 + float(Rand(5))))), 0.0000000, 1.0000000)));
            BBOpacity = 0.3500000;
            // End:0x1A3
            if(bBBPass)
            {
                Outer.SetTimer(0.0300000, self, true, 'BBPass_T');
            }
        }
    }
    //return;    
}

simulated function PlayPulseEffects(float Damage)
{
    // End:0x5D
    if(!Outer.IsTimerActive(self, 'PulseEffects_T'))
    {
        Outer.SetTimer(0.1600000, self, true, 'PulseEffects_T');
    }
    //return;    
}

simulated function StopPulseEffects()
{
    local EvilPostProcessManager PPM;

    // End:0x55
    if(Outer.IsTimerActive(self, 'PulseEffects_T'))
    {
        Outer.ClearTimer(self, 'PulseEffects_T');
    }
    PPM = Outer.GetPPManager();
    // End:0xAC
    if(PPM != none)
    {
        PPM.TurnOffLightBlood();
    }
    //return;    
}

simulated function PlayBloodEffects(float Damage)
{
    // End:0x41
    if(!Outer.IsTimerActive(self, 'BloodEffects_T'))
    {
        BloodEffects_T(Damage);
    }
    //return;    
}

simulated function StopBloodEffects()
{
    StopPulseEffects();
    //return;    
}

simulated function PlayCameraShakes(float ShakeScale)
{
    local EvilPlayerController PC;

    PC = EvilPlayerController(Outer.Actor);
    PC.ClientPlayCameraShake(Shake, ShakeScale, true, 2, Rotator(PC.Location - PC.ViewTarget.Location));
    //return;    
}

simulated function PlayCameraAnim()
{
    local EvilPlayerController PC;

    PC = EvilPlayerController(Outer.Actor);
    PC.PlayCameraAnim(HitCameraAnim[Rand(HitCameraAnim.Length)],,,, 0.1000000,, true);
    //return;    
}

simulated function PulseEffects_T()
{
    local float Ratio;
    local EvilPlayer_interface EPI;
    local EvilPlayerController PC;

    PC = EvilPlayerController(Outer.Actor);
    // End:0x42
    if(PC == none)
    {
        return;
    }
    EPI = PC.GetPlayer();
    // End:0x210
    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        Ratio = (EPI.GetPlayerPawn().DefaultHealth * 0.7500000) - float(EPI.GetPlayerPawn().Health);
        Ratio = FClamp(Ratio * 0.0100000, 0.0750000, 2.0000000);
        Outer.GetPPManager().EnableLightBloodPulse(0.0000000, 1.1000000 * Ratio, 0.0250000, 0.1100000, 0.0250000, 45.0000000);
        // End:0x210
        if((EPI.GetPlayerPawn().DefaultHealth * 0.7500000) < float(EPI.GetPlayerPawn().Health))
        {
            StopPulseEffects();
        }
    }
    //return;    
}

simulated function BloodEffects_T(float Damage)
{
    local float Ratio;
    local EvilPlayerController PC;

    PC = EvilPlayerController(Outer.Actor);
    // End:0x42
    if(PC == none)
    {
        return;
    }
    Ratio = Damage;
    Ratio = FClamp(Ratio * 0.0500000, 0.0050000, 1.0000000);
    Outer.GetPPManager().EnableLightBloodPulse(0.2500000 * Ratio, Ratio * 0.4500000, Ratio * 0.1000000, Ratio * 0.0250000, Ratio * 0.3500000, 5.0000000);
    //return;    
}

simulated function BBPass_T()
{
    Outer.GetPPManager().EnableBleachBypass(true, BBOpacity);
    BBOpacity -= 0.0650000;
    // End:0xC0
    if(BBOpacity <= float(0))
    {
        Outer.GetPPManager().EnableBleachBypass(false);
        Outer.ClearTimer(self, 'BBPass_T');
    }
    //return;    
}

defaultproperties
{
    Shake=CameraShake'PP_Resources.PlayerHitCameraShake'
    HitCameraAnim[0]=CameraAnim'an_PlayerHit.HitWeapon1'
    HitCameraAnim[1]=CameraAnim'an_PlayerHit.HitWeapon2'
}