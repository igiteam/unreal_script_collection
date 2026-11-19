class AdvPlayerHitEffects extends EvilPlayerHitEffects within EvilLocalPlayer
    config(Game);

var() config float TunnelVisionThreshold;
var() config float DesaturationThreshold;

simulated function StopPulseEffects()
{
    super.StopPulseEffects();
    // End:0xB7
    if(ClassIsChildOf(Outer.Actor.WorldInfo.GRI.GameClass, Class'AdvGameMP_Base'))
    {
        AdvPostProcessManager(Outer.GetPPManager()).EnableVignette(false);
    }
    AdvLocalPlayer(Outer).SetNearDeathOverride(false);
    //return;    
}

simulated function PulseEffects_T()
{
    local float Ratio;
    local AdvPlayerPawn APP;
    local EvilPlayerController PC;
    local AdvPostProcessManager PPMgr;

    PC = EvilPlayerController(Outer.Actor);
    // End:0x42
    if(PC == none)
    {
        return;
    }
    APP = AdvPlayerPawn(PC.Pawn);
    PPMgr = AdvPostProcessManager(Outer.GetPPManager());
    // End:0x400
    if(APP != none)
    {
        Ratio = APP.DefaultHealth - float(APP.Health);
        Ratio = FClamp(Ratio * 0.0100000, 0.1000000, 2.0000000);
        PPMgr.EnableLightBloodPulse(0.0000000, 1.1000000 * Ratio, 0.0250000, 0.1100000, 0.0250000, 45.0000000);
        // End:0x1BB
        if(APP.DefaultHealth <= float(APP.Health))
        {
            StopPulseEffects();
            return;
        }
        // End:0x400
        if(ClassIsChildOf(APP.WorldInfo.GRI.GameClass, Class'AdvGameMP_Base'))
        {
            Ratio = float(APP.Health) / APP.DefaultHealth;
            // End:0x31E
            if(Ratio < TunnelVisionThreshold)
            {
                PPMgr.EnableVignette(true, FMin(9.0000000, (Sin(Outer.Actor.WorldInfo.TimeSeconds * 8.0000000) + 2.0000000) + (12.0000000 * (1.0000000 - (Ratio / TunnelVisionThreshold)))), 1.5000000);                
            }
            else
            {
                PPMgr.EnableVignette(false);
            }
            // End:0x3D5
            if(Ratio < DesaturationThreshold)
            {
                AdvLocalPlayer(Outer).SetNearDeathOverride(true, FMin(1.0000000, 1.5000000 * (1.0000000 - (Ratio / DesaturationThreshold))), Outer.GetTimerRate(self, 'PulseEffects_T'));                
            }
            else
            {
                AdvLocalPlayer(Outer).SetNearDeathOverride(false);
            }
        }
    }
    //return;    
}

defaultproperties
{
    TunnelVisionThreshold=0.7000000
    DesaturationThreshold=0.5000000
}