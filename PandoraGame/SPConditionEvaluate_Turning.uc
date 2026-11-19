class SPConditionEvaluate_Turning extends SPConditionEvaluate_TurningBase
    editinlinenew
    collapsecategories;

function bool IsValid(int wAngle)
{
    return Abs(float(wAngle)) > Abs(float(AngleLimitInWangles()));
    //return ReturnValue;    
}
