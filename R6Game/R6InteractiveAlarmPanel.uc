class R6InteractiveAlarmPanel extends R6InteractiveActor
    native
    config(Game)
    editinlinenew
    placeable
    hidecategories(lighting,Object);

var(Alarm) bool m_bOn;
var bool sm_bOn;

function SaveOriginalData()
{
    sm_bOn = m_bOn;
    SaveOriginalData();
    return;
}

function ResetOriginalData()
{
    m_bOn = sm_bOn;
    ResetOriginalData();
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    InteractSuccesful(pInteractor);
    m_bOn = !m_bOn;
    return;
}
