class AIDirector extends AIDirectorBase
    notplaceable
    hidecategories(Navigation);

function EvilPawn FindPlayer()
{
    local EvilPlayerController PC;

    // End:0x80
    foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
    {
        // End:0x7F
        if(PC.bIsPlayer)
        {            
            return EvilPawn(PC.Pawn);
        }        
    }    
    return none;
    //return ReturnValue;    
}

function float GetDamageInfluence(EvilPawn DamagedPawn)
{
    // End:0x4E
    if(DamagedPawn.IsPlayerPawn() || ActualParameters.DesiredGameIntensity == float(0))
    {
        return 1.0000000;
    }
    return FClamp((GameIntensity / ActualParameters.DesiredGameIntensity) * DamegeModifierScale, 1.0000000, MaximumDamegeModifier);
    //return ReturnValue;    
}

function bool ValidateAdditionalIntensity(float Intensity)
{
    // End:0x37
    if((GameIntensity + Intensity) <= ActualParameters.DesiredGameIntensity)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function float AdjustGameIntensity(float origIntensity)
{
    return origIntensity;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: AIBroadcastManager'Default__AIDirector.AIBroadcastManager0'
    begin object name=AIBroadcastManager0
    end object
    AIBroadcastManager=AIBroadcastManager0
}