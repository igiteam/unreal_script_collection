class R6SnakeCamViewer extends Actor
    native
    notplaceable
    hidecategories(lighting);

var int m_iYawModifier;
var int m_iPitchModifier;
var R6GameEnums.ESnakeCamPos m_eWantedPos;
var float m_fZoomTimer;
var float m_fFOVDest;
var float m_fFOV;
var native const Pointer SceneViewState;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && !bNetOwner)
        m_iPitchModifier, m_iYawModifier;
}

// Export UR6SnakeCamViewer::execGetViewPosRot(FFrame&, void* const)
native final function GetViewPosRot(out Vector vLoc, out Rotator rRot);

simulated function PostBeginPlay()
{
    PostBeginPlay();
    m_fFOVDest = GetGadgetsConfig().m_fSnakeCamFOV;
    m_fFOV = m_fFOVDest;
    return;
}

simulated function bool IsZoomed()
{
    return m_fFOVDest == GetGadgetsConfig().m_fSnakeCamFOV;
    return;
}

simulated event ToggleZoom()
{
    // End:0x33
    if(IsZoomed())
    {
        m_fFOVDest = GetGadgetsConfig().m_fSnakeCamFOV * GetGadgetsConfig().m_fSnakeCamZoomedFOV;        
    }
    else
    {
        m_fFOVDest = GetGadgetsConfig().m_fSnakeCamFOV;
    }
    m_fZoomTimer = GetGadgetsConfig().m_fSnakeCamZoomTransitionTime - m_fZoomTimer;
    return;
}

simulated event GetPIPInfo(out sPIPInfo pipInfo)
{
    GetViewPosRot(pipInfo.vLocation, pipInfo.rRotation);
    pipInfo.fFov = m_fFOV;
    pipInfo.fAspectRatio = 1.0000000;
    // End:0xA2
    if(Instigator.Controller != none)
    {
        pipInfo.bDistortionEnable = true;
        pipInfo.fDistortionStrength = -1.0000000;
        pipInfo.fDistortionScale = -1.0000000;
        pipInfo.EVisionMode = Instigator.Controller.GetVisionMode();        
    }
    else
    {
        pipInfo.bDistortionEnable = false;
        pipInfo.EVisionMode = 0;
    }
    return;
}

event MoveSnakeCam(R6GameEnums.ESnakeCamPos ePos)
{
    // End:0x51
    if(((int(m_eWantedPos) == int(1)) && int(ePos) == int(3)) || (int(m_eWantedPos) == int(3)) && int(ePos) == int(1))
    {
        m_eWantedPos = 2;        
    }
    else
    {
        m_eWantedPos = ePos;
    }
    return;
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    GetViewPosRot(out_Location, out_Rotation);
    return;
}

simulated function float GetViewFOV()
{
    return m_fFOV;
    return;
}

defaultproperties
{
    bReplicateInstigator=true
    m_bPlayerUseAsCam=true
    RemoteRole=1
}