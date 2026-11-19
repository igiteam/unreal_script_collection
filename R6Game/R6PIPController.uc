class R6PIPController extends Object
    native;

enum EPIPModes
{
    PIP_SPECIAL,                    // 0
    PIP_SPECIAL_TEXTURE,            // 1
    PIP_HIDDEN,                     // 2
    PIP_MAX                         // 3
};

var R6PlayerController m_pPlayer;
var R6PIPController.EPIPModes m_ePIPMode;
var R6PIPController.EPIPModes m_ePIPBeforeSpecial;
var Actor m_pViewer;
var Texture m_pTexture;
var TextureMovie m_pMovie;
var bool m_bIsControllingMovie;
var float m_fTimerToClosePIPAnim;

// Export UR6PIPController::execReset(FFrame&, void* const)
native final function Reset();

// Export UR6PIPController::execHasPIPViewer(FFrame&, void* const)
native final function bool HasPIPViewer();

// Export UR6PIPController::execGetPIPViewer(FFrame&, void* const)
native final function Actor GetPIPViewer();

// Export UR6PIPController::execSetPIPMovie(FFrame&, void* const)
native final function SetPIPMovie(Texture pMovie, bool bControlMovie);

simulated function Init(R6PlayerController pPlayerController)
{
    m_pPlayer = pPlayerController;
    m_ePIPMode = 2;
    return;
}

function bool IsInSpecial()
{
    return (int(m_ePIPMode) == int(0)) || int(m_ePIPMode) == int(1);
    return;
}

simulated event SetMode(R6PIPController.EPIPModes eMode, optional bool bAllowSpecial)
{
    // End:0x1A
    if(!bAllowSpecial && IsInSpecial())
    {
        return;
    }
    m_ePIPMode = eMode;
    return;
}

simulated function RestorePreviousMode(R6PIPController.EPIPModes eOldMode, optional bool bAllowSpecial)
{
    // End:0x38
    if((int(eOldMode) != int(0)) && int(eOldMode) != int(1))
    {
        SetMode(eOldMode, bAllowSpecial);        
    }
    else
    {
        SetMode(2, bAllowSpecial);
    }
    return;
}

simulated event SetPIPSpecial(Actor pViewer)
{
    local R6Helicopter pHelicopter;
    local Actor pNewViewer;

    pNewViewer = pViewer;
    pHelicopter = R6Helicopter(pViewer);
    // End:0x3A
    if(pHelicopter != none)
    {
        pNewViewer = pHelicopter.m_pPIPCam;
    }
    // End:0x84
    if(pViewer != none)
    {
        // End:0x5F
        if(!IsInSpecial())
        {
            m_ePIPBeforeSpecial = m_ePIPMode;            
        }
        else
        {
            // End:0x77
            if(int(m_ePIPBeforeSpecial) != int(1))
            {
                m_ePIPBeforeSpecial = 2;
            }
        }
        SetMode(0, true);        
    }
    else
    {
        RestorePreviousMode(m_ePIPBeforeSpecial, true);
    }
    m_pViewer = pNewViewer;
    return;
}

simulated event SetPIPSpecialTexture(Texture pTexture, bool bControlMovie)
{
    // End:0x4A
    if(pTexture != none)
    {
        // End:0x25
        if(!IsInSpecial())
        {
            m_ePIPBeforeSpecial = m_ePIPMode;            
        }
        else
        {
            // End:0x3D
            if(int(m_ePIPBeforeSpecial) != int(0))
            {
                m_ePIPBeforeSpecial = 2;
            }
        }
        SetMode(1, true);        
    }
    else
    {
        RestorePreviousMode(m_ePIPBeforeSpecial, true);
    }
    SetPIPMovie(pTexture, bControlMovie);
    return;
}
