class SkyAnimNotify_ManualTransition extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bEnabled;
var() bool bSetPrimary;
var() bool bSetSecondary;
var() bool bAllowPrimary;
var() bool bAllowSecondary;
var() bool bUpdateAllPrimary;
var() bool bUpdateAllSecondary;
var() float fDurationPrimary;
var() float fDurationSecondary;

simulated event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x1D
    if(!bEnabled)
    {
        return;
    }
    // End:0x120
    if(SP != none)
    {
        // End:0x7D
        if(bSetPrimary)
        {
            SP.ClearTimer(SP.ManualTransition_PWSM_FailSafeTimerName);
            // End:0x7D
            if(bAllowPrimary)
            {
                SP.SetTimer(fDurationPrimary, false, SP.ManualTransition_PWSM_FailSafeTimerName);
            }
        }
        // End:0xD2
        if(bSetSecondary)
        {
            SP.ClearTimer(SP.ManualTransition_SWSM_FailSafeTimerName);
            // End:0xD2
            if(bAllowSecondary)
            {
                SP.SetTimer(fDurationSecondary, false, SP.ManualTransition_SWSM_FailSafeTimerName);
            }
        }
        // End:0xF9
        if(bUpdateAllPrimary)
        {
            SP.PrimaryWSM.AttachWeaponToPawn();
        }
        // End:0x120
        if(bUpdateAllSecondary)
        {
            SP.SecondaryWSM.AttachWeaponToPawn();
        }
    }
    //return;    
}
