class SPGolemActorPersistent extends SPSkeletalMeshActorMAT
    native;

var export editinline SkeletalMeshComponent TorsoComp;

// Export USPGolemActorPersistent::execCopySkelComponentSettings(FFrame&, void* const)
native function CopySkelComponentSettings();

function PostBeginPlay()
{
    super.PostBeginPlay();
    CopySkelComponentSettings();
    //return;    
}
