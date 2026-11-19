class TurokHackAction extends TurokContextAction
    abstract
    native
    nativereplication
    notplaceable
    hidecategories(Navigation);

var protected repnotify @NULL mTerminal;
var byte mTeam;
var @NULL mPawn;
var float mMultiplier;
var bool mWeAreHacking;

replication
{
    // Pos:0x000
    if(bNetDirty && bNetOwner
        mTeam, mTerminal, 
        mWeAreHacking;
}

// Export UTurokHackAction::execSetTerminal(FFrame&, void* const)
native function SetTerminal(@NULL Terminal);

// Export UTurokHackAction::execIsFinished(FFrame&, void* const)
native function bool IsFinished();

// Export UTurokHackAction::execOnStart(FFrame&, void* const)
native function OnStart();

// Export UTurokHackAction::execOnUpdate(FFrame&, void* const)
native function OnUpdate(float DeltaTime);

// Export UTurokHackAction::execOnCancel(FFrame&, void* const)
native function OnCancel();

// Export UTurokHackAction::execOnInterrupt(FFrame&, void* const)
native function OnInterrupt();

// Export UTurokHackAction::execOnEnd(FFrame&, void* const)
native function OnEnd();

// Export UTurokHackAction::execOnComplete(FFrame&, void* const)
native function OnComplete();

event @NULL GetTransitionGraphSet()
{
    // End:0x32
    if(mTerminal != none)
    {
        return mTerminal.GetHackGraphSet(Controller(Owner).Pawn);
    }
    return none;
    //return ReturnValue;    
}

// Export UTurokHackAction::execGetProgressPercent(FFrame&, void* const)
native simulated function float GetProgressPercent();

// Export UTurokHackAction::execIsInProgress(FFrame&, void* const)
native simulated function bool IsInProgress();

// Export UTurokHackAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);

// Export UTurokHackAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

simulated function EndPrematurely()
{
    GotoState('Inert');
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x63
    if(VarName == 'mTerminal')
    {
        // End:0x3B
        if(mTerminal.mInstructionHash != 0)
        {
            mActivationMessageHash = mTerminal.mInstructionHash;
        }
        // End:0x63
        if(mTerminal.mInstructionHash2 != 0)
        {
            mActivationMessageHash2 = mTerminal.mInstructionHash2;
        }
    }
    //return;    
}

auto state Inert
{
    function BeginState(name PreviousState)
    {
        mWeAreHacking = false;
        super(Object).BeginState(PreviousState);
        //return;        
    }
    stop;    
}

state Cancel
{
    function BeginState(name PreviousState)
    {
        GotoState('Inert');
        //return;        
    }
    stop;    
}

state InProgress
{
    function BeginState(name PreviousState)
    {
        mWeAreHacking = true;
        super(Object).BeginState(PreviousState);
        //return;        
    }
    stop;    
}

state Complete
{
    function BeginState(name PreviousState)
    {
        Triggered();
        PlaySound(mTerminal.mHackCompleteSoundCue, false, false);
        //return;        
    }

    event Triggered()
    {
        // End:0xD3
        if(TurokWarGame(WorldInfo.Game) != none)
        {
            // End:0x7B
            if(Controller(Owner).PlayerReplicationInfo != none)
            {
                // End:0x78
                if(TurokMPGame(WorldInfo.Game) != none)
                {
                    TurokMPGame(WorldInfo.Game).ScoreObjectivePoints(Controller(Owner), 1);
                }                
            }
            else
            {
                // End:0xD3
                if(TurokMPGame(WorldInfo.Game) != none)
                {
                    TurokMPGame(WorldInfo.Game).ScoreObjectivePoints(TurokAIControllerHumanFriendly(Owner).mActivePlayer.Controller, 4);
                }
            }
        }
        mTerminal.TriggerEventClass(Class'TurokSeqEvent_HackComplete', mPawn);
        //return;        
    }
    stop;    
}

defaultproperties
{
    mMultiplier=1.0000000
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
}