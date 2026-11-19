class SeqAct_FlashlightNumeralPuzzle extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvFlashlightNumeralPuzzle_Base NumeralPuzzle;
var int PreviousLength1;
var array<AdvFlashlight_GlowableMini_base> Row1;
var int PreviousLength2;
var array<AdvFlashlight_GlowableMini_base> Row2;
var int PreviousLength3;
var array<AdvFlashlight_GlowableMini_base> Row3;
var int PreviousLength4;
var array<AdvFlashlight_GlowableMini_base> Row4;
var bool bAssociated;

event Activated()
{
    local int I;

    PublishLinkedVariableValues();
    // End:0x1B5
    if(InputLinks[0].bHasImpulse)
    {
        NumeralPuzzle.MiniRow1 = AssociateMiniRows(PreviousLength1, 0, NumeralPuzzle.MiniRow1, Row1);
        NumeralPuzzle.MiniRow2 = AssociateMiniRows(PreviousLength2, 1, NumeralPuzzle.MiniRow2, Row2);
        NumeralPuzzle.MiniRow3 = AssociateMiniRows(PreviousLength3, 2, NumeralPuzzle.MiniRow3, Row3);
        NumeralPuzzle.MiniRow4 = AssociateMiniRows(PreviousLength4, 3, NumeralPuzzle.MiniRow4, Row4);
        NumeralPuzzle.InitializePreset();
    }
    // End:0x4FA
    if(InputLinks[1].bHasImpulse)
    {
        NumeralPuzzle.bIsPuzzleActive = true;
        NumeralPuzzle.EndingAnimationMini(NumeralPuzzle.MiniRow1, NumeralPuzzle.bIsPuzzleActive, true, true);
        NumeralPuzzle.EndingAnimationMini(NumeralPuzzle.MiniRow2, NumeralPuzzle.bIsPuzzleActive, true, true);
        NumeralPuzzle.EndingAnimationMini(NumeralPuzzle.MiniRow3, NumeralPuzzle.bIsPuzzleActive, true, true);
        NumeralPuzzle.EndingAnimationMini(NumeralPuzzle.MiniRow4, NumeralPuzzle.bIsPuzzleActive, true, true);
        I = 0;
        J0x37B:

        // End:0x435 [Loop If]
        if(I < NumeralPuzzle.GlowablePointsLength)
        {
            NumeralPuzzle.GlowablePoints[I].bEndingAnimationActive = true;
            NumeralPuzzle.GlowablePoints[I].bFullEndingAnimation = true;
            ++I;
            // [Loop Continue]
            goto J0x37B;
        }
        I = 0;
        J0x440:

        // End:0x4FA [Loop If]
        if(I < NumeralPuzzle.GlowableBarsLength)
        {
            NumeralPuzzle.GlowableBars[I].bEndingAnimationActive = true;
            NumeralPuzzle.GlowableBars[I].bFullEndingAnimation = true;
            ++I;
            // [Loop Continue]
            goto J0x440;
        }
    }
    // End:0x53C
    if(InputLinks[2].bHasImpulse)
    {
        NumeralPuzzle.TurnOffAll();
    }
    PopulateLinkedVariableValues();
    //return;    
}

function array<AdvFlashlight_GlowableMini_base> AssociateMiniRows(int prevLength, int barNumber, array<AdvFlashlight_GlowableMini_base> miniRow, array<AdvFlashlight_GlowableMini_base> Row)
{
    local int I;

    // End:0x31D
    if(prevLength != Row.Length)
    {
        I = 0;
        J0x23:

        // End:0x309 [Loop If]
        if(I < Row.Length)
        {
            miniRow.AddItem(Row[I]);            
            miniRow[I].LightTimeout = NumeralPuzzle.LightTimeout;
            miniRow[I].LightPowerThreshold = NumeralPuzzle.LightPowerThreshold;
            miniRow[I].LightGainer = NumeralPuzzle.LightGainer;
            miniRow[I].LightWaster = NumeralPuzzle.LightWaster;
            miniRow[I].LightThresholdInnerDividor = NumeralPuzzle.LightThresholdInnerDividor;
            miniRow[I].LightThresholdOuterDividor = NumeralPuzzle.LightThresholdOuterDividor;
            miniRow[I].DelayerThreshold = NumeralPuzzle.DelayerThreshold;
            miniRow[I].EndingGlowSpeeder = NumeralPuzzle.EndingGlowSpeeder;
            miniRow[I].bShouldBeLit = NumeralPuzzle.GlowableBars[barNumber].bShouldBeLit;
            ++I;
            // [Loop Continue]
            goto J0x23;
        }
        prevLength = Row.Length;
    }
    return miniRow;
    //return ReturnValue;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Associate minis",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Turn the puzzle on",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Turn all lights Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks=none
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="NumeralPuzzle",LinkVar="None",PropertyName="NumeralPuzzle",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_ObjectList',LinkedVariables=none,LinkDesc="Row1",LinkVar="None",PropertyName="Row1",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_ObjectList',LinkedVariables=none,LinkDesc="Row2",LinkVar="None",PropertyName="Row2",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_ObjectList',LinkedVariables=none,LinkDesc="Row3",LinkVar="None",PropertyName="Row3",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[4]=(ExpectedType=Class'Engine.SeqVar_ObjectList',LinkedVariables=none,LinkDesc="Row4",LinkVar="None",PropertyName="Row4",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="FlashlightNumeralPuzzle"
}