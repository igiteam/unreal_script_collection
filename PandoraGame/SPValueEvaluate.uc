class SPValueEvaluate extends Object
    abstract
    native
    editinlinenew
    collapsecategories;

enum eSPValueUsage
{
    eSPNone,                        // 0
    eSPMakePositive,                // 1
    eSPValueUsage_MAX               // 2
};

enum eRotAxisAv
{
    eValuePitch,                    // 0
    eValueYaw,                      // 1
    eValueRoll,                     // 2
    eRotAxisAv_MAX                  // 3
};

/** VARIABLE DECLARATIONS */
var() SPValueEvaluate.eSPValueUsage eInputConversion;
var() bool bClamp;
var() float ClampMin;
var() float ClampMax;

function float ProcessValue(float A)
{
    // End:0x1D
    if(int(eInputConversion) == int(1))
    {
        A = Abs(A);
    }
    // End:0x5A
    if(bClamp)
    {
        // End:0x40
        if(A < ClampMin)
        {
            A = ClampMin;
        }
        // End:0x5A
        if(A > ClampMax)
        {
            A = ClampMax;
        }
    }
    return A;
    //return ReturnValue;    
}

function float GetActorValue(Actor Actor)
{
    return 0.0000000;
    //return ReturnValue;    
}

event float Get(Actor Actor, optional Object anObject)
{
    local float Value;

    Value = 0.0000000;
    // End:0x2C
    if(Actor != none)
    {
        Value = GetActorValue(Actor);
    }
    return ProcessValue(Value);
    //return ReturnValue;    
}
