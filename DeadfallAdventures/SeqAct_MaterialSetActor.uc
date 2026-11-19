class SeqAct_MaterialSetActor extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() StaticMeshActor SMA;
var() InterpActor IA;
var() float MaximumMaterialValue;
var() float MinimumMaterialValue;
var() float SpeedModifier;
var() name MaterialParameterName;
var() array<int> MaterialIndices;
var array<MaterialInstanceConstant> MICs;
var float ActualValue;
var transient bool bInitialized;
var transient int Sign;

event Activated()
{
    local int I, MaterialsQuantity;

    // End:0x20
    if(SpeedModifier <= float(0))
    {
        SpeedModifier = 0.1000000;
    }
    // End:0x1A2
    if((SMA != none) && !bInitialized)
    {
        bInitialized = true;
        // End:0xC7
        if(SMA.StaticMeshComponent.Materials.Length > 0)
        {
            MaterialsQuantity = SMA.StaticMeshComponent.Materials.Length;            
        }
        else
        {
            MaterialsQuantity = SMA.StaticMeshComponent.GetNumElements();
        }
        I = 0;
        J0x110:

        // End:0x19F [Loop If]
        if(I < MaterialsQuantity)
        {
            // End:0x191
            if(MaterialIndices.Find(I) != )
            {                
                MICs.AddItem(SMA.StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I));                
            }
            ++I;
            // [Loop Continue]
            goto J0x110;
        }        
    }
    else
    {
        // End:0x321
        if((IA != none) && !bInitialized)
        {
            bInitialized = true;
            // End:0x249
            if(IA.StaticMeshComponent.Materials.Length > 0)
            {
                MaterialsQuantity = IA.StaticMeshComponent.Materials.Length;                
            }
            else
            {
                MaterialsQuantity = IA.StaticMeshComponent.GetNumElements();
            }
            I = 0;
            J0x292:

            // End:0x321 [Loop If]
            if(I < MaterialsQuantity)
            {
                // End:0x313
                if(MaterialIndices.Find(I) != )
                {                    
                    MICs.AddItem(IA.StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I));                    
                }
                ++I;
                // [Loop Continue]
                goto J0x292;
            }
        }
    }
    PublishLinkedVariableValues();
    //return;    
}

event bool Update(float DeltaTime)
{
    local int I;

    super.Update(DeltaTime);
    // End:0x43
    if((SMA == none) && IA == none)
    {
        ActivateOutputLink(1);
        return false;        
    }
    else
    {
        // End:0x73
        if(InputLinks[0].bHasImpulse)
        {
            Sign = 1;            
        }
        else
        {
            // End:0xA4
            if(InputLinks[1].bHasImpulse)
            {
                Sign = -1;
            }
        }
    }
    ActualValue += ((DeltaTime * SpeedModifier) * float(Sign));
    I = 0;
    J0xDB:

    // End:0x13C [Loop If]
    if(I < MICs.Length)
    {
        MICs[I].SetScalarParameterValue(MaterialParameterName, ActualValue);
        ++I;
        // [Loop Continue]
        goto J0xDB;
    }
    // End:0x1FE
    if(Sign == 1)
    {
        // End:0x1FB
        if(ActualValue >= MaximumMaterialValue)
        {
            ActualValue = MaximumMaterialValue;
            I = 0;
            J0x180:

            // End:0x1E1 [Loop If]
            if(I < MICs.Length)
            {
                MICs[I].SetScalarParameterValue(MaterialParameterName, ActualValue);
                ++I;
                // [Loop Continue]
                goto J0x180;
            }
            bAborted = false;
            ActivateOutputLink(3);
            return false;
        }        
    }
    else
    {
        // End:0x2AE
        if(ActualValue <= MinimumMaterialValue)
        {
            ActualValue = MinimumMaterialValue;
            I = 0;
            J0x233:

            // End:0x294 [Loop If]
            if(I < MICs.Length)
            {
                MICs[I].SetScalarParameterValue(MaterialParameterName, ActualValue);
                ++I;
                // [Loop Continue]
                goto J0x233;
            }
            bAborted = false;
            ActivateOutputLink(2);
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    MaximumMaterialValue=1.0000000
    SpeedModifier=1.0000000
    bCallHandler=false
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Increase",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Decrease",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Finished Dec",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[3]=(Links=none,LinkDesc="Finished Inc",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="StaticMeshActor",LinkVar="None",PropertyName="SMA",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="InterpActor",LinkVar="None",PropertyName="IA",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Material Actor SetScalarParameter"
}