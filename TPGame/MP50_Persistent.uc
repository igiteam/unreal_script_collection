class MP50_Persistent extends TPWeapon
	hidedropdown;


var SpotLightComponent  Flashlight;
var bool                bFlashlightIsOn;
var bool                bWasOn;

var SoundCue            FlashLightOnSound;
var SoundCue            FlashLightOffSound;

simulated event PostBeginPlay()
{
	//Randomize the NPC fire sound
	//Sound_Fire_NPC[0] = Sound_Fire_NPC_Variety[ Rand(Sound_Fire_NPC_Variety.Length) ];

	super.PostBeginPlay();

    if (Flashlight != None)
    {
        SkeletalMeshComponent(Mesh).AttachComponentToSocket(Flashlight,'Light');
    }
}


simulated function float FireRecoilProcess (float Percent, float FireAngle)
{
    FireAngle = Super.FireRecoilProcess (Percent, FireAngle);
    return FireAngle / Percent;
}


function ToggleFlashlight(bool On)
{
    Flashlight.SetEnabled(On);
    bFlashlightIsOn=On;

    if (On)
        PlaySound(FlashLightOnSound);
    else
        PlaySound(FlashLightOffSound);
}

