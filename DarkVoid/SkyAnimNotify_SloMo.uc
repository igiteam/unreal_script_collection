class SkyAnimNotify_SloMo extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() float Speed;
var() float ResetTime;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local float CurrentGameSpeed;

    // End:0xB9
    if(Owner != none)
    {
        CurrentGameSpeed = Owner.WorldInfo.Game.GameSpeed;
        Owner.WorldInfo.Game.SetGameSpeed(Speed);
        // End:0xB9
        if((SkyPawn(Owner) != none) && ResetTime > 0.0000000)
        {
            SkyPawn(Owner).SlomoAnimNotifyResetSpeed = CurrentGameSpeed;
            Owner.SetTimer(ResetTime, false, 'SlomoAnimNotifyTimer');
        }
    }
    //return;    
}
