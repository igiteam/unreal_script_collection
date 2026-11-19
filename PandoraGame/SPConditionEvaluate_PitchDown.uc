class SPConditionEvaluate_PitchDown extends SPConditionEvaluate_PitchBase
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
