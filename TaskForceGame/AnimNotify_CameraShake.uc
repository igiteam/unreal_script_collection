
class AnimNotify_CameraShake extends AnimNotify_Scripted;

var(CameraShake) float ShakeTime; 
var(CameraShake) float RollMag;
var(CameraShake) float RollRate; 
var(CameraShake) vector OffsetMag;
var(CameraShake) vector OffsetRate;
var(CameraShake) float OffsetTime;

event Notify( Actor Owner )
{
	if (Owner.Instigator != None && 
		Owner.Instigator.Controller != None && 
		Owner.Instigator.Controller.bIsPlayer )
	{
		PlayerController(Owner.Instigator.Controller).SetupShake( ShakeTime, OffsetMag, 0.01f, false, 0 );
		//PlayerController(Owner.Instigator.Controller).ShakeView(ShakeTime, RollMag, OffsetMag, RollRate, OffsetRate, OffsetTime);
	}
}


