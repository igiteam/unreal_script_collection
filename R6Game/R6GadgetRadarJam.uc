class R6GadgetRadarJam extends R6GroupGadget
    native
    config(GadgetsConfig)
    hidecategories(lighting);

var config float m_fRadius;
var config float m_fEffectDuration;
var bool m_bUsing;
var SoundCue m_ActivationSound;
var SoundCue m_RechargedSound;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetOwner)
        m_bUsing;
}

// Export UR6GadgetRadarJam::execStartUsingRadarJam(FFrame&, void* const)
native final function StartUsingRadarJam();

simulated event bool CanUseGadget()
{
    // End:0x0E
    if(!CanUseGadget())
    {
        return false;
    }
    return !m_bUsing && m_iAmmo > 0;
    return;
}

function ResetUsing()
{
    local R6PlayerController pctrl;

    m_bUsing = false;
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

        // End:0xB1
        if(m_iAmmo > 0)
        {
            m_bUsing = true;
            SetTimer(m_fEffectDuration, false, 'ResetUsing');
            StartUsingRadarJam();
            pctrl = R6PlayerController(Instigator.Controller);
            // End:0x97
            if(pctrl != none)
            {
                // End:0x82
                if(pctrl.LocalPlayerController())
                {
                    pctrl.Pawn.PlaySound(m_ActivationSound, 4, true, true, true);
                }
                pctrl.ClientShowRadarJamFX(m_fEffectDuration);
            }
            m_iAmmo--;
            // End:0xB1
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
    m_fRadius=2500.0000000
    m_fEffectDuration=10.0000000
    m_ActivationSound=SoundCue'Dare.Player.Play_Multi_RadarJammer_ActivationSound'
    m_RechargedSound=SoundCue'Dare.Player.Play_Multi_RadarJammer_FullRechargeSound'
    m_iAmmo=10
    m_iMaxAmmoNormal=10
    m_iMaxAmmoVeteran=10
    m_iMaxAmmoElite=10
    m_iMaxAmmoMP=10
    m_bOnlyOneAllowed=true
    m_bCanUseInTakeCover=true
    m_bSelectable=true
    m_strGadgetIcon="ic_gadget_RadarJammer"
    ItemName="RADAR JAMMER"
}