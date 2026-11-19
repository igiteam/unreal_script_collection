class EvilDissolvingStaticMeshComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Object);

var() bool bCanDissolve;
var() bool bDissolveStarted;
var() bool bGetLifeSpanFromParent;
var() name DissolveParamName;
var() float ComponentLifeSpan;
var() array<MaterialInstanceConstant> InstanceMaterials;

simulated function StartDissolving()
{
    bDissolveStarted = true;
    //return;    
}

simulated function SetupDissolving()
{
    local int I, numElems;

    // End:0x12
    if(InstanceMaterials.Length > 0)
    {
        return;
    }
    numElems = GetNumElements();
    I = 0;
    J0x31:

    // End:0x76 [Loop If]
    if(I < numElems)
    {
        InstanceMaterials.AddItem(CreateAndSetMaterialInstanceConstant(I));        
        I++;
        // [Loop Continue]
        goto J0x31;
    }
    //return;    
}

defaultproperties
{
    bCanDissolve=true
    DissolveParamName="DissolveAmount"
    ComponentLifeSpan=5.0000000
    ReplacementPrimitive=none
}