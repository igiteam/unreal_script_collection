class SPKrakenPawnPersistent extends SPPawn
    native
    config(Game);

enum eKrakenActionState
{
    eKRActionNone,                  // 0
    eKRActionAttack,                // 1
    eKRActionFrustrated,            // 2
    eKrakenActionState_MAX          // 3
};

/** VARIABLE DECLARATIONS squad team info */
var(Squad) SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;
var SPKrakenPawnPersistent.eKrakenActionState m_actionState;
var bool m_bResetAction;

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}

function SPKrakenAIController GetController()
{
    local SPKrakenAIController MyController;

    MyController = SPKrakenAIController(Controller);
    // End:0x21
    if(MyController != none)
    {
        return MyController;
    }
    return none;
    //return ReturnValue;    
}

function bool IsAttacking()
{
    local SPKrakenAIController MyController;

    MyController = SPKrakenAIController(Controller);
    // End:0x2C
    if(MyController != none)
    {
        return MyController.m_bAttacking;
    }
    return false;
    //return ReturnValue;    
}

function bool SetAttacking()
{
    local SPKrakenAIController MyController;

    MyController = SPKrakenAIController(Controller);
    // End:0x47
    if(MyController != none)
    {
        // End:0x33
        if(MyController.m_bAttacking)
        {
            return false;            
        }
        else
        {
            MyController.m_bAttacking = true;
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function UnSetAttacking()
{
    local SPKrakenAIController MyController;

    MyController = SPKrakenAIController(Controller);
    // End:0x2D
    if(MyController != none)
    {
        MyController.m_bAttacking = false;
    }
    //return;    
}

function int FindEnemy()
{
    local SPKrakenAIController MyController;

    MyController = SPKrakenAIController(Controller);
    // End:0x30
    if(MyController != none)
    {
        return MyController.DetermineEnemy();
    }
    return -1;
    //return ReturnValue;    
}

function NotifyIsDoneAttacking()
{
    local SPKrakenAIController MyController;

    MyController = SPKrakenAIController(Controller);
    // End:0x2D
    if(MyController != none)
    {
        MyController.m_bAttacking = false;
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
            // End:0x8C
            break;
        // End:0x72
        case 1:
            retval = 'Attack';
            // End:0x8C
            break;
        // End:0x89
        case 2:
            retval = 'Frustrated';
            // End:0x8C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    super.ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}
