class R6InteractiveSOLActor extends R6InteractiveActor
    native
    config(Game)
    placeable
    hidecategories(lighting);

var(SOL) R6SOLVolume m_pLinkedSOLVolume;
var(SOL) string m_sInteractionDescId;
var bool m_bSolSettingUp;
var bool m_bSolActivated;

event RainbowInPosition(Actor placeholder)
{
    ActivateEventClass(Class'SeqEvent_R6SOLRainbowInPosition', placeholder, GeneratedEvents);
    return;
}

event SOLOrderGiven(Actor placeholder)
{
    ActivateEventClass(Class'SeqEvent_SOLOrderGiven', placeholder, GeneratedEvents);
    return;
}

event SOLAborted(Actor placeholder)
{
    ActivateEventClass(Class'SeqEvent_SOLCancelled', placeholder, GeneratedEvents);
    return;
}

function OnR6DisableInteraction(SeqAct_R6DisableInteraction Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_bInteractDisabled = false;        
    }
    else
    {
        // End:0x45
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_bInteractDisabled = true;
        }
    }
    // End:0x66
    if(m_pLinkedSOLVolume != none)
    {
        m_pLinkedSOLVolume.m_bInteractDisabled = m_bInteractDisabled;
    }
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    return false;
    return;
}

defaultproperties
{
    m_bCanBeUsedByTeam=false
    SupportedEvents=/* Array type was not detected. */
}