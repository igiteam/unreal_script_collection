class MOHATrackWheelKActor extends KActor
    abstract
    native;

var float fLifeTime;
var export editinline AudioComponent impactAudioComponent;
var() SoundCue impactSoundCue;

simulated function PostBeginPlay()
{
    // End:0x5C
    if(impactSoundCue != none)
    {
        impactAudioComponent = WorldInfo.CreateAudioComponent(impactSoundCue, false, false);
        impactAudioComponent.bAutoDestroy = false;
        impactAudioComponent.bUseOwnerLocation = true;
        impactAudioComponent.bFinished = true;
    }
    //return;    
}

function SetLifeTimeAndTimer(float NewValue)
{
    fLifeTime = NewValue;
    SetTimer(fLifeTime, false);
    //return;    
}

function Timer()
{
    Destroy();
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__MOHATrackWheelKActor.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHATrackWheelKActor.MyLightEnvironment'
        bNotifyRigidBodyCollision=true
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHATrackWheelKActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    bNoDelete=false
    bNoEncroachCheck=false
    CollisionComponent=StaticMeshComponent0
}