class SPKrakenTentaclePawnPersistent extends SPPawn
    native
    config(Game);

enum eKrakenTentacleActionState
{
    eKTActionNone,                  // 0
    eKTActionAttack,                // 1
    eKTActionRetract,               // 2
    eKTActionHitReaction,           // 3
    eKTActionDie,                   // 4
    eKrakenTentacleActionState_MAX  // 5
};

enum eKrakenTentacleDistanceNode
{
    eKTActionShort,                 // 0
    eKTActionMedShort,              // 1
    eKTActionMedLong,               // 2
    eKTActionLong,                  // 3
    eKrakenTentacleDistanceNode_MAX // 4
};

enum eKrakenTentacleHitReactionNode
{
    eKTHitReactionRocket,           // 0
    eKTHitReactionOther,            // 1
    eKrakenTentacleHitReactionNode_MAX// 2
};

enum eKrakenTentacleAnimDirectionNode
{
    eKTAnimRight,                   // 0
    eKTAnimLeft,                    // 1
    eKrakenTentacleAnimDirectionNode_MAX// 2
};

var SPKrakenPawnPersistent m_KrakenPawnParent;
var bool m_bResetAction;
var bool m_bCanTakeDamage;
var bool m_bTargetingOn;
var bool m_bCanCauseMajorDamage;
var bool m_bCanDoShake;
var bool m_bIsDying;
var bool m_bHitReactionEnabled;
var bool m_bInHitReaction;
var SPKrakenTentaclePawnPersistent.eKrakenTentacleActionState m_actionState;
var SPKrakenTentaclePawnPersistent.eKrakenTentacleDistanceNode m_DistanceNode;
var SPKrakenTentaclePawnPersistent.eKrakenTentacleHitReactionNode m_HitReactionNode;
var SPKrakenTentaclePawnPersistent.eKrakenTentacleAnimDirectionNode m_AnimDirectionNode;
var(Squad) SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;
var SPGameDifficultyTuneKraken m_KrakenGDTuneData;

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}

event SetKrakenParent(SPKrakenPawnPersistent Parent)
{
    m_KrakenPawnParent = Parent;
    //return;    
}

simulated function OnSPSetKrakenTentacleAnimations(SeqAct_SPSetKrakenTentacleAnimations inAction)
{
    // End:0x25
    if(int(inAction.AnimationDirection) == int(0))
    {
        m_AnimDirectionNode = 0;        
    }
    else
    {
        // End:0x47
        if(int(inAction.AnimationDirection) == int(1))
        {
            m_AnimDirectionNode = 1;
        }
    }
    //return;    
}

function name ActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'NoAction';
    Node.m_overrideBlendTime = 0.2500000;
    // End:0x3C
    if(m_bResetAction)
    {
        bResetChildOut = 1;
        m_bResetAction = false;
    }
    switch(m_actionState)
    {
        // End:0x5B
        case 0:
            retval = 'NoAction';
            // End:0xBA
            break;
        // End:0x72
        case 1:
            retval = 'Attack';
            // End:0xBA
            break;
        // End:0x89
        case 2:
            retval = 'Retract';
            // End:0xBA
            break;
        // End:0xA0
        case 3:
            retval = 'HitReaction';
            // End:0xBA
            break;
        // End:0xB7
        case 4:
            retval = 'Die';
            // End:0xBA
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

function name ActionTypeNodeHitReactionMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'NoAction';
    Node.m_overrideBlendTime = 0.2500000;
    // End:0x3C
    if(m_bResetAction)
    {
        bResetChildOut = 1;
        m_bResetAction = false;
    }
    switch(m_HitReactionNode)
    {
        // End:0x5B
        case 0:
            retval = 'Rocket';
            // End:0x75
            break;
        // End:0x72
        case 1:
            retval = 'Other';
            // End:0x75
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

function name ActionTypeNodeAnimDirectionMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'NoAction';
    Node.m_overrideBlendTime = 0.2500000;
    // End:0x3C
    if(m_bResetAction)
    {
        bResetChildOut = 1;
        m_bResetAction = false;
    }
    switch(m_AnimDirectionNode)
    {
        // End:0x5B
        case 0:
            retval = 'Right';
            // End:0x75
            break;
        // End:0x72
        case 1:
            retval = 'Left';
            // End:0x75
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTuneKraken GetKrakenDifficultyData()
{
    // End:0x20
    if(m_KrakenGDTuneData == none)
    {
        m_KrakenGDTuneData = SPGameDifficultyTuneKraken(GetMyGDData());
    }
    return m_KrakenGDTuneData;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.KrakenGD;
    //return ReturnValue;    
}

simulated function PreBeginPlay()
{
    super.PreBeginPlay();
    GetKrakenDifficultyData();
    Health = int(m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.HitPoints));
    //return;    
}

// Export USPKrakenTentaclePawnPersistent::execGetShotTargetOnBody(FFrame&, void* const)
native simulated function Vector GetShotTargetOnBody(optional Actor RequestedBy);

function NotifyDyingAnimEnd()
{
    m_bIsDying = false;
    //return;    
}

function NotifyHitReactionsEnabled()
{
    m_bHitReactionEnabled = true;
    //return;    
}

function NotifyHitReactionsDisabled()
{
    m_bHitReactionEnabled = false;
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Vector vGroundStart;
    local Rotator rGroundStart;
    local float DamageValue;

    // End:0x130
    if(DamageType == Class'SPDamageTypeExplosionRocketLauncher')
    {
        m_HitReactionNode = 0;
        // End:0xE9
        if(m_bCanTakeDamage)
        {
            // End:0xBD
            if(Mesh.GetSocketWorldLocationAndRotation('GroundCheckStart', vGroundStart, rGroundStart) == true)
            {
                // End:0x91
                if(VSize(vGroundStart - HitLocation) > float(1500))
                {
                    DamageValue = m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.RocketDamageVSKraken);                    
                }
                else
                {
                    DamageValue = m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.RocketDamageVSKrakenEye);
                }                
            }
            else
            {
                DamageValue = m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.RocketDamageVSKraken);
            }            
        }
        else
        {
            DamageValue = m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.RocketDamageVSKraken);
        }
        // End:0x12D
        if(PandoraPlayerController(EventInstigator) == none)
        {
            DamageValue = 0.0000000;
        }        
    }
    else
    {
        // End:0x142
        if(PandoraPlayerController(EventInstigator) == none)
        {
            return;
        }
        // End:0x155
        if(!m_bInHitReaction)
        {
            m_HitReactionNode = 1;
        }
        DamageValue = m_KrakenGDTuneData.GetValue(m_KrakenGDTuneData.NonRocketDamageVSKraken);
    }
    super.ServerOnlyTakeDamage(DamageValue, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x1DA
    if(m_bHitReactionEnabled && !m_bInHitReaction)
    {
        m_bInHitReaction = true;
        // End:0x1DA
        if(Health > 0)
        {
            SetHitReactionFromPawn();
        }
    }
    //return;    
}

function SetHitReactionFromPawn()
{
    local SPKrakenTentacleAIController MyController;

    MyController = SPKrakenTentacleAIController(Controller);
    // End:0x2F
    if(MyController != none)
    {
        MyController.SetHitReaction();
    }
    //return;    
}

function SetCanTakeDamage(bool bTakeDamage)
{
    m_bCanTakeDamage = bTakeDamage;
    //return;    
}

function bool CheckAttack()
{
    // End:0x20
    if(m_KrakenPawnParent != none)
    {
        return m_KrakenPawnParent.IsAttacking();
    }
    return false;
    //return ReturnValue;    
}

function bool LockAttackState()
{
    // End:0x20
    if(m_KrakenPawnParent != none)
    {
        return m_KrakenPawnParent.SetAttacking();
    }
    return false;
    //return ReturnValue;    
}

function UnLockAttackState()
{
    // End:0x1F
    if(m_KrakenPawnParent != none)
    {
        m_KrakenPawnParent.UnSetAttacking();
    }
    //return;    
}

function int FindEnemyToAttack()
{
    // End:0x20
    if(m_KrakenPawnParent != none)
    {
        return m_KrakenPawnParent.FindEnemy();
    }
    return -1;
    //return ReturnValue;    
}

function SPKrakenAIController GetKrakenParent()
{
    // End:0x20
    if(m_KrakenPawnParent != none)
    {
        return m_KrakenPawnParent.GetController();
    }
    return none;
    //return ReturnValue;    
}

event int GetDistanceNode()
{
    local SPKrakenTentacleAIController MyController;

    MyController = SPKrakenTentacleAIController(Controller);
    // End:0x30
    if(MyController != none)
    {
        return MyController.GetTentacleDistance();
    }
    return 0;
    //return ReturnValue;    
}

event int GetPullbackNode()
{
    return int(m_DistanceNode);
    //return ReturnValue;    
}

function NotifyCanDoMajorDamage()
{
    m_bCanCauseMajorDamage = false;
    //return;    
}

function NotifyCanDoShake()
{
    m_bCanDoShake = true;
    //return;    
}

function NotifyTentacleTargetingIsOff()
{
    m_bTargetingOn = false;
    //return;    
}

function NotifyTentacleIsDoneIdling()
{
    local SPKrakenTentacleAIController MyController;

    MyController = SPKrakenTentacleAIController(Controller);
    // End:0x2D
    if(MyController != none)
    {
        MyController.m_bIsIdling = true;
    }
    //return;    
}

function NotifyTentacleIsDoneAttacking()
{
    SetCanTakeDamage(true);
    m_actionState = 2;
    //return;    
}

function TentacleIsDoneRetracting()
{
    local SPKrakenTentacleAIController MyController;

    MyController = SPKrakenTentacleAIController(Controller);
    // End:0x4C
    if(MyController != none)
    {
        // End:0x45
        if(m_KrakenPawnParent != none)
        {
            m_KrakenPawnParent.UnSetAttacking();
            SetCanTakeDamage(false);
        }
        EnableNovadexCallbackOnPhysicsAsset(false);
    }
    //return;    
}

function NotifyTentacleIsDoneRetracting()
{
    local SPKrakenTentacleAIController MyController;

    MyController = SPKrakenTentacleAIController(Controller);
    // End:0x60
    if(MyController != none)
    {
        // End:0x45
        if(m_KrakenPawnParent != none)
        {
            m_KrakenPawnParent.UnSetAttacking();
            SetCanTakeDamage(false);
        }
        MyController.ResetAttackTimer();
        EnableNovadexCallbackOnPhysicsAsset(false);
    }
    //return;    
}

state Dying
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        //return;        
    }

    function EndDying()
    {
        local int I;
        local SPKrakenTentacleAIController MyController;

        MyController = SPKrakenTentacleAIController(Controller);
        // End:0x5D
        if(MyController != none)
        {
            MyController.NotifyDied();
            // End:0x50
            if(Controller.bIsPlayer)
            {
                DetachFromController();                
            }
            else
            {
                Controller.Destroy();
            }
        }
        I = 0;
        J0x64:

        // End:0xA9 [Loop If]
        if(I < Attached.Length)
        {
            // End:0x9F
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0x64;
        }
        //return;        
    }
Begin:

    UnLockAttackState();
    InitPhysicsAssetInstance(false);
    SetPhysics(0);
    // End:0x43
    if(SPKrakenTentacleAIController(Controller) != none)
    {
        SPKrakenTentacleAIController(Controller).GotoState('ControllerDying');
    }
    J0x43:

    // End:0x5E [Loop If]
    if(int(m_actionState) != int(0))
    {
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x43;
    }
    m_bIsDying = true;
    m_actionState = 4;
    J0x6E:

    // End:0x82 [Loop If]
    if(m_bIsDying)
    {
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x6E;
    }
    EndDying();
    Destroy();
    stop;                    
}
