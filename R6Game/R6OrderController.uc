class R6OrderController extends Object
    native;

const kOrderPosUp = 0;
const kOrderPosDown = 1;
const kOrderPosLeft = 2;
const kOrderPosRight = 3;
const kMaxOrders = 4;
const kOrdersUnlimited = -100;

var R6PlayerController m_pPlayerController;
var R6OrderInfo m_aOrdersAvailable[4];
var R6RainbowManager m_RainbowManager;
var Actor m_pOrderActor;
var R6TeamStateMgr m_TeamStateMgr;
var R6EngineEnums.ERulesOfEngagement m_CurrentROE;

// Export UR6OrderController::execGetTeamInteractDesc(FFrame&, void* const)
native final function bool GetTeamInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc);

// Export UR6OrderController::execSendOrder(FFrame&, void* const)
native final function SendOrder();

// Export UR6OrderController::execCommunicateNewROE(FFrame&, void* const)
native final function CommunicateNewROE(bool bIsPlayerOrder);

// Export UR6OrderController::execCommunicateHeldOrder(FFrame&, void* const)
native final function CommunicateHeldOrder(R6EngineEnums.EOrderId eOrder);

// Export UR6OrderController::execTick(FFrame&, void* const)
native final function Tick(float fDelta);

// Export UR6OrderController::execUpdateOrders(FFrame&, void* const)
native final function UpdateOrders();

// Export UR6OrderController::execUpdateCurrentActor(FFrame&, void* const)
native final function UpdateCurrentActor();

// Export UR6OrderController::execResetXtosOrders(FFrame&, void* const)
native final function ResetXtosOrders();

// Export UR6OrderController::execFindXtosOrders(FFrame&, void* const)
native final function FindXtosOrders();

// Export UR6OrderController::execIsOrderHoldable(FFrame&, void* const)
native function bool IsOrderHoldable(R6EngineEnums.EOrderId eOrder);

// Export UR6OrderController::execSendRegroupTeamMessage(FFrame&, void* const)
native function SendRegroupTeamMessage();

// Export UR6OrderController::execSendHoldTeamMessage(FFrame&, void* const)
native function SendHoldTeamMessage();

// Export UR6OrderController::execIssueOrder(FFrame&, void* const)
native function IssueOrder(int idxOrder);

function Init(R6PlayerController pPlayerController, R6TeamStateMgr pTeamStateMgr)
{
    m_pPlayerController = pPlayerController;
    m_TeamStateMgr = pTeamStateMgr;
    m_pOrderActor = none;
    SetROE(pPlayerController.WorldInfo.m_StartingROE);
    ResetXtosOrders();
    return;
}

function ChangeROE()
{
    m_CurrentROE = ((int(m_CurrentROE) == int(0)) ? 1 : 0);
    CommunicateNewROE(true);
    return;
}

function SetROE(R6EngineEnums.ERulesOfEngagement eROE)
{
    // End:0x1E
    if(int(m_CurrentROE) != int(eROE))
    {
        m_CurrentROE = eROE;
    }
    return;
}

event IssueOrderUp(Object.EInputEvent eInput)
{
    // End:0x18
    if(int(eInput) == int(0))
    {
        IssueOrder(0);
    }
    return;
}

event IssueOrderDown(Object.EInputEvent eInput)
{
    // End:0x18
    if(int(eInput) == int(0))
    {
        IssueOrder(1);
    }
    return;
}

event IssueOrderLeft(Object.EInputEvent eInput)
{
    // End:0x19
    if(int(eInput) == int(0))
    {
        IssueOrder(2);
    }
    return;
}

event IssueOrderRight(Object.EInputEvent eInput)
{
    // End:0x19
    if(int(eInput) == int(0))
    {
        IssueOrder(3);
    }
    return;
}

event GetOrderUp(out R6OrderInfo OrderInfo)
{
    OrderInfo = m_aOrdersAvailable[0];
    return;
}

event GetOrderDown(out R6OrderInfo OrderInfo)
{
    OrderInfo = m_aOrdersAvailable[1];
    return;
}

event GetOrderLeft(out R6OrderInfo OrderInfo)
{
    OrderInfo = m_aOrdersAvailable[2];
    return;
}

event GetOrderRight(out R6OrderInfo OrderInfo)
{
    OrderInfo = m_aOrdersAvailable[3];
    return;
}

defaultproperties
{
    m_CurrentROE=1
}