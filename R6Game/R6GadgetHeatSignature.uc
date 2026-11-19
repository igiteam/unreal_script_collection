class R6GadgetHeatSignature extends R6GroupGadget
    native
    config(GadgetsConfig)
    hidecategories(lighting);

var config float m_fRadius;
var config float m_fEffectDuration;
var bool m_bInUse;
var SoundCue m_ActivationSound;
var SoundCue m_RechargedSound;
var SoundCue m_ScanningSound;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetOwner)
        m_bInUse;
}

// Export UR6GadgetHeatSignature::execServerStartUsingHeatSignature(FFrame&, void* const)
native final function ServerStartUsingHeatSignature();

simulated event bool CanUseGadget()
{
    // End:0x0E
    if(!CanUseGadget())
    {
        return false;
    }
    return !m_bInUse && m_iAmmo > 0;
    return;
}

function ResetInUse()
{
    local R6PlayerController pctrl;

    m_bInUse = false;
    // End:0x70
    if(Instigator != none)
    {
        pctrl = R6PlayerController(Instigator.Controller);
        // End:0x70
        if((pctrl != none) && pctrl.LocalPlayerController())
        {
            pctrl.Pawn.PlaySound(m_RechargedSound, 4, true, true, true);
        }
    }
    return;
}

auto state Ready
{
    function UseGadget()
    {
        local R6PlayerController pctrl;

        // End:0xD5
        if(m_iAmmo > 0)
        {
            ServerStartUsingHeatSignature();
            m_bInUse = true;
            SetTimer(m_fEffectDuration, false, 'ResetInUse');
            pctrl = R6PlayerController(Instigator.Controller);
            // End:0xBB
            if(pctrl != none)
            {
                // End:0xA6
                if(pctrl.LocalPlayerController())
                {
                    pctrl.Pawn.PlaySound(m_ActivationSound, 4, true, true, true);
                    pctrl.Pawn.PlaySound(m_ScanningSound, 4, true, true, true);
                }
                pctrl.ClientShowHeatSignatureFX(m_fEffectDuration);
            }
            m_iAmmo--;
            // End:0xD5
            if(m_iAmmo <= 0)
            {
                m_bExhausted = true;
            }
        }
        EndUseGadget();
        return;
    }
    stop;
}

defaultproperties
{
    m_fRadius=1800.0000000
    m_fEffectDuration=8.0000000
    m_ActivationSound=SoundCue'Dare.Player.Play_Multi_GPS_ActivationSound'
    m_RechargedSound=SoundCue'Dare.Player.Play_Multi_GPS_FullRechargeSound'
    m_ScanningSound=SoundCue'Dare.Player.Play_Multi_GPS_ScanSound'
    m_iAmmo=10
    m_iMaxAmmoNormal=5
    m_iMaxAmmoVeteran=5
    m_iMaxAmmoElite=5
    m_iMaxAmmoMP=5
    m_bOnlyOneAllowed=true
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_strGadgetIcon="ic_gadget_GPSdevice"
    ItemName="GPS DEVICE"
}