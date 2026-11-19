class SPConditionEvaluate_Speed extends SPConditionEvaluate
    native
    editinlinenew
    collapsecategories;

/** STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() SPConditionEvaluate.eRangeCondition m_RangeCondition;
var() float m_MinSpeed;
var() float m_MaxSpeed;

function bool EvalSpeed(float Speed)
{
    switch(m_RangeCondition)
    {
        // End:0x2B
        case 0:
            return (Speed >= m_MinSpeed) && Speed <= m_MaxSpeed;
        // End:0x3D
        case 1:
            return Speed < m_MinSpeed;
        // End:0x4F
        case 2:
            return Speed > m_MaxSpeed;
        // End:0x5F
        case 4:
            return Speed >= float(0);
        // End:0x6F
        case 3:
            return Speed < float(0);
        // End:0xFFFF
        default:
            return false;
            break;
    }
    //return ReturnValue;    
}

function bool EvaluteWithActor(Actor Actor)
{
    return EvalSpeed(VSize(Actor.Velocity));
    //return ReturnValue;    
}

function bool EvaluteWithSPAnimConditionalSwitchNode(SPAnimConditionalSwitchNode Node)
{
    return EvalSpeed(Node.EditorPreview.Speed);
    //return ReturnValue;    
}
