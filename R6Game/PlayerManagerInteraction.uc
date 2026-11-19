class PlayerManagerInteraction extends Interaction within GameViewportClient
    transient
    native;

var int m_idRenderMaster;
var int m_idInputMaster;
var int m_idRerouteReceiver;

event bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed)
{
    local LocalPlayer TargetPlayer;
    local int InteractionIndex;
    local PlayerController pPC;
    local int iTargetId;

    1.0000000
    iTargetId = ((m_idRerouteReceiver == -1) ? ControllerId : m_idRerouteReceiver);
    TargetPlayer = Outer.FindPlayerByControllerId(iTargetId);
    // End:0x157
    if((TargetPlayer != none) && (m_idInputMaster == -1) || m_idInputMaster == ControllerId)
    {
        // End:0x9C
        if(TargetPlayer.m_pRedirectInput != none)
        {
            pPC = TargetPlayer.m_pRedirectInput;            
        }
        else
        {
            pPC = TargetPlayer.Actor;
        }
        InteractionIndex = 0;
        J0xB7:

        // End:0x157 [Loop If]
        if(InteractionIndex < pPC.Interactions.Length)
        {
            // End:0x14D
            if(((pPC.Interactions[InteractionIndex] != none) && pPC.Interactions[InteractionIndex].CanProcessKey(Key)) && pPC.Interactions[InteractionIndex].InputKey(ControllerId, Key, Event, AmountDepressed))
            {
                return true;
            }
            InteractionIndex++;
            // [Loop Continue]
            goto J0xB7;
        }
    }
    return false;
    return;
}

event bool InputChar(int ControllerId, string Unicode)
{
    local LocalPlayer TargetPlayer;
    local int InteractionIndex, iTargetId;

    iTargetId = ((m_idRerouteReceiver == -1) ? ControllerId : m_idRerouteReceiver);
    TargetPlayer = Outer.FindPlayerByControllerId(iTargetId);
    // End:0xF7
    if((TargetPlayer != none) && (m_idInputMaster == -1) || m_idInputMaster == ControllerId)
    {
        InteractionIndex = 0;
        J0x6F:

        // End:0xF7 [Loop If]
        if(InteractionIndex < TargetPlayer.Actor.Interactions.Length)
        {
            // End:0xED
            if((TargetPlayer.Actor.Interactions[InteractionIndex] != none) && TargetPlayer.Actor.Interactions[InteractionIndex].InputChar(ControllerId, Unicode))
            {
                return true;
            }
            InteractionIndex++;
            // [Loop Continue]
            goto J0x6F;
        }
    }
    return false;
    return;
}

defaultproperties
{
    m_idRenderMaster=-1
    m_idInputMaster=-1
    m_idRerouteReceiver=-1
}