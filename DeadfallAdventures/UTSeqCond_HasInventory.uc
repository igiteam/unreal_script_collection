class UTSeqCond_HasInventory extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

var Actor Target;
var() class<Inventory> RequiredInventory;
var() bool bAllowSubclass;
var() bool bCheckVehicleDriver;

event Activated()
{
    local Pawn P;
    local Vehicle V;
    local bool bHasItem;

    P = GetPawn(Target);
    // End:0x161
    if(P != none)
    {
        bHasItem = P.FindInventoryType(RequiredInventory, bAllowSubclass) != none;
        // End:0x130
        if(!bHasItem && bCheckVehicleDriver)
        {
            V = Vehicle(P);
            // End:0x130
            if((V != none) && V.Driver != none)
            {
                bHasItem = V.Driver.FindInventoryType(RequiredInventory, bAllowSubclass) != none;
            }
        }
        OutputLinks[((bHasItem) ? 0 : 1)].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Has Item",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Doesn't Have Item",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Has Inventory"
}