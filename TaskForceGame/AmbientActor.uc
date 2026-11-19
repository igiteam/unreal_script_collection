class AmbientActor extends Actor
	placeable;

var() name			Animation;
var() float			Rate;
var() bool			bLoopAnim;

function PostBeginPlay()
{
	if(Animation != 'None')
	{
		if(bLoopAnim)
		{
			LoopAnim(Animation,Rate);
		}
		else
		{
			PlayAnim(Animation,Rate);
		}
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    Rate=1.0000000
    bLoopAnim=true
    DrawType=2
    bStaticLighting=true
}