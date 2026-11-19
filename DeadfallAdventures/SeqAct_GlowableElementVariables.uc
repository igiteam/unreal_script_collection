class SeqAct_GlowableElementVariables extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvFlashlight_GlowableElement_base GlowableElement;
var float LightPower;
var bool Initialized;

event Activated()
{
    PublishLinkedVariableValues();
    // End:0xF4
    if(GlowableElement != none)
    {
        // End:0x54
        if(!Initialized)
        {
            GlowableElement.KismetVariablesHolder = self;
            Initialized = true;
        }
        // End:0xEA
        if(GlowableElement.bIsPuzzleActive)
        {
            LightPower = GlowableElement.LightPower;
            GlowableElement.SetTimer(GlowableElement.DelayerThreshold, false, 'UpdateKismetVariablesHolder_T');
            ActivateCount = 0;
        }
        PopulateLinkedVariableValues();
    }
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="GlowableElement",LinkVar="None",PropertyName="GlowableElement",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="LightPower",LinkVar="None",PropertyName="LightPower",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Glowable Element variables"
}