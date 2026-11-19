class SkySeqAct_SuspendSquad extends SequenceAction
    native;

struct native SquadSuspendPawn
{
    var Vector Position;
    var Rotator Rotation;
    var Pawn PawnArchetype;
    var AIController ControllerArchetype;
    var SkyBehaviorTree BehaviorTreeTemplate;
    var SkyItem_RocketPack RocketPackArchetype;
    var init array<init Inventory> InventoryArchList;
    var int TeamIndex;
    var SkySeqAct_AIFactoryNew AIFactory;
    var SkyVehicle VehicleArchetype;

    structdefaultproperties
    {
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        PawnArchetype=none
        ControllerArchetype=none
        BehaviorTreeTemplate=none
        RocketPackArchetype=none
        InventoryArchList=none
        TeamIndex=0
        AIFactory=none
        VehicleArchetype=none
    }
};

struct native SquadSuspendInfo
{
    var name SquadName;
    var SquadSuspendPawn Leader;
    var init array<init SquadSuspendPawn> Pawns;
    var init array<init SequenceAction> KismetEvents;

    structdefaultproperties
    {
        SquadName="None"
        Leader=(Position=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),PawnArchetype=none,ControllerArchetype=none,BehaviorTreeTemplate=none,RocketPackArchetype=none,InventoryArchList=none,TeamIndex=0,AIFactory=none,VehicleArchetype=none)
        Pawns=none
        KismetEvents=none
    }
};

var transient array<SquadSuspendInfo> SuspendedSquads;

static event int GetObjClassVersion()
{
    return 1;
    //return ReturnValue;    
}
