class APA_Charge extends EPA_Charge;

function bool CanOverrideActionWith(byte NewAction)
{
    return ((int(NewAction) == 55) || int(NewAction) == 57) || int(NewAction) == 56;
    //return ReturnValue;    
}
