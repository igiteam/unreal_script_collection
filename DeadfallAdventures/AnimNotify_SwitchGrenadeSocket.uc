class AnimNotify_SwitchGrenadeSocket extends AnimNotify_Scripted
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() name SocketName;
var name SavedSocketName;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local EvilPawn EP;

    EP = EvilPawn(Owner);
    // End:0xA9
    if((EP != none) && EP.GrenadeSocket != SocketName)
    {
        SavedSocketName = EP.GrenadeSocket;
        EP.GrenadeSocket = SocketName;
    }
    //return;    
}

event NotifyEnd(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local EvilPawn EP;

    EP = EvilPawn(Owner);
    // End:0x6C
    if((EP != none) && SavedSocketName != 'None')
    {
        EP.GrenadeSocket = SavedSocketName;
    }
    //return;    
}
