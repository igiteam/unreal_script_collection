class TurokBombAction extends TurokContextAction
    abstract
    native
    nativereplication
    notplaceable
    hidecategories(Navigation);

var @NULL mBomb;
var float mRequiredTime;

replication
{
    // Pos:0x000
    if(bNetOwner && bNetInitial
        mRequiredTime;
}

// Export UTurokBombAction::execIsFinished(FFrame&, void* const)
native function bool IsFinished();

// Export UTurokBombAction::execOnStart(FFrame&, void* const)
native function OnStart();

// Export UTurokBombAction::execOnUpdate(FFrame&, void* const)
native function OnUpdate(float DeltaTime);

// Export UTurokBombAction::execOnCancel(FFrame&, void* const)
native function OnCancel();

// Export UTurokBombAction::execOnInterrupt(FFrame&, void* const)
native function OnInterrupt();

// Export UTurokBombAction::execOnEnd(FFrame&, void* const)
native function OnEnd();

simulated function EndPrematurely()
{
    GotoState('Inert');
    //return;    
}

// Export UTurokBombAction::execGetProgressPercent(FFrame&, void* const)
native simulated function float GetProgressPercent();

// Export UTurokBombAction::execIsInProgress(FFrame&, void* const)
native simulated function bool IsInProgress();

auto state Inert
{
    function BeginState(name PreviousStateName)
    {
        // End:0x2D
        if(TurokBombActionVolume(mVolume) != none)
        {
            TurokBombActionVolume(mVolume).SetProgress(0.0000000);
        }
        //return;        
    }
    stop;    
}

state InProgress
{    stop;    
}

state Complete
{    stop;    
}

defaultproperties
{
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
}