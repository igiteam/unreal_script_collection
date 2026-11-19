class GFxUnitTest_ActionScriptThree extends GFxMoviePlayer
    config(UI);

var transient GFxUnitTest_ActionScriptThreeWidget UnitTestWidget;

event PostWidgetInit()
{
    local array<ASValue> Params;

    super.PostWidgetInit();
    // End:0x19
    if(UnitTestWidget == none)
    {
    }
    Params.Length = 0;    
    UnitTestWidget.Invoke("Callback_RunUnitTest", Params);
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bResult;

    super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    bResult = false;
    switch(WidgetName)
    {
        // End:0x7B
        case 'UnitTestWidget':
            UnitTestWidget = GFxUnitTest_ActionScriptThreeWidget(Widget);
            bResult = true;
            // End:0x7E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return bResult;
    //return ReturnValue;    
}

function bool Callback_IntParam(int IntParam)
{
    return IntParam == UnitTestWidget.TestInt;
    //return ReturnValue;    
}

function bool Callback_UIntParam(int UIntParam)
{
    return UIntParam == UnitTestWidget.TestUInt;
    //return ReturnValue;    
}

function bool Callback_NumParam(float NumParam)
{
    return NumParam ~= UnitTestWidget.TestFloat;
    //return ReturnValue;    
}

function bool Callback_BoolParam(bool BoolParam)
{
    return BoolParam == UnitTestWidget.TestBool;
    //return ReturnValue;    
}

function bool Callback_StringParam(string StringParam)
{
    return StringParam == UnitTestWidget.TestString;
    //return ReturnValue;    
}

function bool Callback_MixedParam(float NumParam, bool BoolParam, string StringParam)
{
    return ((NumParam ~= UnitTestWidget.TestFloat) && BoolParam == UnitTestWidget.TestBool) && StringParam == UnitTestWidget.TestString;
    //return ReturnValue;    
}

function bool Callback_ArrayParam(array<float> ArrayParam)
{
    local bool bSuccess;
    local int Idx;

    bSuccess = true;
    // End:0xBF
    if(ArrayParam.Length == UnitTestWidget.TestArray.Length)
    {
        Idx = 0;
        J0x45:

        // End:0xBC [Loop If]
        if(Idx < ArrayParam.Length)
        {
            // End:0xAE
            if(!ArrayParam[Idx] ~= UnitTestWidget.TestArray[Idx])
            {
                bSuccess = false;
                // [Explicit Break]
                goto J0xBC;
            }
            ++Idx;
            // [Loop Continue]
            goto J0x45;
        }
        J0xBC:
        
    }
    else
    {
        bSuccess = false;
    }
    return bSuccess;
    //return ReturnValue;    
}

function bool Callback_StructParam(UnitTestMultiMemberStruct StructParam)
{
    return UnitTestWidget.IsSameAsTestStruct(StructParam);
    //return ReturnValue;    
}

function bool Callback_RunUnrealScriptTests()
{
    UnitTestWidget.RunUnrealScriptTests();
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    bAutoPlay=true
    WidgetBindings=/* Array type was not detected. */
}