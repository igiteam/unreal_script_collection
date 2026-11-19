class TurokProgressAction extends TurokContextAction
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokProgressAction::execOnStart(FFrame&, void* const)
native function OnStart();

// Export UTurokProgressAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

auto state Inert
{    stop;    
}

state Disabled
{    stop;    
}

state Complete
{
    function BeginState(name PreviousState)
    {
        local @NULL pwn;

        pwn = Controller(Owner).Pawn;
        TurokProgressActionVolumeNative(mVolume).SetEnableStatus(false);
        TurokProgressActionVolumeNative(mVolume).TriggerEventClass(Class'TurokSeqEvent_CheckpointTouch', pwn);
        BroadcastLocalizedMessage(TurokProgressActionVolumeNative(mVolume).mProgressMessageClass, 0, Controller(Owner).PlayerReplicationInfo, none, none);
        GotoState('Disabled');
        //return;        
    }
    stop;    
}

defaultproperties
{
    mActivationMessageHash=-322562390
    mActivationMessageHash2=841962974
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
}