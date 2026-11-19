class GFxUnitTest_ActionScriptThreeWidget extends GFxObject within GFxMoviePlayer;

struct UnitTestMultiMemberStruct
{
    var bool BoolMember1;
    var bool BoolMember2;
    var float FloatMember1;
    var float FloatMember2;
    var string StringMember1;
    var bool BoolMember3;
    var float FloatMember3;

    structdefaultproperties
    {
        BoolMember1=false
        BoolMember2=false
        FloatMember1=0.0000000
        FloatMember2=0.0000000
        StringMember1=""
        BoolMember3=false
        FloatMember3=0.0000000
    }
};

var transient float TestFloat;
var transient int TestInt;
var transient int TestUInt;
var transient bool TestBool;
var transient string TestString;
var transient array<float> TestArray;
var transient UnitTestMultiMemberStruct TestStruct;
//var delegate<DelegateTest> __DelegateTest__Delegate;

delegate DelegateTest()
{
    //return;    
}

function RunUnrealScriptTests()
{
    local GFxObject ReturnObj;
    local UnitTestMultiMemberStruct ReturnStruct;
    local array<GFxObject> ReturnArray;
    local int Idx;
    local bool bArrayVerified;

    AS_IntParam(TestInt);
    AS_IntParamInvoke(TestInt);
    AS_UIntParam(TestUInt);
    AS_UIntParamInvoke(TestUInt);
    AS_NumberParam(TestFloat);
    AS_NumberParamInvoke(TestFloat);
    AS_BoolParam(TestBool);
    AS_BoolParamInvoke(TestBool);
    AS_StringParam(TestString);
    AS_StringParamInvoke(TestString);
    AS_MixedParam(TestFloat, TestBool, TestString);
    AS_MixedParamInvoke(TestFloat, TestBool, TestString);
    AS_ArrayParam(TestArray);
    AS_StructParam(TestStruct);
    AS_ReturnValueIntVerification((AS_ReturnValueIntTest()) == TestInt);
    AS_ReturnValueNumberVerification((AS_ReturnValueNumberTest()) ~= TestFloat);
    AS_ReturnValueStringVerification((AS_ReturnValueStringTest()) == TestString);
    ReturnObj = AS_ReturnValueGFxObjectTest();
    // End:0x3B9
    if(ReturnObj != none)
    {
        ReturnStruct.BoolMember1 = ReturnObj.GetBool("BoolMember1");
        ReturnStruct.BoolMember2 = ReturnObj.GetBool("BoolMember2");
        ReturnStruct.BoolMember3 = ReturnObj.GetBool("BoolMember3");
        ReturnStruct.FloatMember1 = ReturnObj.GetFloat("FloatMember1");
        ReturnStruct.FloatMember2 = ReturnObj.GetFloat("FloatMember2");
        ReturnStruct.FloatMember3 = ReturnObj.GetFloat("FloatMember3");
        ReturnStruct.StringMember1 = ReturnObj.GetString("StringMember1");
    }
    AS_ReturnValueGFxObjectVerification(IsSameAsTestStruct(ReturnStruct));
    ReturnArray = AS_ReturnValueObjArrayTest();
    bArrayVerified = true;
    // End:0x41E
    if(ReturnArray.Length != TestArray.Length)
    {
        bArrayVerified = false;        
    }
    else
    {
        Idx = 0;
        J0x429:

        // End:0x4AF [Loop If]
        if(Idx < ReturnArray.Length)
        {
            // End:0x4A1
            if(!ReturnArray[Idx].GetFloat("FloatMember1") ~= TestArray[Idx])
            {
                bArrayVerified = false;
                // [Explicit Break]
                goto J0x4AF;
            }
            ++Idx;
            // [Loop Continue]
            goto J0x429;
        }
    }
    J0x4AF:

    AS_ReturnValueObjArrayVerification(bArrayVerified);
    bArrayVerified = true;
    ReturnObj = AS_ReturnValueArrayAsObjTest();
    // End:0x577
    if(ReturnObj != none)
    {
        Idx = 0;
        J0x4FD:

        // End:0x574 [Loop If]
        if(Idx < TestArray.Length)
        {
            // End:0x566
            if(!ReturnObj.GetElementFloat(Idx) ~= TestArray[Idx])
            {
                bArrayVerified = false;
                // [Explicit Break]
                goto J0x574;
            }
            ++Idx;
            // [Loop Continue]
            goto J0x4FD;
        }
        J0x574:
        
    }
    else
    {
        bArrayVerified = false;
    }
    AS_ReturnValueArrayAsObjVerification(bArrayVerified);
    AS_NonExistantFunction(TestFloat, TestBool, TestString);
    AS_NonExistantFunctionInvoke(TestFloat, TestBool, TestString);
    AS_SetDelegateTest(Callback_Delegate);
    AS_ForceCallDelegate();
    AS_EndUnrealScriptTests();
    //return;    
}

function bool IsSameAsTestStruct(const out UnitTestMultiMemberStruct InStruct)
{
    return ((((((InStruct.BoolMember1 == TestStruct.BoolMember1) && InStruct.BoolMember2 == TestStruct.BoolMember2) && InStruct.BoolMember3 == TestStruct.BoolMember3) && InStruct.FloatMember1 ~= TestStruct.FloatMember1) && InStruct.FloatMember2 ~= TestStruct.FloatMember2) && InStruct.FloatMember3 ~= TestStruct.FloatMember3) && InStruct.StringMember1 == TestStruct.StringMember1;
    //return ReturnValue;    
}

function AS_EndUnrealScriptTests()
{
    ActionScriptVoid("Callback_EndUnrealScriptTests");
    //return;    
}

function AS_IntParam(int IntParam)
{
    ActionScriptVoid("Callback_IntParam");
    //return;    
}

function AS_IntParamInvoke(int IntParam)
{
    local array<ASValue> Params;
    local ASValue asval;

    asval.Type = 2;
    asval.N = float(IntParam);
    Params.AddItem(asval);        
    Invoke("Callback_IntParamInvoke", Params);
    //return;    
}

function AS_UIntParam(int UIntParam)
{
    ActionScriptVoid("Callback_UIntParam");
    //return;    
}

function AS_UIntParamInvoke(int UIntParam)
{
    local array<ASValue> Params;
    local ASValue asval;

    asval.Type = 2;
    asval.N = float(UIntParam);
    Params.AddItem(asval);        
    Invoke("Callback_UIntParamInvoke", Params);
    //return;    
}

function AS_NumberParam(float NumParam)
{
    ActionScriptVoid("Callback_NumberParam");
    //return;    
}

function AS_NumberParamInvoke(float NumParam)
{
    local array<ASValue> Params;
    local ASValue asval;

    asval.Type = 2;
    asval.N = NumParam;
    Params.AddItem(asval);        
    Invoke("Callback_NumberParamInvoke", Params);
    //return;    
}

function AS_BoolParam(bool BoolParam)
{
    ActionScriptVoid("Callback_BoolParam");
    //return;    
}

function AS_BoolParamInvoke(bool BoolParam)
{
    local array<ASValue> Params;
    local ASValue asval;

    asval.Type = 5;
    asval.B = BoolParam;
    Params.AddItem(asval);        
    Invoke("Callback_BoolParamInvoke", Params);
    //return;    
}

function AS_StringParam(string StringParam)
{
    ActionScriptVoid("Callback_StringParam");
    //return;    
}

function AS_StringParamInvoke(string StringParam)
{
    local array<ASValue> Params;
    local ASValue asval;

    asval.Type = 4;
    asval.S = StringParam;
    Params.AddItem(asval);        
    Invoke("Callback_StringParamInvoke", Params);
    //return;    
}

function AS_MixedParam(float NumParam, bool BoolParam, string StringParam)
{
    ActionScriptVoid("Callback_MixedParam");
    //return;    
}

function AS_MixedParamInvoke(float NumParam, bool BoolParam, string StringParam)
{
    local array<ASValue> Params;
    local ASValue asval;

    asval.Type = 2;
    asval.N = NumParam;
    Params.AddItem(asval);    
    asval.Type = 5;
    asval.B = BoolParam;
    Params.AddItem(asval);    
    asval.Type = 4;
    asval.S = StringParam;
    Params.AddItem(asval);        
    Invoke("Callback_MixedParamInvoke", Params);
    //return;    
}

function AS_ArrayParam(array<float> ArrayParam)
{
    ActionScriptVoid("Callback_ArrayParam");
    //return;    
}

function AS_StructParam(UnitTestMultiMemberStruct StructParam)
{
    ActionScriptVoid("Callback_StructParam");
    //return;    
}

function int AS_ReturnValueIntTest()
{
    return ActionScriptInt("Callback_IntReturnVal");
    //return ReturnValue;    
}

function AS_ReturnValueIntVerification(bool bVerified)
{
    ActionScriptVoid("Callback_IntReturnValVerification");
    //return;    
}

function float AS_ReturnValueNumberTest()
{
    return ActionScriptFloat("Callback_NumberReturnVal");
    //return ReturnValue;    
}

function AS_ReturnValueNumberVerification(bool bVerified)
{
    ActionScriptVoid("Callback_NumberReturnValVerification");
    //return;    
}

function string AS_ReturnValueStringTest()
{
    return ActionScriptString("Callback_StringReturnVal");
    //return ReturnValue;    
}

function AS_ReturnValueStringVerification(bool bVerified)
{
    ActionScriptVoid("Callback_StringReturnValVerification");
    //return;    
}

function GFxObject AS_ReturnValueGFxObjectTest()
{
    return ActionScriptObject("Callback_ObjectReturnVal");
    //return ReturnValue;    
}

function AS_ReturnValueGFxObjectVerification(bool bVerified)
{
    ActionScriptVoid("Callback_ObjectReturnValVerification");
    //return;    
}

function array<GFxObject> AS_ReturnValueObjArrayTest()
{
    return ActionScriptArray("Callback_ObjArrayReturnVal");
    //return ReturnValue;    
}

function AS_ReturnValueObjArrayVerification(bool bVerified)
{
    ActionScriptVoid("Callback_ObjArrayReturnValVerification");
    //return;    
}

function GFxObject AS_ReturnValueArrayAsObjTest()
{
    return ActionScriptObject("Callback_ArrayAsObjReturnVal");
    //return ReturnValue;    
}

function AS_ReturnValueArrayAsObjVerification(bool bVerified)
{
    ActionScriptVoid("Callback_ArrayAsObjReturnValVerification");
    //return;    
}

function AS_SetDelegateTest(delegate<DelegateTest> Callback)
{
    ActionScriptSetFunction("Callback_DelegateTest");
    //return;    
}

function Callback_Delegate()
{
    ActionScriptVoid("Callback_DelegateReceived");
    //return;    
}

function AS_ForceCallDelegate()
{
    ActionScriptVoid("Callback_ForceCallDelegate");
    //return;    
}

function AS_NonExistantFunction(float NumParam, bool BoolParam, string StringParam)
{
    ActionScriptVoid("NonsenseFunctionThatDoesntExist");
    //return;    
}

function AS_NonExistantFunctionInvoke(float NumParam, bool BoolParam, string StringParam)
{
    local array<ASValue> Params;
    local ASValue asval;

    asval.Type = 2;
    asval.N = NumParam;
    Params.AddItem(asval);    
    asval.Type = 5;
    asval.B = BoolParam;
    Params.AddItem(asval);    
    asval.Type = 4;
    asval.S = StringParam;
    Params.AddItem(asval);        
    Invoke("NonsenseFunctionThatDoestExistInvoke", Params);
    //return;    
}

defaultproperties
{
    TestFloat=175.7500000
    TestInt=-225
    TestUInt=100
    TestBool=true
    TestString="Hello, World!"
    TestArray[0]=255.2500000
    TestArray[1]=105.2000000
    TestArray[2]=2.6600000
    TestStruct=(BoolMember1=true,BoolMember2=true,FloatMember1=255.2500000,FloatMember2=105.2000000,StringMember1="Hello, World!",BoolMember3=true,FloatMember3=2.6600000)
}