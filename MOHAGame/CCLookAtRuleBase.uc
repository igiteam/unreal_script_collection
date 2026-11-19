class CCLookAtRuleBase extends Object
    native
    editinlinenew
    hidecategories(Object);

struct native CCTarget
{
    var name Id;
    var() Vector Position;
    var() SkelControlBase.EBoneControlSpace Space;
    var() name SpaceBoneName;
    var() name actorName;
    var transient float Weight;
    var bool bIsEditable;
    var Color EditorColor;

    structdefaultproperties
    {
        Id="Undefined"
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Space=5
        SpaceBoneName="Root"
        actorName="None"
        Weight=1.0000000
        bIsEditable=true
        EditorColor=(R=128,G=255,B=255,A=255)
    }
};

var array<Vector> Satellites;
var(Rule) int NumSatellites;
var(Rule) float SatelliteRadius;
var(Attitude) CCAttitude ExternalAttitude;
var(Attitude) export editinline CCAttitude LocalAttitude;
var Color SatelliteColor;
var transient float Weight;

// Export UCCLookAtRuleBase::execGenerateTargetId_NameIndex(FFrame&, void* const)
native final function name GenerateTargetId_NameIndex(name Name1, bool bSatellite, int Index);

// Export UCCLookAtRuleBase::execUpdateSatellites(FFrame&, void* const)
native function UpdateSatellites();

// Export UCCLookAtRuleBase::execAddSatellites(FFrame&, void* const)
native function AddSatellites(CCTarget Planet, SkelControlLookAtRules RulesControl);

function CCAttitude GetEffectiveAttitude()
{
    // End:0x14
    if(none != LocalAttitude)
    {
        return LocalAttitude;        
    }
    else
    {
        return ExternalAttitude;
    }
    //return ReturnValue;    
}

event bool ApplyAttitude(SkelControlPA PAControl)
{
    local CCAttitude Attitude;

    Attitude = GetEffectiveAttitude();
    // End:0x3E
    if((none != Attitude) && none != PAControl)
    {
        PAControl.NextAttitude = Attitude;
        return true;
    }
    return false;
    //return ReturnValue;    
}

event Evaluate(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl)
{
    //return;    
}

event bool EditTarget(CCTarget Target)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    SatelliteRadius=10.0000000
    SatelliteColor=(R=255,G=255,B=255,A=255)
    Weight=1.0000000
}