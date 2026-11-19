class SkyGameInteractor extends SkyInteractor
    abstract
    native;

var() const editconst export editinline LightEnvironmentComponent LightEnvironment;
var() export editinline SkeletalMeshComponent SkeletalMeshComponent;
var transient Vector LevelLocation;
var transient Rotator LevelRotation;
var transient bool bMovingLevelInitialized;

function OnSetMaterial(SeqAct_SetMaterial Action)
{
    // End:0x3D
    if(SkeletalMeshComponent != none)
    {
        SkeletalMeshComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    }
    //return;    
}
