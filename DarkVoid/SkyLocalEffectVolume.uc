class SkyLocalEffectVolume extends LocalEffectVolume
    native;

struct native TouchedSkyPawnInfo
{
    var SkyPawn SkyPawn;
    var export editinline array<export editinline SkyLocalEffectComponent> SkyLocalEffectComponents;

    structdefaultproperties
    {
        SkyPawn=none
        SkyLocalEffectComponents=none
    }
};

var deprecated array<SkyLocalEffect> LocalEffects;
var() export editinline array<export editinline SkyLocalEffectSettings> LocalEffectsSettings;
var array<TouchedSkyPawnInfo> TouchedSkyPawns;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local SkyPawn TouchedSkyPawn;
    local int I;
    local editinline SkyLocalEffectComponent NewSkyLocalEffectComponent;
    local TouchedSkyPawnInfo NewTouchedSkyPawnInfo;

    TouchedSkyPawn = SkyPawn(Other);
    // End:0xFC
    if((TouchedSkyPawn != none) && TouchedSkyPawn.IsLocallyControlled() || (TouchedSkyPawn.DrivenVehicle != none) && TouchedSkyPawn.DrivenVehicle.IsLocallyControlled())
    {
        NewTouchedSkyPawnInfo.SkyPawn = TouchedSkyPawn;
        TouchedSkyPawns.AddItem(NewTouchedSkyPawnInfo);
        I = 0;
        J0x90:

        // End:0xFC [Loop If]
        if(I < LocalEffectsSettings.Length)
        {
            NewSkyLocalEffectComponent = TouchedSkyPawn.AddLocalEffect(LocalEffectsSettings[I]);
            // End:0xF2
            if(NewSkyLocalEffectComponent != none)
            {
                TouchedSkyPawns[TouchedSkyPawns.Length - 1].SkyLocalEffectComponents.AddItem(NewSkyLocalEffectComponent);
            }
            ++I;
            // [Loop Continue]
            goto J0x90;
        }
    }
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

simulated event UnTouch(Actor Other)
{
    local SkyPawn UntouchedSkyPawn;
    local int I, J;

    UntouchedSkyPawn = SkyPawn(Other);
    // End:0xE8
    if(UntouchedSkyPawn != none)
    {
        I = 0;
        J0x22:

        // End:0xE8 [Loop If]
        if(I < TouchedSkyPawns.Length)
        {
            // End:0xDE
            if((TouchedSkyPawns[I].SkyPawn != none) && TouchedSkyPawns[I].SkyPawn == UntouchedSkyPawn)
            {
                J = 0;
                J0x77:

                // End:0xD2 [Loop If]
                if(J < TouchedSkyPawns[I].SkyLocalEffectComponents.Length)
                {
                    UntouchedSkyPawn.RemoveLocalEffect(TouchedSkyPawns[I].SkyLocalEffectComponents[J]);
                    ++J;
                    // [Loop Continue]
                    goto J0x77;
                }
                TouchedSkyPawns.Remove(I, 1);
            }
            ++I;
            // [Loop Continue]
            goto J0x22;
        }
    }
    super(Actor).UnTouch(Other);
    //return;    
}
