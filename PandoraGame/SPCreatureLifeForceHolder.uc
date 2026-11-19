class SPCreatureLifeForceHolder extends SPLifeForceHolder
    placeable;

var SPDActionList PreSpawnLFActionList;
var SPDActionList OnTriggerActionList;
var SPDActionList PostSpawnLFActionList;

simulated function DBG_MsgLFH(string Str)
{
    //return;    
}

simulated function PostBeginPlay()
{
    Manager = Class'SPDProcessManager'.static.Get(none);
    // End:0x79
    if(Manager != none)
    {
        Manager.AddActionList(PreSpawnLFActionList, self, true);
        Manager.AddActionList(PostSpawnLFActionList, self, true);
        Manager.ActivatePending();
        Manager = none;
    }
    super.PostBeginPlay();
    //return;    
}

simulated function Destroyed()
{
    Manager = Class'SPDProcessManager'.static.Get(none);
    // End:0x42
    if(Manager != none)
    {
        Manager.AbortAllProcessForActor(self);
        Manager = none;
    }
    super.Destroyed();
    //return;    
}

simulated state Activated
{Begin:

    // End:0x63
    if((GetTargetPawn()) != none)
    {
        Manager = Class'SPDProcessManager'.static.Get(none);
        // End:0x59
        if(Manager != none)
        {
            Manager.AddActionList(OnTriggerActionList, self, true);
            Manager = none;
        }
        ProcessActivated();
    }
    stop;                    
}
