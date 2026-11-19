class SPConditionEvaluate_NotTurning extends SPConditionEvaluate_TurningBase
    editinlinenew
    collapsecategories;

function bool IsValid(int wAngle)
{
    return Abs(float(wAngle)) <= Abs(float(AngleLimitInWangles()));
    //return ReturnValue;    
}
