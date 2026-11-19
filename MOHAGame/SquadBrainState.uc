class SquadBrainState extends AxonBrainState
    abstract;

const SBS_IDLE = 0;
const SBS_COMBATMANEUVER = 1;
const SBS_AFFORDANCEMANEUVER = 2;

var KynapseSquad squad;
var class<SubSquadMonitor> MonitorClass;
var bool bShouldCreateMonitor;
var array<Controller> splitMembers;
//var delegate<PreInitializeOrder> __PreInitializeOrder__Delegate;

function InitializeAxonBrainState(AxonBrainStateStack iOwningBSS, Actor OwningActor)
{
    // End:0x20
    if(KynapseSquad(OwningActor) != none)
    {
        squad = KynapseSquad(OwningActor);
    }
    super.InitializeAxonBrainState(iOwningBSS, OwningActor);
    //return;    
}

delegate PreInitializeOrder(AxonBrainState Abs)
{
    //return;    
}

function PreInitializeDefault(AxonBrainState Abs)
{
    local AxonSquadOrderBrainState newOrder;

    newOrder = AxonSquadOrderBrainState(Abs);
    // End:0x2B
    if(newOrder != none)
    {
        newOrder.SquadBrainState = self;
    }
    //return;    
}

function GiveOrderCustomCallback(Controller C, class<AxonSquadOrderBrainState> order, delegate<PreInitializeOrder> customCallback)
{
    // End:0x3C
    if(KynapseAIController(C) != none)
    {
        KynapseAIController(C).ABSS.AddTransplantBrainState(order, customCallback);
    }
    //return;    
}

function GiveOrder(Controller C, class<AxonSquadOrderBrainState> order)
{
    GiveOrderCustomCallback(C, order, PreInitializeDefault);
    //return;    
}

function PushSubSquad(array<Controller> SubSquad, out int Count)
{
    local int I;
    local name subSquadName, memberName;

    I = 0;
    J0x07:

    // End:0x5E [Loop If]
    if(I < SubSquad.Length)
    {
        memberName = name((("member" $ string(Count)) $ "_") $ string(I));
        PushEventParamObject(memberName, SubSquad[I]);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    subSquadName = name("nummembers" $ string(Count));
    PushEventParamInt(subSquadName, SubSquad.Length);
    Count++;
    //return;    
}

function PushRole(coerce string ruleId, delegate<AxonDelegate> roleCallback)
{
    PushEventParamDelegate('Role', roleCallback);
    ExecuteCommand(name(ruleId $ "AssignmentRule"));
    //return;    
}

function PushFCFSRole(delegate<AxonDelegate> roleCallback)
{
    PushRole("FCFS", roleCallback);
    //return;    
}

function PushNearestPointRole(Vector Point, delegate<AxonDelegate> roleCallback)
{
    PushEventParamVector('Point', Point);
    PushRole("NearestPoint", roleCallback);
    //return;    
}

function PushHasEnemyRole(delegate<AxonDelegate> roleCallback)
{
    PushRole("HasEnemy", roleCallback);
    //return;    
}

function PushWithinAffordanceRole(AffordanceNodeVolume vol, delegate<AxonDelegate> roleCallback)
{
    PushEventParamObject('Node', vol);
    PushRole("WithinAffordance", roleCallback);
    //return;    
}

function RegisterSquadRoleAssignmentEvent(int numSubSquads, delegate<AxonDelegate> rolesAssignedCallback, optional name Key = 'stack')
{
    PushEventParamInt('numSubSquads', numSubSquads);
    PushEventParamDelegate('rolesassigned', rolesAssignedCallback);
    RegisterSubstateEvent('AssignRoles', Key);
    //return;    
}

function AssignRolesToSubsquads(array<SubSquad> SubSquads, delegate<AxonDelegate> rolesAssignedCallback)
{
    local int subSquadCount, I;

    I = 0;
    J0x07:

    // End:0x45 [Loop If]
    if(I < SubSquads.Length)
    {
        PushSubSquad(SubSquads[I].Members, subSquadCount);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    RegisterSquadRoleAssignmentEvent(subSquadCount, rolesAssignedCallback);
    //return;    
}

function PopulateMembersForRole(out array<Controller> Members)
{
    local Object obj;
    local int numMembers, I;
    local name memberName;

    GetCallbackParamInt('numMembers', numMembers);
    I = 0;
    J0x1B:

    // End:0x77 [Loop If]
    if(I < numMembers)
    {
        memberName = name("member" $ string(I));
        // End:0x6D
        if(GetCallbackParamObject(memberName, obj))
        {
            Members[Members.Length] = Controller(obj);
        }
        I++;
        // [Loop Continue]
        goto J0x1B;
    }
    //return;    
}

function int PushAllMembersAsIndividuals()
{
    local int I, Count;
    local name memberName, subSquadName;

    I = 0;
    J0x07:

    // End:0xB2 [Loop If]
    if(I < squad.SquadMembers.Length)
    {
        // End:0xA8
        if(squad.SquadMembers[I] != none)
        {
            Count++;
            memberName = name(("member" $ string(Count)) $ "_0");
            PushEventParamObject(memberName, squad.SquadMembers[I]);
            subSquadName = name("nummembers" $ string(Count));
            PushEventParamInt(subSquadName, 1);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return Count;
    //return ReturnValue;    
}

function SplitBetweenHasEnemy(delegate<AxonDelegate> rolesAssignedCallback)
{
    local int aliveMemberCount, I;

    splitMembers.Length = 0;
    aliveMemberCount = PushAllMembersAsIndividuals();
    I = 0;
    J0x1F:

    // End:0x4B [Loop If]
    if(I < aliveMemberCount)
    {
        PushHasEnemyRole(InternalIngroupRole);
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    RegisterSquadRoleAssignmentEvent(aliveMemberCount, rolesAssignedCallback);
    //return;    
}

function FindAllInAffordance(KynapseSquadNode Node, out array<Controller> groupInNode, out array<Controller> groupNotInNode)
{
    local int I;
    local Controller C;

    groupInNode.Length = 0;
    groupNotInNode.Length = 0;
    I = 0;
    J0x17:

    // End:0xC9 [Loop If]
    if(I < squad.SquadMembers.Length)
    {
        C = squad.SquadMembers[I];
        // End:0xBF
        if((C != none) && C.Pawn != none)
        {
            // End:0xAD
            if(Node.IsAtSquadNode(C.Pawn.Location))
            {
                groupInNode[groupInNode.Length] = C;
                // [Explicit Continue]
                goto J0xBF;
            }
            groupNotInNode[groupNotInNode.Length] = C;
        }
        J0xBF:

        I++;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

final function InternalIngroupRole()
{
    local Object obj;

    GetCallbackParamObject('member0', obj);
    // End:0x3B
    if(Controller(obj) != none)
    {
        splitMembers[splitMembers.Length] = Controller(obj);
    }
    //return;    
}

final function PopulateInGroupOutGroup(out array<Controller> InGroup, out array<Controller> outGroup)
{
    local int I;

    InGroup.Length = 0;
    outGroup.Length = 0;
    I = 0;
    J0x17:

    // End:0x5A [Loop If]
    if(I < splitMembers.Length)
    {
        // End:0x50
        if(splitMembers[I] != none)
        {
            InGroup[InGroup.Length] = splitMembers[I];
        }
        I++;
        // [Loop Continue]
        goto J0x17;
    }
    I = 0;
    J0x61:

    // End:0xBF [Loop If]
    if(I < squad.SquadMembers.Length)
    {
        // End:0xB5
        if(squad.SquadMembers[I] != none)
        {
            outGroup[outGroup.Length] = squad.SquadMembers[I];
        }
        I++;
        // [Loop Continue]
        goto J0x61;
    }
    I = 0;
    J0xC6:

    // End:0xF6 [Loop If]
    if(I < InGroup.Length)
    {
        QuickRemoveControllerFromArray(outGroup, InGroup[I]);
        I++;
        // [Loop Continue]
        goto J0xC6;
    }
    //return;    
}

final function QuickRemoveControllerFromArray(out array<Controller> removeFrom, Controller removeMe)
{
    local int Index;

    Index = removeFrom.Find(removeMe);
    // End:0x2E
    if(Index != -1)
    {
        removeFrom.Remove(Index, 1);
    }
    //return;    
}

function CreateSubSquadMonitor(array<Controller> Members, coerce string SubSquadType, float Lifetime)
{
    local SubSquadMonitor monitor;

    // End:0x0D
    if(!bShouldCreateMonitor)
    {
        return;
    }
    monitor = squad.__NFUN_278__(MonitorClass);
    monitor.Members = Members;
    monitor.SubSquadType = SubSquadType;
    monitor.SetLifetime(Lifetime);
    //return;    
}

defaultproperties
{
    MonitorClass=Class'EAKynapse.SubSquadMonitor'
}