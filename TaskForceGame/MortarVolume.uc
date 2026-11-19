class MortarVolume extends Volume;

var() float MinTimeInterval;
var() float MaxTimeInterval;
var() class<Actor>	ImpactEffect;
var() float CielHeight;
var() float SafeRadius;

var() bool AvoidAllPawns;
var() sound IncomingSound, ExplosionSound, RadioIncomingSound; 

var(Dust) class<Actor> DustClass;
var(Dust) float DustCieling;
var(Dust) float DustOffsetFwdMin;
var(Dust) float DustOffsetFwdMax;
var(Dust) float DustOffsetSideMin;
var(Dust) float DustOffsetSideMax;

var ZombiePlayerPawn player;
var int MaxTries;
var int MaxDustTries;

var(shake) float 	ShakeOffset;
var(shake) float 	ShakeRate;
var(shake) float 	NumShakes;

var RumbleDescription ExplosionRumbleDes;

var Box volBox;
var vector EffectPos;
var float IncomingSoundLength;

var bool PosFound;
var bool PlayIncoming;

var ProxyActor soundActor;

var() bool IsLethal;

event PostBeginPlay()
{
	local float t;
	if (MinTimeInterval > MaxTimeInterval)
	{
		t = MinTimeInterval;
		MinTimeInterval = MaxTimeInterval;
		MaxTimeInterval = t;
	}

	volBox = GetVolumeBoundingBox(1);

	//
//	MinTimeInterval *= 3;
//	MaxTimeInterval *= 3;
	//
}

event Touch( Actor Other )
{
//	log("touch");

	if(bDisabled)
	{
		return;
	}

	if (ZombiePlayerPawn(Other) != none)
	{
		if (soundActor == none)
		{
			soundActor = spawn(class'ZombieGame.ProxyActor');
		}
		
		if(!IsLethal)
		{
			if (!IsInState('Active'))
			{
				gotoState('Active');
				player = ZombiePlayerPawn(Other);
			}
		} 
		else if (!IsInState('ActiveAndLethal'))
		{
			gotoState('ActiveAndLethal');
			player = ZombiePlayerPawn(Other);
		}		
	}
}

event UnTouch( Actor Other )
{
//	log("untouch");

	if (ZombiePlayerPawn(Other) != none)
	{
//		log("player untouch");

		if (!IsInState(''))
		{
//			log("valid untouch");

			gotoState('');

			player = none;
		}
	}
}

function DoTimer(optional bool enter)
{
	local float time;
	if (enter)
	{
		time = RandRange(0, MaxTimeInterval-MinTimeInterval);
	}
	else
	{
		time = RandRange(MinTimeInterval, MaxTimeInterval);
	}
	time -= IncomingSoundLength;
	SetTimer(time, false);
//	log("Mortar in "$time$" seconds.");
}

state Active
{
	function BeginState()
	{
		DoTimer();
	}

	function Timer()
	{

		if (player.controller == none)
		{
			DoTimer();
			return;
		}

		if (PlayIncoming)
		{
			PosFound = SetEffectPos();
			if (PosFound)
			{
				PlayIncoming = false;
				soundActor.SetLocation(effectPos);
				soundActor.PlaySound(IncomingSound,, 1,,5000, 0.5+FRand(),true);
				SetTimer(IncomingSoundLength, false);
			}
			else
			{
				DoTimer();
			}
		}
		else if (!PlayIncoming && PosFound)
		{
			SpawnEffect();
			PosFound = false;
			PlayIncoming = true;
			DoTimer();
		}
		else
		{
			DoTimer();
		}
	}

	//returns true if the effect will NOT hit the test Actor
	function bool CheckHitRadius(Actor test, vector randPos)
	{
		return (((randPos.x-test.location.x)*(randPos.x-test.location.x)) +	
				((randPos.y-test.location.y)*(randPos.y-test.location.y))) > 
				(SafeRadius*SafeRadius);
	}

	function bool SpawnDust()
	{
		local vector X,Y,Z;
		local vector floorPos;
		local vector cielPos;
		local vector hitNormal;
		local vector traceEnd;
		local vector dustPos;
		local actor hit;

//		log("SpawnDust: " $ player.controller @ player);

		GetAxes(player.controller.GetViewRotation(),X,Y,Z);

		dustPos = player.location + 
					(X*RandRange(DustOffsetFwdMin, DustOffsetFwdMax));

		if (FRand() > 0.5f)
		{
			dustPos += Y*RandRange(DustOffsetSideMin, DustOffsetSideMax);
		}
		else
		{
			dustPos -= Y*RandRange(DustOffsetSideMin, DustOffsetSideMax);
		}

		traceEnd = dustPos;
		traceEnd.z -= 5000;

		hit = Trace(floorPos, hitNormal, traceEnd, dustPos, True);
		if (hit == none)
		{
			return false;
		}

		traceEnd = floorPos;
		traceEnd.z += 5000;

		hit = Trace(cielPos, hitNormal, traceEnd, floorPos, True);

		if (hit != none)
		{
			traceEnd = floorPos - cielPos;

			if (VSize(traceEnd) > DustCieling)
			{
				return false;
			}
		}

		Spawn(DustClass,,,cielPos);

		return true;
	}

	function bool SetEffectPos()
	{
		local vector floorPos;
		local vector cielPos;
		local vector randPos;
		local vector hitNormal;
		local vector traceEnd;
		local actor hit;
		local ZombieBipedPawn zbp;

		local int i;

		local bool SafePos;

		/*
			ok here's the plan:
			//randVector = Random Vector;
			//randVector += PlayerPos;
			randVector = random pos in volume

			floorPos = traceDown from randVector;
			cielingPos = traceUp from floorPos;

			if Dist(floorPos, CielingPos) < CielingHeight
			{
				spawn effect at floor
			}
			else 
			{
				repeat tries times
			}

			if we still can't find a pos, distant thunder
		*/

		SafePos = false;


		for (i=0; !SafePos && i<MaxTries; ++i)
		{
			randPos.x = RandRange(volBox.min.x, volBox.max.x);
			randPos.y = RandRange(volBox.min.y, volBox.max.y);
			randPos.z = RandRange(volBox.min.z, volBox.max.z);

			if (AvoidAllPawns)
			{
				SafePos = true;

				ForEach TouchingActors(class'ZombieBipedPawn', zbp)
				{
					if (!CheckHitRadius(zbp, randPos))
					{
						SafePos = false;
						break;
					}
				}
			}
			else
			{
				if (CheckHitRadius(player, randPos))
				{
					SafePos = true;
					break;
				}
			}
		}

		if(!SafePos)
		{
			return false;
		}

		traceEnd = randPos;
		traceEnd.z -= 5000;

		hit = Trace(floorPos, hitNormal, traceEnd, randPos, True);
		if (hit == none)
		{
			return false;
		}

		traceEnd = floorPos;
		traceEnd.z += 5000;

		hit = Trace(cielPos, hitNormal, traceEnd, floorPos, True);

		if (hit != none)
		{
			traceEnd = floorPos - cielPos;

			if (VSize(traceEnd) < CielHeight)
			{
				return false;
			}
		}

		EffectPos = floorPos;
		return true;
	}

	function SpawnEffect()
	{
		local vector floorPos;
		local Actor a;

		local int i;

		floorPos = EffectPos;


		a = Spawn(ImpactEffect,,,floorPos,rot(16383,0,0));
		if(a != None) 
		{
			a.PlaySound(ExplosionSound,, 1,,5000, 0.5+FRand(),true);
		}

		player.controller.SetupShake ( 0.25f, vect ( 10, 10, 10 ), 0.01f, false, 0 );

		if (ExplosionRumbleDes != none)
		{
			PlayerController(player.controller).PlayRumble(ExplosionRumbleDes, floorPos);
		}

		for (i=0; i<MaxDustTries; ++i)
		{
			if (SpawnDust())
			{
				break;
			}
		}
	}
}

state ActiveAndLethal extends Active
{
	function DoTimer(optional bool enter)
	{
		PlaySound(RadioIncomingSound,SLOT_Interface);

		SetTimer(MaxTimeInterval, false);
	}
	
	function Timer()
	{
//		log("Timer hit");

		if (player.controller == none)
		{
			DoTimer();
			return;
		}

		if (PlayIncoming)
		{
			PosFound = SetEffectPos();
			if (PosFound)
			{
				PlayIncoming = false;
				soundActor.SetLocation(effectPos);
				soundActor.PlaySound(IncomingSound,, 1,,5000, 0.5+FRand(),true);
				SetTimer(IncomingSoundLength, false);
			}
			else
			{
				DoTimer();
			}
		}
		else if (!PlayIncoming && PosFound)
		{
			Player.TakeDamage(40, None, EffectPos, Vect(0,0,500), class'DamageTypeProjectile');
			SpawnEffect();
			PosFound = false;
			PlayIncoming = true;
			DoTimer();
		}
		else
		{
			DoTimer();
		}
	}

	function bool SetEffectPos()
	{
		EffectPos = Player.Location + (Vect(128,0,0) >> Player.Rotation);
		return true;
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    MinTimeInterval=2.0000000
    MaxTimeInterval=3.0000000
    ImpactEffect=Class'ZombieEffects.mortarblastRep'
    CielHeight=500.0000000
    SafeRadius=500.0000000
    AvoidAllPawns=true
    IncomingSound=Sound'CBW_DYN_weapons.explosions.mortar_incoming1'
    ExplosionSound=Sound'CBW_DYN_weapons.explosions.mortar_explosion1'
    DustCieling=300.0000000
    DustOffsetFwdMin=48.0000000
    DustOffsetFwdMax=144.0000000
    DustOffsetSideMin=24.0000000
    DustOffsetSideMax=96.0000000
    MaxTries=10
    MaxDustTries=10
    ShakeOffset=25.0000000
    ShakeRate=30.0000000
    NumShakes=5.0000000
    // Reference: RumbleSawtooth'MortarVolume.MortarRumble'
    begin object name=MortarRumble class=Class'RumbleSawtooth'
        Frequency=0.7500000
        Duration=0.7500000
        InnerAttenuateRadius=500.0000000
        OuterAttenuateRadius=1200.0000000
    end object
    ExplosionRumbleDes=MortarRumble
    IncomingSoundLength=0.4000000
    PlayIncoming=true
    bStatic=false
}