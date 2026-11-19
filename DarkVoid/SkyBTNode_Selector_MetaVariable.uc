class SkyBTNode_Selector_MetaVariable extends SkyBTNode_Blend
    native;

struct native MetaVariableMapping
{
    var() string VariableName;
    var() float MinValue;
    var() float MaxValue;
    var() bool bOnlyWhenUndefined;
    var() bool bSubtractWorldTime;

    structdefaultproperties
    {
        VariableName=""
        MinValue=0.0000000
        MaxValue=0.0000000
        bOnlyWhenUndefined=false
        bSubtractWorldTime=false
    }
};

var(Mappings) editfixedsize array<MetaVariableMapping> MappedValues;
