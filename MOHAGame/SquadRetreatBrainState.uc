class SquadRetreatBrainState extends SquadBrainState;

var Vector RunToPoint;
var array<Controller> Participants;
var int ArrivedRunners;
var int TotalRunners;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    GotoState('Start');
    //return;    
}

function ResetBrain()
{
    super(AxonBrainState).ResetBrain();
    Participants.Length = 0;
    ArrivedRunners = 0;
    TotalRunners = 0;
    //return;    
}

function RegisterActivationEvents()
{
    RegisterAxonActivationTimer(5.0000000, ActivationEventTripped);
    //return;    
}

function ActivationEventTripped()
{
    ActivateBrain();
    //return;    
}

function PreInitCoverFire(AxonBrainState Abs)
{
    PreInitializeDefault(Abs);
    //return;    
}

function PreInitRunners(AxonBrainState Abs)
{
    PreInitializeDefault(Abs);
    RetreatRunnerBrainState(Abs).RunToPoint = RunToPoint;
    TotalRunners++;
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

    // End:0x80 [Loop If]
    if(I < Members.Length)
    {
        Participants[Participants.Length] = Members[I];
        GiveOrderCustomCallback(Members[I], order, customCallback);
        I++;
        // [Loop Continue]
        goto J0x2F;
    }
    //return;    
}

function AssignCoverFireTeam()
{
    //return;    
}

function AssignRunningTeam()
{
    //return;    
}

function OnRolesAssigned()
{
    //return;    
}

function OnRunnersArrived()
{
    //return;    
}

state Start extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        local MOHAAIInvulneraPawn P, farPawn;
        local float farDist, checkDist;

        farDist = 0.0000000;
        // End:0x70
        foreach squad.AllActors(Class'MOHAAIInvulneraPawn', P)
        {
            checkDist = VSize(P.Location - squad.Location);
            // End:0x6F
            if(checkDist > farDist)
            {
                farDist = checkDist;
                farPawn = P;
            }            
        }        
        RunToPoint = farPawn.Location;
        RegisterAxonSubstateTimer(2.0000000, TimerExpired);
        //return;        
    }

    function TimerExpired()
    {
        GotoState('AssignRoles');
        //return;        
    }
    stop;    
}

state AssignRoles extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        local array<SubSquad> SubSquads;

        // End:0x33
        if(VSize2D(RunToPoint - squad.Location) < float(1000))
        {
            FinishBrain();
            return;
        }
        // End:0x74
        if(!squad.CreateSubSquads(squad.SquadMembers, 2, 2, 2, SubSquads))
        {
            GotoState('Start');
            return;
        }
        PushNearestPointRole(RunToPoint, AssignCoverFireTeam);
        PushFCFSRole(AssignRunningTeam);
        AssignRolesToSubsquads(SubSquads, OnRolesAssigned);
        //return;        
    }

    function AssignCoverFireTeam()
    {
        AssignRoleToAllMembers(Class'RetreatCoverFireBrainState', "Cover Fire Team", PreInitCoverFire);
        //return;        
    }

    function AssignRunningTeam()
    {
        AssignRoleToAllMembers(Class'RetreatRunnerBrainState', "Running Team", PreInitRunners);
        //return;        
    }

    function OnRolesAssigned()
    {
        GotoState('AwaitDone');
        //return;        
    }
    stop;    
}

state AwaitDone extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        PushEventStack();
        RegisterAxonNamedScriptEventListener('RunnersArrived', OnRunnersArrived);
        //return;        
    }

    function OnRunnersArrived()
    {
        ArrivedRunners++;
        // End:0x20
        if(TotalRunners <= ArrivedRunners)
        {
            OnAllRunnersArrived();
        }
        //return;        
    }

    function OnAllRunnersArrived()
    {
        local int I;

        PopEventStack();
        I = 0;
        J0x0D:

        // End:0x64 [Loop If]
        if(I < Participants.Length)
        {
            // End:0x5A
            if(Participants[I] != none)
            {
                KynapseAIController(Participants[I]).ABSS.TripNamedScriptEvent('FinishRetreat');
            }
            I++;
            // [Loop Continue]
            goto J0x0D;
        }
        GotoState('AssignRoles');
        //return;        
    }
    stop;    
}
