class R6TeamStateMgr extends Actor
    native
    notplaceable
    hidecategories(lighting);

var R6PlayerController m_pPlayerController;
var R6RainbowManager m_pRainbowManager;
var R6GameEnums.ER6TeamStateDesc m_eCurrentDesc;

// Export UR6TeamStateMgr::execInit(FFrame&, void* const)
native function Init(R6PlayerController pPlayerController);

event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
{
    return;
}

event R6GameEnums.ER6TeamStateDesc GetDesc()
{
    return m_eCurrentDesc;
    return;
}

event bool CanSendMoveTo()
{
    return true;
    return;
}

event bool IsActionState()
{
    return false;
    return;
}

state s_DoorClosed
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 1;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderUp.m_eOrderId = 6;
        // End:0x43
        if(m_pRainbowManager.IsDoorBreached())
        {
            OrderLeft.m_eOrderId = ((int(eROE) == int(0)) ? 8 : 8);            
        }
        else
        {
            OrderLeft.m_eOrderId = ((int(eROE) == int(0)) ? 8 : 15);
        }
        OrderRight.m_eOrderId = ((int(eROE) == int(0)) ? 9 : 7);
        return;
    }
    stop;
}

state s_DoorOpened
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 2;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderUp.m_eOrderId = 2;
        OrderLeft.m_eOrderId = ((int(eROE) == int(0)) ? 30 : 30);
        OrderRight.m_eOrderId = ((int(eROE) == int(0)) ? 29 : 31);
        return;
    }
    stop;
}

state s_DoorLocked
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 4;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderUp.m_eOrderId = ((int(eROE) == int(0)) ? 18 : 15);
        OrderLeft.m_eOrderId = 0;
        OrderRight.m_eOrderId = 0;
        return;
    }
    stop;
}

state s_ChokePoint extends s_DoorOpened
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 5;
        return;
    }
    stop;
}

state s_Window
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 6;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderUp.m_eOrderId = 23;
        OrderLeft.m_eOrderId = ((int(eROE) == int(0)) ? 24 : 27);
        OrderRight.m_eOrderId = ((int(eROE) == int(0)) ? 26 : 25);
        return;
    }
    stop;
}

state s_TakingCover
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 7;
        return;
    }
    stop;
}

state s_Following extends s_TakingCover
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 8;
        return;
    }
    stop;
}

state s_Holding extends s_TakingCover
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 26;
        return;
    }
    stop;
}

state s_Rappelling
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 9;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderUp.m_eOrderId = 35;
        OrderUp.m_bDisabled = !m_pRainbowManager.CanTeamRopeBreach();
        OrderLeft.m_eOrderId = 36;
        OrderLeft.m_bDisabled = !m_pRainbowManager.CanTeamGoUp();
        OrderRight.m_eOrderId = 37;
        OrderRight.m_bDisabled = !m_pRainbowManager.CanTeamGoDown();
        return;
    }
    stop;
}

state s_FollowingRappelling extends s_Rappelling
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 10;
        return;
    }
    stop;
}

state s_StandingBy
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 11;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderUp.m_eOrderId = 34;
        return;
    }
    stop;
}

state s_ManDown
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 24;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderUp.m_eOrderId = 38;
        OrderUp.m_bDisabled = !m_pRainbowManager.IsATeammateStanding();
        return;
    }
    stop;
}

state s_ActionState
{
    event bool IsActionState()
    {
        return true;
        return;
    }
    stop;
}

state s_MovingToInteraction extends s_ActionState
{
    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderUp.m_bDisabled = true;
        OrderLeft.m_bDisabled = true;
        OrderRight.m_bDisabled = true;
        OrderDown.m_eOrderId = 12;
        return;
    }
    stop;
}

state s_MovingToDoor extends s_MovingToInteraction
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 12;
        return;
    }
    stop;
}

state s_MovingToLadder extends s_MovingToInteraction
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 13;
        return;
    }
    stop;
}

state s_MovingToFastrope extends s_MovingToInteraction
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 14;
        return;
    }
    stop;
}

state s_MovingToRappelling extends s_MovingToInteraction
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 15;
        return;
    }
    stop;
}

state s_MovingToWindow extends s_MovingToInteraction
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 16;
        return;
    }
    stop;
}

state s_MovingToCover extends s_ActionState
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 17;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderDown.m_eOrderId = 12;
        return;
    }
    stop;
}

state s_InFastRope extends s_MovingToInteraction
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 18;
        return;
    }
    stop;
}

state s_InLadder extends s_MovingToInteraction
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 19;
        return;
    }
    stop;
}

state s_EngagingEnemy extends s_ActionState
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 20;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderLeft.m_eOrderId = ((int(eROE) == int(0)) ? 14 : 28);
        OrderLeft.m_bDisabled = true;
        OrderRight.m_eOrderId = ((int(eROE) == int(0)) ? 21 : 13);
        OrderRight.m_bDisabled = true;
        return;
    }
    stop;
}

state s_EnemySpotted extends s_EngagingEnemy
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 25;
        return;
    }
    stop;
}

state s_ClearingRoom extends s_ActionState
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 21;
        return;
    }
    stop;
}

state s_DoorOpening extends s_ActionState
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 3;
        return;
    }
    stop;
}

state s_Regrouping extends s_ActionState
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 22;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderLeft.m_eOrderId = ((int(eROE) == int(0)) ? 14 : 28);
        OrderLeft.m_bDisabled = true;
        OrderRight.m_eOrderId = ((int(eROE) == int(0)) ? 21 : 13);
        OrderRight.m_bDisabled = true;
        OrderDown.m_eOrderId = 12;
        return;
    }
    stop;
}

state s_Interacting extends s_ActionState
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 23;
        return;
    }

    event GetOrders(R6EngineEnums.ERulesOfEngagement eROE, out R6OrderInfo OrderUp, out R6OrderInfo OrderDown, out R6OrderInfo OrderLeft, out R6OrderInfo OrderRight)
    {
        OrderDown.m_bDisabled = true;
        return;
    }

    event bool CanSendMoveTo()
    {
        return false;
        return;
    }
    stop;
}

state s_BreachingDoor extends s_ActionState
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 27;
        return;
    }
    stop;
}

state s_SwitchingROE extends s_ActionState
{
    function BeginState(name PreviousStateName)
    {
        m_eCurrentDesc = 28;
        return;
    }
    stop;
}

defaultproperties
{
    bHidden=true
    bHiddenEd=true
    m_bDeleteOnReset=false
    Components=none
    TickGroup=1
}