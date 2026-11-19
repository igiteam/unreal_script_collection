class EPA_Shoot extends EPA_Aim;

function bool CanOverrideActionWith(byte NewAction)
{
    return (((int(NewAction) == 3) || int(NewAction) == 1) || int(NewAction) == 7) || int(NewAction) == 5;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return int(inAction) == 10;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local AnimNotifyEvent AnimNotifyEvent;
    local AnimNotify_Script AnimNotify;

    super.PawnActionStarted(bForced, PrevAction);
    // End:0x165
    if(AnimInfo.AnimName != 'None')
    {
        // End:0x164
        foreach PawnOwner.Mesh.FindAnimSequence(AnimInfo.AnimName).Notifies(AnimNotifyEvent)
        {
            AnimNotify = AnimNotify_Script(AnimNotifyEvent.Notify);
            // End:0x163
            if((AnimNotify != none) && (AnimNotify.NotifyName == 'OnStartFire') || AnimNotify.NotifyName == 'OnStartFireAlt')
            {
                bStartFireFromAnim = true;                
            }
            else
            {                
            }
        }        
    }
    // End:0x1FF
    if(!bStartFireFromAnim)
    {
        // End:0x1E0
        if(AnimInfo.AnimName != 'None')
        {
            PawnOwner.SetTimer(AnimInfo.BlendInTime, false, 'OnStartFire');            
        }
        else
        {
            PawnOwner.OnStartFire();
        }
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.OnStopFireWithLag();
    //return;    
}
