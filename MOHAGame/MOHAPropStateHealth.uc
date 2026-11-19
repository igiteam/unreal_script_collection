class MOHAPropStateHealth extends MOHAPropState
    editinlinenew
    hidecategories(Object);

var(Health) int HealthCutoff;
var(Health) bool bHealthIsPercentage;

function bool NeedHealthChange(float Health, float MaxHealth)
{
    // End:0x29
    if(bHealthIsPercentage)
    {
        return Health < ((float(HealthCutoff) * MaxHealth) / 100.0000000);        
    }
    else
    {
        return Health < float(HealthCutoff);
    }
    //return ReturnValue;    
}

defaultproperties
{
    HealthCutoff=100
    bHealthIsPercentage=true
    bHealthState=true
}