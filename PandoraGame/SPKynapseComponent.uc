class SPKynapseComponent extends PrimitiveComponent
    native;

var native Pointer KynapseEntity;
var private transient bool bInitialized;
var transient bool bUseExpensivePathBlocking;
var native const transient QWord SPShowFlags;
var Vector BoundsExtent;
var Vector BoundsExtentDefault;

// Export USPKynapseComponent::execInit(FFrame&, void* const)
native function Init();

// Export USPKynapseComponent::execChangeExpensivePathBlocking(FFrame&, void* const)
native function ChangeExpensivePathBlocking(bool bOn);

function bool IsInitialized()
{
    return bInitialized;
    //return ReturnValue;    
}
