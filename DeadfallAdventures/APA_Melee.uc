class APA_Melee extends EPA_Melee;

function bool CanOverrideActionWith(byte NewAction)
{
    return ((int(NewAction) == 55) || int(NewAction) == 57) || int(NewAction) == 56;
    //return ReturnValue;    
}
