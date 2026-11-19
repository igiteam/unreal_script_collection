class CCKeyPALookAt extends CCKey
    editinlinenew
    hidecategories(Object,Object);

var(LookAt) CCLookAtRuleBase LookAtRule;

function CCAttitude GetEffectiveAttitude()
{
    // End:0x22
    if(none != LookAtRule)
    {
        return LookAtRule.GetEffectiveAttitude();        
    }
    else
    {
        return none;
    }
    //return ReturnValue;    
}

function string GetDebugString()
{
    local string DebugString;

    DebugString = super.GetDebugString();
    // End:0x48
    if(none != LookAtRule)
    {        
        DebugString $= (", LookAtRule=" $ string(LookAtRule.Name));        
    }
    else
    {        
        DebugString $= ", LookAtRule=none";
    }
    // End:0xAC
    if(none != (GetEffectiveAttitude()))
    {        
        DebugString $= (", Attitude=" $ string(GetEffectiveAttitude().Name));        
    }
    else
    {        
        DebugString $= ", Attitude=none";
    }
    return DebugString;
    //return ReturnValue;    
}
