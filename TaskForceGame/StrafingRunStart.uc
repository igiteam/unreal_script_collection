class StrafingRunStart extends Actor
	placeable
	native;

var() int NumberOfShots;
var() float TimeBetweenShots;
var() vector EffectNormal;
var() name EndpointTag;
var() class<BulletImpactEffects> BulletImpactEffectClass;			
var() EMaterialTypes MaterialType;
var() int Damage;
var() class<Emitter> OverrideImpactEffect;
var() Sound OverrideSound;
var() bool bTriggerOnlyOnce;
var() float SpreadRadius;
var() float EffectScale;
var int CurShots;

var vector PerBulletOffset;
var vector StartPos;

var actor Endpoint;
var pawn TriggerPawn;
var Actor TriggerOther;

event PostBeginPlay()
{
	local float dist;
	local StrafingRunEnd end;
	local StrafingRunStart end2;

	foreach AllActors(class'ZombieGame.StrafingRunEnd',end,EndpointTag)
	{
		break;
	}
	
	foreach AllActors(class'ZombieGame.StrafingRunStart',end2,EndpointTag)
	{
		break;
	}

	if ((end == none) && (end2 == none))
	{
		log("Could not find Endpoint: " $ EndpointTag);
		gotoState('');
		return;
	}
	else if ((end != none) && (end2 != none))
	{
		log("Start and end with same EndpointTag: " $ EndpointTag);
		gotoState('');
		return;
	}
	else if (end != none)
	{
		Endpoint = end;
	}
	else if (end2 != none)
	{
		Endpoint = end2;
	}

	PerBulletOffset = Endpoint.location - location;

	dist = VSize(PerBulletOffset);

	PerBulletOffset = Normal(PerBulletOffset);

	PerBulletOffset *= (dist/NumberOfShots);

	EffectNormal = Normal(EffectNormal);

//	log("PerBulletOffset: " $ PerBulletOffset);

	StartPos = Location;
}

auto state WaitForTrigger
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		TriggerPawn = EventInstigator;
		TriggerOther = Other;
		gotoState('Active');
	}
}

function DoTimer()
{
	SetTimer(TimeBetweenShots, false);
}

state Active
{
	function BeginState()
	{
		Timer();
	}

	function Timer()
	{
		CurShots++;

		if (CurShots <= NumberOfShots)
		{
			SpawnEffect();
			DoTimer();
		}
		else
		{
			Endpoint.Trigger(TriggerOther, TriggerPawn);
		
			if ( bTriggerOnlyOnce )
				gotoState( '' );
			else {
			
				// reset number of shots taken so we can use this thing again
				CurShots = 0;
				gotoState('WaitForTrigger');
			}
		}
	}

	function SpawnEffect()
	{
		local vector pos;
		local vector newPos;
		local Actor hit;
		local vector hitLoc;
		local vector hitNorm;
		local Actor a;
		local vector randOffset;

		randOffset = Normal(PerBulletOffset cross EffectNormal);
		randOffset.X *= (FRand()*SpreadRadius*2)-SpreadRadius;
		randOffset.Y *= (FRand()*SpreadRadius*2)-SpreadRadius;
		randOffset.Z *= (FRand()*SpreadRadius*2)-SpreadRadius;

		newPos = StartPos + (PerBulletOffset*CurShots) + randOffset;

		foreach TraceActors(class'Actor', hit, hitLoc, hitNorm, newPos, pos)
		{
			//damage hit

//			log("Strafe hit " $ hit);

			if (ZombiePawn(hit) != none)
			{
				ZombiePawn(hit).TakeDamage(Damage, none, hitLoc, EffectNormal*1000, Class'ZombieGame.DamageTypeStrafingRun');
			}
			else if(DestructibleMesh(hit) != none)
			{
				DestructibleMesh(hit).TakeDamage(Damage, none, hitLoc, EffectNormal*-1000, Class'ZombieGame.DamageTypeStrafingRun');
			}
		}

		pos = newPos;

//		Spawn(ImpactEffect,,,pos,rot(16383,0,0));
//		Spawn(ImpactEffect,,,pos,rotator(EffectNormal));
		if (OverrideImpactEffect == none)
		{
			//a = BulletImpactEffectClass.static.SpawnImpactEffect(none, Self, pos, EffectNormal, MaterialType); 
			a = BulletImpactEffectClass.static.SpawnImpactEffect(Self, Self, pos, EffectNormal, MaterialType, EffectScale); 
		}
		else
		{
			a = Spawn(OverrideImpactEffect,,,pos,rotator(EffectNormal));
		}

		if(a != None)
		{
			if (OverrideSound == none)
			{
				a.PlaySound(class'SFRMAmmunition'.Default.RandomBulletImpactSounds[MaterialType],,10,,1000, 0.5+FRand(),true);
			}
			else
			{
				a.PlaySound(OverrideSound,,10,,1000, 0.5+FRand(), true);
			}
		}
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    NumberOfShots=10
    TimeBetweenShots=0.1000000
    EffectNormal=(X=0.0000000,Y=0.0000000,Z=1.0000000)
    BulletImpactEffectClass=Class'BulletImpactEffects'
    MaterialType=2
    Damage=100
    OverrideSound=Sound'CBW_DYN_Foley.Bullet_Impacts.Bullet_impact_flesh1'
    bTriggerOnlyOnce=true
    EffectScale=1.0000000
    bHidden=true
}