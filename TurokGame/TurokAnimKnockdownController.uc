class TurokAnimKnockdownController extends ActorComponent
    native
    implements(TurokAnimInterfaceGraphNotify);

enum EKnockdownStates
{
    KNOCKDOWNSTATE_Contact,         // 0
    KNOCKDOWNSTATE_Air,             // 1
    KNOCKDOWNSTATE_Recover,         // 2
    KNOCKDOWNSTATE_Idle,            // 3
    KNOCKDOWNSTATE_MAX              // 4
};

var transient float mElapsedVerticalVelocityTime;
var transient float mFrameTime;
var transient name mRecoveryGraph;
var transient bool mbHitWall;
var byte mKnockdownState;

// Export UTurokAnimKnockdownController::execRotateToFaceAttacker(FFrame&, void* const)
native function RotateToFaceAttacker(float DeltaTime);

// Export UTurokAnimKnockdownController::execApplyPhysicsModifiers(FFrame&, void* const)
native function ApplyPhysicsModifiers(float DeltaTime);

// Export UTurokAnimKnockdownController::execCalculateRecoveryGraph(FFrame&, void* const)
native function CalculateRecoveryGraph();

// Export UTurokAnimKnockdownController::execIsHoldingAValidWeapon(FFrame&, void* const)
native function bool IsHoldingAValidWeapon(@NULL Tag);

// Export UTurokAnimKnockdownController::execInitSequence(FFrame&, void* const)
native function InitSequence();

private final function @NULL GetHumanPawn()
{
    return TurokPawnHuman(Owner);
    //return ReturnValue;    
}

function SetKnockdownState(byte knockdownState)
{
    mKnockdownState = knockdownState;
    //return;    
}

function Tick(float DeltaTime)
{
    local @NULL Human;

    Human = GetHumanPawn();
    mFrameTime = DeltaTime;
    // End:0x49
    if(int(Human.mKnockdownInfo.mKnockdownType) == int(1))
    {
        RotateToFaceAttacker(DeltaTime);
    }
    switch(mKnockdownState)
    {
        // End:0x58
        case 0:
            // End:0x85
            break;
        // End:0x75
        case 1:
            ApplyPhysicsModifiers(DeltaTime);
            UpdateStateAir();
            // End:0x85
            break;
        // End:0x7A
        case 2:
        // End:0x82
        case 3:
            // End:0x85
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

private final function UpdateStateAir()
{
    local @NULL graph, Human, graphSet;

    Human = GetHumanPawn();
    graphSet = GetGraphSet();
    // End:0x73
    if((int(Human.Physics) != int(2)) || mbHitWall)
    {
        graph = graphSet.FindGraph(mRecoveryGraph);
        // End:0x73
        if(graph != none)
        {
            PlayTransitionGraph(graph);            
        }
    }
    //return;    
}

private final event PlayTransitionGraph(@NULL graph)
{
    local @NULL Human, Player;

    Human = GetHumanPawn();
    Player = TurokPawnPlayer(Human);
    Human.PlayGraphLocal(graph, self, 0);
    // End:0x17D
    if(Player != none)
    {
        // End:0x119
        if(int(mKnockdownState) == int(0))
        {
            // End:0x88
            if(Player.GetRightHandWeapon() != none)
            {
                Player.GetRightHandWeapon().DeactivateWeaponBegin();
            }
            // End:0xC2
            if(Player.GetLeftHandWeapon() != none)
            {
                Player.GetLeftHandWeapon().DeactivateWeaponBegin();
            }
            Player.mPovArms.PutDownWeapons(graph.GetPreviewDuration(Player.Mesh, 0), graph.GetBlendInTime(0));            
        }
        else
        {
            // End:0x17D
            if(int(mKnockdownState) == int(2))
            {
                Player.mPovArms.BringUpWeapons(graph.GetPreviewDuration(Player.Mesh, 0), graph.GetBlendInTime(0));
            }
        }
    }
    //return;    
}

private final function @NULL GetGraphSet()
{
    local @NULL Human;

    Human = GetHumanPawn();
    switch(Human.mKnockdownInfo.mKnockdownType)
    {
        // End:0x3A
        case 1:
            return Human.mKnockdownGraphSet;
        // End:0x4E
        case 2:
            return Human.mDiveGraphSet;
        // End:0xFFFF
        default:
            return none;
            break;
    }
    //return ReturnValue;    
}

event FinishKnockdown()
{
    local @NULL PlayerController, Human, controllerRotation;

    Human = GetHumanPawn();
    // End:0x1AC
    if(Human != none)
    {
        SetKnockdownState(3);
        Human.mKnockdownInfo.mKnockdownType = 0;
        // End:0x138
        if((Human.Controller != none) && Human.Controller.IsInState('HumanKnockdown'))
        {
            PlayerController = TurokPlayerController(Human.Controller);
            // End:0xB4
            if(PlayerController != none)
            {
                PlayerController.GotoState('PlayerWalking');                
            }
            else
            {
                Human.Controller.GotoState('ActionPlanner');
            }
            controllerRotation.Yaw = Human.Rotation.Yaw;
            controllerRotation.Pitch = 0;
            controllerRotation.Roll = 0;
            Human.Controller.SetRotation(controllerRotation);
        }
        // End:0x172
        if(Human.GetRightHandWeapon() != none)
        {
            Human.GetRightHandWeapon().PlayAmbientIdleAnim();
        }
        // End:0x1AC
        if(Human.GetLeftHandWeapon() != none)
        {
            Human.GetLeftHandWeapon().PlayAmbientIdleAnim();
        }
    }
    //return;    
}

function NotifyGraphStart(@NULL graph, byte actorType)
{
    switch(mKnockdownState)
    {
        // End:0x1B
        case 3:
            SetKnockdownState(0);
            // End:0x9C
            break;
        // End:0x4C
        case 0:
            mElapsedVerticalVelocityTime = 0.0000000;
            mbHitWall = false;
            SetKnockdownState(1);
            CalculateRecoveryGraph();
            // End:0x9C
            break;
        // End:0x85
        case 1:
            // End:0x82
            if((int(GetHumanPawn().Physics) != int(2)) || mbHitWall)
            {
                SetKnockdownState(2);
            }
            // End:0x9C
            break;
        // End:0x99
        case 2:
            SetKnockdownState(3);
            // End:0x9C
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    //return;    
}

function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    // End:0x16
    if(int(mKnockdownState) == int(1))
    {
        UpdateStateAir();
    }
    //return;    
}

defaultproperties
{
    mKnockdownState=3
}