class SPConditionEvaluate_AngleRange extends SPConditionEvaluate
    native
    editinlinenew
    collapsecategories;

enum eRotAxis
{
    eSPPitch,                       // 0
    eSPYaw,                         // 1
    eSPRoll,                        // 2
    eRotAxis_MAX                    // 3
};

/** VARIABLE DECLARATIONS */
var() SPConditionEvaluate_AngleRange.eRotAxis m_RotAxis;
var() SPConditionEvaluate.eRangeCondition m_RangeCondition;
var() float m_MinRotDegrees;
var() float m_MaxRotDegrees;

function float UnwindDegree(float A)
{
    J0x00:
    // End:0x1F [Loop If]
    if(A > float(180))
    {
        A -= float(360);
        // [Loop Continue]
        goto J0x00;
    }
    J0x1F:

    // End:0x41 [Loop If]
    if(A < float(-180))
    {
        A += float(360);
        // [Loop Continue]
        goto J0x1F;
    }
    return A;
    //return ReturnValue;    
}

function bool CompareAngle(int wAngle)
{
    local int Min, Max;
    local float minDegree, maxDegree;
    local bool Result;

    minDegree = UnwindDegree(m_MinRotDegrees);
    maxDegree = UnwindDegree(m_MaxRotDegrees);
    Min = NormalizeRotAxis(int((minDegree * 65536.0000000) / 360.0000000));
    Max = NormalizeRotAxis(int((maxDegree * 65536.0000000) / 360.0000000));
    wAngle = NormalizeRotAxis(wAngle);
    Result = false;
    switch(m_RangeCondition)
    {
        // End:0xB9
        case 0:
            Result = (wAngle >= Min) && wAngle <= Max;
            // End:0x120
            break;
        // End:0xD4
        case 1:
            Result = wAngle < Min;
            // End:0x120
            break;
        // End:0xEF
        case 2:
            Result = wAngle > Max;
            // End:0x120
            break;
        // End:0x106
        case 3:
            Result = wAngle < 0;
            // End:0x120
            break;
        // End:0x11D
        case 4:
            Result = wAngle >= 0;
            // End:0x120
            break;
        // End:0xFFFF
        default:
            break;
    }
    return Result;
    //return ReturnValue;    
}

function bool EvaluteWithActor(Actor Actor)
{
    switch(m_RotAxis)
    {
        // End:0x32
        case 0:
            return CompareAngle(Actor.Rotation.Pitch);
        // End:0x5C
        case 1:
            return CompareAngle(Actor.Rotation.Yaw);
        // End:0x86
        case 2:
            return CompareAngle(Actor.Rotation.Roll);
        // End:0xFFFF
        default:
            return false;
            break;
    }
    //return ReturnValue;    
}

function bool EvaluteWithSPAnimConditionalSwitchNode(SPAnimConditionalSwitchNode Node)
{
    switch(m_RotAxis)
    {
        // End:0x3D
        case 0:
            return CompareAngle(Node.EditorPreview.Rotation.Pitch);
        // End:0x72
        case 1:
            return CompareAngle(Node.EditorPreview.Rotation.Yaw);
        // End:0xA7
        case 2:
            return CompareAngle(Node.EditorPreview.Rotation.Roll);
        // End:0xFFFF
        default:
            return false;
            break;
    }
    //return ReturnValue;    
}
