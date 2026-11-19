// These trigger volumes are intended for use in situations where projectiles
// are trigger an event when it touches the volume
class TPTriggerVolume extends TriggerVolume
	placeable;

simulated event PostBeginPlay()
{
	Super(Volume).PostBeginPlay();
}

