class SkyAnimNotify_LockInput extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() array<LockedInputState> InputsToLock;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;
    local SkyPlayerInput SPI;
    local int I;

    SP = SkyPawn(Owner);
    // End:0x60
    if((SP != none) && PlayerController(SP.Controller) != none)
    {
        SPI = SkyPlayerInput(PlayerController(SP.Controller).PlayerInput);
    }
    // End:0x6D
    if(SPI == none)
    {
        return;
    }
    I = 0;
    J0x74:

    // End:0xCE [Loop If]
    if(I < InputsToLock.Length)
    {
        SPI.LockKey(InputsToLock[I].Label, InputsToLock[I].Time);
        ++I;
        // [Loop Continue]
        goto J0x74;
    }
    //return;    
}
