class R6InteractiveSwitch extends R6InteractiveActor
    native
    config(Game)
    editinlinenew
    placeable
    hidecategories(lighting,Object);

const NumberOfLights = 6;

var repnotify R6BreakableLight m_Lights[6];
var(Switch) repnotify bool m_bOn;
var bool sm_bOn;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_Lights, m_bOn;
}

// Export UR6InteractiveSwitch::execUpdateLight(FFrame&, void* const)
native final function UpdateLight();

// Export UR6InteractiveSwitch::execPlayInteractionSound(FFrame&, void* const)
native function PlayInteractionSound(R6InteractiveActor.EInteractionSound eSoundInteraction);

function PostBeginPlay()
{
    PostBeginPlay();
    UpdateLight();
    return;
}

function SaveOriginalData()
{
    sm_bOn = m_bOn;
    SaveOriginalData();
    return;
}

function ResetOriginalData()
{
    m_bOn = sm_bOn;
    UpdateLight();
    ResetOriginalData();
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    InteractSuccesful(pInteractor);
    m_bOn = !m_bOn;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    UpdateLight();
    return;
}

defaultproperties
{
    m_eInteractDesc=23
}