class SPConditionEvaluate_TurningLeft extends SPConditionEvaluate_TurningBase
    editinlinenew
    collapsecategories;

function bool IsValid(int wAngle)
{
    // End:0x0D
    if(wAngle > 0)
    {
        return false;
    }
    return Abs(float(wAngle)) > Abs(float(AngleLimitInWangles()));
    //return ReturnValue;    
}
