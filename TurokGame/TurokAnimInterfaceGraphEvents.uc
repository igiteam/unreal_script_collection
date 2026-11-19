interface TurokAnimInterfaceGraphEvents extends Interface
    abstract;

simulated function GraphEvent(@NULL Event, byte actorType)
{
    //return;    
}

simulated function int GraphBranch(@NULL branch, byte actorType)
{
    //return ReturnValue;    
}

simulated function bool GraphInterrupt(@NULL Item, byte actorType)
{
    //return ReturnValue;    
}

simulated function float GraphBlend(@NULL blend)
{
    //return ReturnValue;    
}
