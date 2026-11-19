class AdvFocusHighlightComponent_Upgrades extends AdvFocusHighlightComponent
    editinlinenew
    hidecategories(Object,Physics,Collision);

protected static simulated function class<AdvFocusHighlightComponent> GetComponentClass()
{
    return Class'AdvFocusHighlightComponent_Upgrades';
    //return ReturnValue;    
}

function UpdateOverlayOpacity()
{
    local editinline MeshComponent MC;
    local int I;
    local MaterialInstanceConstant MIC;

    // End:0x72
    if(Opacity < 0.0000000)
    {
        Opacity += (0.0300000 * FadeSpeed);
        // End:0x6F
        if(Opacity > 0.0000000)
        {
            KillOverlays();
            ClearTimer('UpdateOverlayOpacity');
            Opacity = 0.0000000;
            return;
        }        
    }
    else
    {
        Opacity += (0.0300000 * FadeSpeed);
        // End:0xC2
        if(Opacity > 1.0000000)
        {
            ClearTimer('UpdateOverlayOpacity');
            Opacity = 1.0000000;
        }
    }
    // End:0x1A9
    foreach Overlays(MC)
    {
        I = 0;
        J0xE4:

        // End:0x1A8 [Loop If]
        if(I < MC.GetNumElements())
        {
            MIC = MaterialInstanceConstant(MC.GetMaterial(I));
            // End:0x15E
            if(MIC == none)
            {                
            }
            else
            {
                MIC.SetScalarParameterValue('Activate', Opacity * Opacity);
            }
            ++I;
            // [Loop Continue]
            goto J0xE4;
        }        
    }    
    //return;    
}

defaultproperties
{
    HighlightMaterial=MaterialInstanceConstant'adv_ps_Upgrade.Materials.mi_en_EgyptTreasure_01'
    SkeletalHighlightMaterial=MaterialInstanceConstant'adv_ps_Upgrade.Materials.mi_en_EgyptTreasure_01'
    Template=ParticleSystem'adv_ps_Upgrade.Effects.ps_Upgrade'
    ReplacementPrimitive=none
}