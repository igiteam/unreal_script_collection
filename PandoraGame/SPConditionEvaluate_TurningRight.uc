class SPConditionEvaluate_TurningRight extends SPConditionEvaluate_TurningBase
    editinlinenew
    collapsecategories;

function bool IsValid(int wAngle)
{
    // End:0x0D
    if(wAngle < 0)
    {
        return false;
    }
    return float(wAngle) > Abs(float(AngleLimitInWangles()));
    //return ReturnValue;    
}
