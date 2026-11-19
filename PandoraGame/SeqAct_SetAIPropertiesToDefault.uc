class SeqAct_SetAIPropertiesToDefault extends SequenceAction
    native;

struct native PropertyDefaultInfo
{
    /** name of the property to set to default */
    var() name PropertyName;
    /** Should this property be set to default */
    var() bool bSetToDefault;
    var string PropertyDefaultValue;

    structdefaultproperties
    {
        PropertyName="None"
        bSetToDefault=false
        PropertyDefaultValue=""
    }
};

/** VARIABLE DECLARATIONS */
var() bool bSetAllPropToDefault;
/** class of object to set properties to default */
var() class<SPPawn> SPPawnClass;
var class<SPPawn> PrevSPPawnClass;
var() editinline array<editinline PropertyDefaultInfo> SPPawnProperties;
var() editinline array<editinline PropertyDefaultInfo> SPAIControllerProperties;
