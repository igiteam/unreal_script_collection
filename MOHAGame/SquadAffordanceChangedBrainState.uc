class SquadAffordanceChangedBrainState extends SquadBrainState;

var array<KynapseAIController> Participants;
var int ArrivedRunners;
var int TotalRunners;
var KynapseSquadNode SquadDest;
var KynapseSquadNode PreviousNode;
var export editinline AxonAffordanceService AffordanceService;
var bool bVerboseDebug;

function StartBrain()
{
    // End:0x09
    if(bVerboseDebug)
    {
    }
    super(AxonBrainState).StartBrain();
    GotoState('ParentState');
    //return;    
}

function ResetBrain()
{
    super(AxonBrainState).ResetBrain();
    //return;    
}

function RegisterActivationEvents()
{
    AffordanceService.RegisterAxonActivationOnNewAffordanceDest(ActivationEventTripped, 2);
    //return;    
}

function ActivationEventTripped()
{
    // End:0x1B
    if(AffordanceService.GetLastAssignmentWasRetreat() == false)
    {
        return;
    }
    SquadDest = AffordanceService.GetSquadNodeFromCallback();
    PreviousNode = AffordanceService.GetPrevSquadNodeFromCallback();
    // End:0x6F
    if((SquadDest != none) && PreviousNode != none)
    {
        ActivateBrain();
    }
    //return;    
}

function PreInitCoverFire(AxonBrainState Abs)
{
    // End:0x09
    if(bVerboseDebug)
    {
    }
    PreInitializeDefault(Abs);
    //return;    
}

function PreInitRunners(AxonBrainState Abs)
{
    // End:0x09
    if(bVerboseDebug)
    {
    }
    PreInitializeDefault(Abs);
    RetreatRunnerBrainState(Abs).RunToPoint = SquadDest.GetSafeTraversalStartPos();
    TotalRunners++;
    //return;    
}

function PreInitRoutees(AxonBrainState Abs)
{
    // End:0x09
    if(bVerboseDebug)
    {
    }
    PreInitializeDefault(Abs);
    RetreatAffordanceGotoBrainState(Abs).SquadDest = SquadDest;
    TotalRunners++;
    //return;    
}

function ResetVars()
{
    Participants.Length = 0;
    ArrivedRunners = 0;
    TotalRunners = 0;
    //return;    
}

function AssignRoleToAllMembers(class<AxonSquadOrderBrainState> order, string Desc, delegate<PreInitializeOrder> customCallback)
{
    local array<Controller> Members;
    local int I;

    PopulateMembersForRole(Members);
    CreateSubSquadMonitor(Members, Desc, 5.0000000);
    I = 0;
    J0x2F:

    // End:0x85 [Loop If]
    if(I < Members.Length)
    {
        Participants[Participants.Length] = KynapseAIController(Members[I]);
        GiveOrderCustomCallback(Members[I], order, customCallback);
        I++;
        // [Loop Continue]
        goto J0x2F;
    }
    //return;    
}

function NewAffordanceDest()
{
    SquadDest = AffordanceService.GetSquadNodeFromCallback();
    PreviousNode = AffordanceService.GetPrevSquadNodeFromCallback();
    // End:0x57
    if((SquadDest != none) && PreviousNode != none)
    {
        OnAllRunnersArrived();        
    }
    else
    {
        FinishBrain();
    }
    //return;    
}

function OnAllRunnersArrived()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x59 [Loop If]
    if(I < Participants.Length)
    {
        // End:0x4F
        if(Participants[I] != none)
        {
            Participants[I].ABSS.TripNamedScriptEvent('FinishRetreat');
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    GotoState('Start');
    //return;    
}

function OnRunnersArrived()
{
    //return;    
}

state ParentState extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AffordanceService.SubstateOnNewAffordanceDest(NewAffordanceDest);
        PushEventStack();
        GotoState('Start');
        //return;        
    }
    stop;    
}

state Start extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        ResetVars();
        RegisterAxonSubstateTimer(0.0000000, OnTimerDone);
        //return;        
    }

    function OnTimerDone()
    {
        GotoState('AssignRoles');
        //return;        
    }
    stop;    
}

state AssignRoles extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        local array<SubSquad> SubSquads;
        local array<Controller> membersInNode, routedTroops;
        local Vector RunToPoint;

        FindAllInAffordance(SquadDest, membersInNode, routedTroops);
        // End:0x31
        if(routedTroops.Length == 0)
        {
            FinishBrain();
            return;
        }
        FindAllInAffordance(PreviousNode, membersInNode, routedTroops);
        // End:0xD1
        if(squad.CreateSubSquads(membersInNode, 2, 2, 2, SubSquads))
        {
            RunToPoint = SquadDest.GetSafeTraversalStartPos();
            PushNearestPointRole(RunToPoint, AssignCoverFireTeam);
            PushFCFSRole(AssignRunningTeam);
            AssignRolesToSubsquads(SubSquads, OnRolesAssigned);
            return;            
        }
        else
        {
            // End:0x129
            if(membersInNode.Length > 0)
            {
                SubSquads.Length = 1;
                SubSquads[0].Members = membersInNode;
                PushFCFSRole(AssignRoutedTeam);
                AssignRolesToSubsquads(SubSquads, OnRolesAssigned);
                return;
            }
        }
        FinishBrain();
        //return;        
    }

    function AssignCoverFireTeam()
    {
        AssignRoleToAllMembers(Class'RetreatAffordanceGotoBrainState', "Routed Team", PreInitRoutees);
        //return;        
    }

    function AssignRunningTeam()
    {
        AssignRoleToAllMembers(Class'RetreatAffordanceGotoBrainState', "Routed Team", PreInitRoutees);
        //return;        
    }

    function AssignRoutedTeam()
    {
        AssignRoleToAllMembers(Class'RetreatAffordanceGotoBrainState', "Routed Team", PreInitRoutees);
        //return;        
    }

    function OnRolesAssigned()
    {
        GotoState('AwaitDone');
        //return;        
    }
    stop;    
}

state AwaitDone extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonNamedScriptEventListener('RunnersArrived', OnRunnersArrived);
        //return;        
    }

    function OnRunnersArrived()
    {
        ArrivedRunners++;
        // End:0x24
        if(TotalRunners <= ArrivedRunners)
        {
            GotoState('AllRunnersArrived');
        }
        //return;        
    }
    stop;    
}

state AllRunnersArrived extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        OnAllRunnersArrived();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonAffordanceService'Default__SquadAffordanceChangedBrainState.AffordanceService0'
    begin object name=AffordanceService0 class=Class'EAKynapse.AxonAffordanceService'
    end object
    AffordanceService=AffordanceService0
    EventServices=/* Array type was not detected. */
}