class DestructibleMesh extends StaticMeshActor
	native;

struct SoundStruct {
	var() Sound	Sound;
	var() ESoundSlot Slot;
	var() float	Volume;
	var() bool	bNoOverride;
	var() float	Radius;
	var() float	Pitch;
	var() bool	Attenuate;
	var() int	TriggerAt;
	var() bool  bTriggerOnceOnly;  
	var		bool bTriggered;
};

// Rotator of Ranges
/*struct RangeRotator
{
	var()	Range Pitch;
	var()	Range Yaw;
	var()	Range Roll;
};*/


var(Destructible) bool bDestroyable;
var(Destructible) int HitPoints;
var(Destructible) MaterialType.EMaterialTypes	DebrisType;
var(Destructible) export editinline array<EmitterList> DestructionEffects;
var(Destructible) int MinimumDamageAmount; // Threshold that must be hit by any damage before damage is taken.
var(Destructible) export array<class<DamageType> > AllowedDamageTypes;
var(Destructible) export editinline array<DestructibleMeshList> DestroyedMeshs;
var(Destructible) export array<SoundStruct> DestructionSounds;

var(Destructible) bool bDirectional;
var(Destructible) Vector Direction;

var(Destructible) bool bDamageOthers;
var(Destructible) bool bBlindAI;
var(Destructible) class<DamageType> MyDamageType;
var(Destructible) float DamageRadius;
var(Destructible) float InnerDamageRadius;
var(Destructible) int CausedDamageAmount;
var(Destructible) int MomentumTransfer;

var(Destructible) bool IsUnique;
var(Destructible) bool bRemainSolidWhenDestroyed;
var(Destructible) bool bProjectileBounceCanDamage;  // e.g. grenade bouncing off this can cause damage


function PostBeginPlay()
{
	local int i;
	

	for(i = 0; i < DestroyedMeshs.Length; ++i)
	{
		DestroyedMeshs[i].PositionalOffset = GetRandVect(DestroyedMeshs[i].PosOffset);
		DestroyedMeshs[i].RotationalOffset = GetRandRot(DestroyedMeshs[i].RotOffset);
	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType, optional Controller KillerController)
{
	local DestructibleMeshList DML;

	if( ReduceDamage(Damage,damageType) == 0 ) return;

	HitPoints -= Damage;
	
	PlaySounds();
	StartEmitters();
	HurtOthers();
	SendEvents();

	DML = FindNextMesh();

	if(DML != None)
	{		
		SwapMesh(DML);	
	}
	else if(HitPoints <= 0)
	{
		Destroy();
	}
}


// Return the DML with the TriggerAt value closest to and <= HitPoints
function DestructibleMeshList FindNextMesh()
{
	local DestructibleMeshList DML;
	local int i;

	for(i=0 ; i < DestroyedMeshs.Length ; i++)
	{
		if( (HitPoints <= DestroyedMeshs[i].TriggerAt) && (!DestroyedMeshs[i].bTriggered) )
		{	
			if(DML == None)
			{
				DML = DestroyedMeshs[i];
			}
			else
			{
				if( Abs(HitPoints - DestroyedMeshs[i].TriggerAt) < Abs(HitPoints - DML.TriggerAt) )
				{
					DML.bTriggered = true;
					DML = DestroyedMeshs[i];
				}
			}
		}
	}

	return DML;
}

event int ReduceDamage(int Damage, class<DamageType> damageType)
{
	local int i;
	if( (MinimumDamageAmount > Damage) ||
		!bDestroyable)
	{
		return 0;
	}

	if( AllowedDamageTypes.Length == 0 )
		return Damage;

	for(i=0; i < AllowedDamageTypes.Length ; i++)
	{
		if(damageType == AllowedDamageTypes[i])
			return Damage;
	}

	return 0;
}

//----------------------------------------------------------------------------//
// Trigger(                                                                   //
//                                                                            //
// Called when triggered													  //
//----------------------------------------------------------------------------//
function Trigger( actor Other, pawn EventInstigator )
{
	TakeDamage( HitPoints, EventInstigator,vect(0,0,0),vect(0,0,0), None);
}

function PlaySounds()
{
	local int i;

	for(i=0; i < DestructionSounds.Length ; i++)
	{
		if( (HitPoints <= DestructionSounds[i].TriggerAt) && (!DestructionSounds[i].bTriggered) )
		{
			PlaySound(DestructionSounds[i].Sound);/*,DestructionSounds[i].Slot,DestructionSounds[i].Volume,
				DestructionSounds[i].bNoOverride, DestructionSounds[i].Radius, DestructionSounds[i].Pitch,DestructionSounds[i].Attenuate);*/

			if(DestructionSounds[i].bTriggerOnceOnly)
				DestructionSounds[i].bTriggered = true;
		}
	}

}

function StartEmitters()
{
	local int i,j;
	local Emitter e;
	
	for(i=0; i < DestructionEffects.Length ; i++)
	{
		if(DestructionEffects[i] != None)
		{
			if( (HitPoints <= DestructionEffects[i].TriggerAt) && (!DestructionEffects[i].bTriggered) )
			{
				e = spawn(DestructionEffects[i].MyEmitter,,, Location + ( (DestructionEffects[i].PositionalOffset >> Rotation) * DrawScale3d), Rotation + DestructionEffects[i].RotationalOffset);
				if(e != None)
				{
					e.SetEmitterScale(DrawScale3D * DrawScale);
				
					for(j=0; j < e.Emitters.Length; j++)
					{	
						if(e.Emitters[j] != None && e.Emitters[j].Disabled)
						{
							e.Emitters[j].Trigger();
						}
					}
				}
				
				if(DestructionEffects[i].bTriggerOnceOnly)
					DestructionEffects[i].bTriggered = true;
			}
		}
	}
}

function HurtOthers()
{
	if(bDamageOthers && (Hitpoints <= 0))
	{
		// Should always give at least a small amount momentum transfer so that the player's
		// hit indicator will correctly indicate the direction from which damage is coming.
		HurtRadius(CausedDamageAmount,DamageRadius,MyDamageType,FMax(MomentumTransfer,0.1),Location,InnerDamageRadius);
	}
}

function SendEvents(optional Pawn EventInstigator)
{
	if(Hitpoints <= 0)
	{
		TriggerEvent( Event, Self, EventInstigator );
	}
}


function SwapMesh(DestructibleMeshList DML)
{
	//local DestructibleMesh DM;
	local int i;

	if(!DML.IsA('DestructibleMeshList')) {
		log(name@"referenced invalid DestructibleMeshList!"@DML);
		return;
	}

	SetStaticMesh(DML.MyMeshStruct.MyStaticMesh);

	if(DML.MyMeshStruct.Skins.Length > 0) 
	{
		for(i=0; i<DML.MyMeshStruct.Skins.Length; i++)
		{
			if(DML.MyMeshStruct.Skins[i] != None)
				Skins[i] = DML.MyMeshStruct.Skins[i];
		}
	}

	bDestroyable = DML.MyMeshStruct.bDestroyable;
	bProjTarget = bDestroyable;
	if(!bDestroyable && !bRemainSolidWhenDestroyed)
	{
		SetCollision(false,false,false);
	}
	SetLocation(Location + DML.PositionalOffset);
	SetRotation(Rotation + DML.RotationalOffset);

	DML.bTriggered = true;
}

function Vector GetRandVect(RangeVector v)
{
	local Vector ret;
	
	ret.X = RandRange(v.X.Min,v.X.Max);
	ret.Y = RandRange(v.Y.Min,v.Y.Max);
	ret.Z = RandRange(v.Z.Min,v.Z.Max);
	
	return ret;
}

function Rotator GetRandRot(RangeVector r)
{
	local Rotator ret;
	
	ret.Yaw = RandRange(r.X.Min,r.X.Max);
	ret.Pitch = RandRange(r.Y.Min,r.Y.Max);
	ret.Roll = RandRange(r.Z.Min,r.Z.Max);
	
	return ret;
}

event BaseChange()
{
	SetPhysics(PHYS_Falling);
}

event Landed(vector HitNormal)
{
	SetPhysics(PHYS_None);
}


// Decompiled with UE Explorer.
defaultproperties
{
    bDestroyable=true
    HitPoints=100
    bStatic=false
    bPermeableToSniperBullets=true
    bShowBulletHoles=false
    AutoAimPriority=1
    bShadowCast=false
    SoundOcclusion=1
    bCollideWorld=true
    bProjTarget=true
}