class OLElectrifiedVolume extends PhysicsVolume
	native;

var() bool bElectrified;
var() int TouchDamage;
var() float KnockBack;
var() AkEvent SoundEvent;

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bElectrified = true;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bElectrified = false;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bElectrified = !bElectrified;
	}

	Super.OnToggle( Action );
}


simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local OLHero hero;

	hero = OLHero(Other);

	if (hero == None)
	{
		return;
	}

	if ( bElectrified )
	{
		hero.TakeElectricDamage(TouchDamage, KnockBack, HitNormal, SoundEvent);
	}
}

defaultproperties
{
	bElectrified=true
	TouchDamage=25
	KnockBack=15.0
}
