class SeqAct_GlowableElementSetter extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() int TotalActivations;
var float ActualActivations;
var AdvFlashlight_GlowableElement_base GlowableElement;
var bool bInstant;

event Activated()
{
    local int I;

    PublishLinkedVariableValues();
    ActualActivations += 1.0000000;
    I = 0;
    J0x25:

    // End:0x225 [Loop If]
    if(I < Targets.Length)
    {
        GlowableElement = AdvFlashlight_GlowableElement_base(Targets[I]);
        // End:0x103
        if(GlowableElement == none)
        {
            ScriptLog((((("WARNING: AdvFlashlight_GlowableElement_base expected in Targets for" @ string(self)) @ ". Target[") $ string(I)) $ "] : ") $ string(Targets[I]));            
        }
        else
        {
            // End:0x17B
            if(InputLinks[0].bHasImpulse)
            {
                bInstant = false;
                GlowableElement.SetTimer(GlowableElement.DelayerThreshold / float(2), true, 'SetLightAffectionFromFlashLight_T');                
            }
            else
            {
                bInstant = true;
                // End:0x1CB
                if(InputLinks[1].bHasImpulse)
                {
                    GlowableElement.TurnOn();                    
                }
                else
                {
                    // End:0x20D
                    if(InputLinks[2].bHasImpulse)
                    {
                        GlowableElement.TurnOff();
                    }
                }
            }
            PopulateLinkedVariableValues();
        }
        ++I;
        // [Loop Continue]
        goto J0x25;
    }
    //return;    
}

event bool Update(float DeltaTime)
{
    local bool bResult;
    local int I;

    bResult = true;
    PublishLinkedVariableValues();
    // End:0x33
    if(Targets.Length == 0)
    {
        ActivateOutputLink(1);
        return false;
    }
    I = 0;
    J0x3E:

    // End:0x208 [Loop If]
    if(I < Targets.Length)
    {
        GlowableElement = AdvFlashlight_GlowableElement_base(Targets[I]);
        // End:0x11C
        if(GlowableElement == none)
        {
            ScriptLog((((("WARNING: AdvFlashlight_GlowableElement_base expected in Targets for" @ string(self)) @ ". Target[") $ string(I)) $ "] : ") $ string(Targets[I]));            
        }
        else
        {
            // End:0x143
            if(bInstant)
            {
                ActivateOutputLink(0);
                bResult = false;                
            }
            else
            {
                // End:0x1FA
                if(GlowableElement.LightPower >= (GlowableElement.LightPowerThreshold * (ActualActivations / float(TotalActivations))))
                {
                    GlowableElement.SetTimer(0.0000000, true, 'SetLightAffectionFromFlashLight_T');
                    GlowableElement.StopInLightEffects();
                    ActivateOutputLink(0);
                    bResult = false;
                }
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x3E;
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    TotalActivations=1
    bCallHandler=false
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Turn on fluently",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Force turn on",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Force turn off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="GlowableElements",LinkVar="None",PropertyName="Targets",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="GlowableElementSetter"
}