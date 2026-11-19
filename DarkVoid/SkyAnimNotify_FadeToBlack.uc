class SkyAnimNotify_FadeToBlack extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() Color FadeColor;
var() float FadeToBlackDelayTime;
var() float FadeToBlackTime;
var() bool bDisableToggleFading;
var() bool bFadingToBlack;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;
    local PlayerController PC;

    SP = SkyPawn(Owner);
    // End:0xC9
    if(SP != none)
    {
        PC = PlayerController(SP.Controller);
        // End:0x64
        if(PC == none)
        {
            PC = PlayerController(SP.DrivenVehicle.Controller);
        }
        // End:0xC9
        if((PC != none) && SkyCamera(PC.PlayerCamera) != none)
        {
            SkyCamera(PC.PlayerCamera).SetFadeToBlack(FadeColor, FadeToBlackDelayTime, FadeToBlackTime, bDisableToggleFading, bFadingToBlack);
        }
    }
    //return;    
}
