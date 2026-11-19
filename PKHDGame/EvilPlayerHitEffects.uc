class EvilPlayerHitEffects extends Actor
    notplaceable
    hidecategories(Navigation);

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

    PC = EvilPlayerController(Owner);
    // End:0x172
    if(PC != none)
    {
        EPI = PC.GetPlayer();
        // End:0x172
        if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
        {
            Ratio = Damage / EPI.GetPlayerPawn().DefaultHealth;
            PC.GetPPManager().EnableMediumBlood(FClamp(Ratio * 0.6500000, 0.0500000, 0.6000000), int(FClamp(float(int(Ratio * (0.2500000 + float(Rand(5))))), 0.0000000, 1.0000000)));
            BBOpacity = 0.3500000;
            // End:0x172
            if(bBBPass)
            {
                SetTimer(0.0300000, true, 'BBPass_T');
            }
        }
    }
    //return;    
}

simulated function PlayPulseEffects(float Damage)
{
    // End:0x2C
    if(!IsTimerActive('PulseEffects_T'))
    {
        SetTimer(0.1600000, true, 'PulseEffects_T');
    }
    //return;    
}

simulated function StopPulseEffects()
{
    local EvilPlayerController PC;
    local EvilPostProcessManager PPM;

    PC = EvilPlayerController(Owner);
    // End:0x47
    if(IsTimerActive('PulseEffects_T'))
    {
        ClearTimer('PulseEffects_T');
    }
    // End:0xAD
    if(PC != none)
    {
        PPM = PC.GetPPManager();
        // End:0xAD
        if(PPM != none)
        {
            PPM.TurnOffLightBlood();
        }
    }
    //return;    
}

simulated function PlayBloodEffects(float Damage)
{
    // End:0x2C
    if(!IsTimerActive('BloodEffects_T'))
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

    PC = EvilPlayerController(Owner);
    PC.ClientPlayCameraShake(Shake, ShakeScale, true, 2, Rotator(Owner.Location - PC.ViewTarget.Location));
    //return;    
}

simulated function PlayCameraAnim()
{
    local EvilPlayerController PC;

    PC = EvilPlayerController(Owner);
    PC.PlayCameraAnim(HitCameraAnim[Rand(HitCameraAnim.Length)],,,, 0.1000000,, true);
    //return;    
}

simulated function PulseEffects_T()
{
    local float Ratio;
    local EvilPlayer_interface EPI;
    local EvilPlayerController PC;

    PC = EvilPlayerController(Owner);
    // End:0x2D
    if(PC == none)
    {
        return;
    }
    EPI = PC.GetPlayer();
    // End:0x1F4
    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        Ratio = EPI.GetPlayerPawn().DefaultHealth - float(EPI.GetPlayerPawn().Health);
        Ratio = FClamp(Ratio * 0.0050000, 0.0750000, 2.0000000);
        PC.GetPPManager().EnableLightBloodPulse(0.0000000, 1.1000000 * Ratio, 0.0250000, 0.1100000, 0.0250000, 45.0000000);
        // End:0x1F4
        if((EPI.GetPlayerPawn().DefaultHealth * 0.9900000) < float(EPI.GetPlayerPawn().Health))
        {
            StopPulseEffects();
        }
    }
    //return;    
}

simulated function BloodEffects_T(float Damage)
{
    local float Ratio, ratioT;
    local EvilPlayerController PC;

    PC = EvilPlayerController(Owner);
    // End:0x2D
    if(PC == none)
    {
        return;
    }
    Ratio = Damage;
    Ratio = FClamp(Ratio * 0.0750000, 0.0050000, 0.8500000);
    ratioT = 0.3000000;
    PC.GetPPManager().EnableLightBloodPulse(0.1500000 * Ratio, Ratio * 0.3500000, ratioT * 0.0100000, ratioT * 0.0500000, ratioT * 0.5500000, 1.5000000);
    //return;    
}

simulated function BBPass_T()
{
    EvilPlayerController(Owner).GetPPManager().EnableBleachBypass(true, BBOpacity);
    BBOpacity -= 0.0650000;
    // End:0x7D
    if(BBOpacity <= float(0))
    {
        ClearTimer('BBPass_T');
    }
    //return;    
}

defaultproperties
{
    Shake=CameraShake'PP_Resources.PlayerHitCameraShake'
    HitCameraAnim[0]=CameraAnim'an_PlayerHit.HitWeapon1'
    HitCameraAnim[1]=CameraAnim'an_PlayerHit.HitWeapon2'
    CollisionType=ECollisionType.COLLIDE_CustomDefault
}