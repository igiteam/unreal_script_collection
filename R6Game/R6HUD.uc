class R6HUD extends HUD
    transient
    native
    config(Game)
    hidecategories(lighting);

var float m_fPlayerRecognitionDistance;
var float m_fCharacterWidth;
var float m_fCharacterHeight;
var string m_szDistanceIndicator;
var R6PlayerController m_pPC;
var float m_fLastReticleAlpha;
var float m_fLastNameAlpha;
var string m_szLastNameDisplayed;

// Export UR6HUD::execRenderHud(FFrame&, void* const)
native final function RenderHud();

simulated event PostRender()
{
    PostRender();
    RenderHud();
    return;
}

exec function ShowGadgetAnimDebug(string StartingPoint)
{
    SetAnimDebugTarget(R6Pawn(PlayerOwner.Pawn).m_pUsedGadget, StartingPoint);
    return;
}

exec function ShowTurretAnimDebug(string StartingPoint)
{
    SetAnimDebugTarget(R6Pawn(PlayerOwner.Pawn).m_operatedTurret, StartingPoint);
    return;
}

function DrawAnimDebugTarget()
{
    // End:0x42
    if(R6Gadget(AnimDebugThis) != none)
    {
        R6Gadget(AnimDebugThis).DrawAnimDebug(Canvas, AnimDebugStartingPoint, m_iAnimTreeOffsetX, m_iAnimTreeOffsetY, m_bAnimDebugRelevantOnly);        
    }
    else
    {
        // End:0x84
        if(R6Turret(AnimDebugThis) != none)
        {
            R6Turret(AnimDebugThis).DrawAnimDebug(Canvas, AnimDebugStartingPoint, m_iAnimTreeOffsetX, m_iAnimTreeOffsetY, m_bAnimDebugRelevantOnly);            
        }
        else
        {
            DrawAnimDebugTarget();
        }
    }
    return;
}

exec function ShowWeapAnimDebug(string StartingPoint)
{
    local R6Shield pShield;

    pShield = R6Shield(PlayerOwner.Pawn.Weapon);
    // End:0x4A
    if(pShield != none)
    {
        SetAnimDebugTarget(pShield.m_FireableWeapon, StartingPoint);        
    }
    else
    {
        SetAnimDebugTarget(PlayerOwner.Pawn.Weapon, StartingPoint);
    }
    return;
}
