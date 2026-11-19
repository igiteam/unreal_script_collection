class DestructibleMover extends ZombieMover;

struct SoundStruct {
	var() Sound	Sound;
	var() ESoundSlot Slot;
	var() float	Volume;
	var() bool	bNoOverride;
	var() float	Radius;
	var() float	Pitch;
	var() bool	Attenuate;
	var() int	TriggerAt;
	var() bool  	bTriggerOnceOnly;  
	var		bool bTriggered;
};

struct KeyDamageStruct {
	var() int			KeyNum;
	var() int			InflictDamage;
	var() class<DamageType>		DamageType;
};

var(Destructible) bool bDestroyable;
var(Destructible) int HitPoints;
var(Destructible) MaterialType.EMaterialTypes	DebrisType;

var(Destructible) export editinline array<EmitterList>	DestructionEffects;
var(Destructible) int					MinimumDamageAmount;
var(Destructible) export array< class<DamageType> >	DisallowedDamageTypes;
var(Destructible) export array< KeyDamageStruct >	KeyDamage;
var(Destructible) export array< SoundStruct >		DestructionSounds;
var(Destructible) export editinline array<DestructibleMeshList> DestroyedMeshs;

var(Destructible) bool				bDamageOthers;
var(Destructible) class<DamageType>		MyDamageType;
var(Destructible) float				DamageRadius;
var(Destructible) int				CausedDamageAmount;
var(Destructible) int				MomentumTransfer;

var(DestructibleMover) bool 			bGotoKarma;
// var(DestructibleMover) vector		 	KActorType;

// Interpolation ended.
simulated event KeyFrameReached()
{
	local int i;
	local Pawn myPawn;

	Super.KeyFrameReached();

	for(i=0;i<KeyDamage.Length;++i){
		if(KeyDamage[i].KeyNum == KeyNum && KeyDamage[i].InflictDamage > 0){
			TakeDamage( KeyDamage[i].InflictDamage, myPawn, Location, vect(0,0,0), KeyDamage[i].DamageType);
		}		
	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType, optional Controller KillerController)
{
	local DestructibleMeshList DML;

	if( ReduceDamage(Damage,damageType) == 0) return;

	HitPoints -= Damage;
	
	PlaySounds();
	StartEmitters();
	HurtOthers();
	SendEvents();

	DML = FindNextMesh();

	if(DML != None)
	{		
		SwapMesh(DML);	
		if( bGotoKarma && HitPoints <= 0 )
		{
			SetPhysics( PHYS_Karma );
			KWake();
		}
	}else if(HitPoints <= 0){
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

	for(i=0; i < DisallowedDamageTypes.Length ; i++)
	{
		if(damageType == DisallowedDamageTypes[i])
			return 0;
	}

	return Damage;
}

function PlaySounds()
{
	local int i;

	for(i=0; i < DestructionSounds.Length ; i++)
	{
		if( (HitPoints <= DestructionSounds[i].TriggerAt) && (!DestructionSounds[i].bTriggered) )
		{
			PlaySound(DestructionSounds[i].Sound,DestructionSounds[i].Slot,DestructionSounds[i].Volume,
				DestructionSounds[i].bNoOverride, DestructionSounds[i].Radius, DestructionSounds[i].Pitch,DestructionSounds[i].Attenuate);

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
		if( (HitPoints <= DestructionEffects[i].TriggerAt) && (!DestructionEffects[i].bTriggered) )
		{
			e = spawn(DestructionEffects[i].MyEmitter,,, Location + ( (DestructionEffects[i].PositionalOffset >> Rotation) * DrawScale3d), Rotation + DestructionEffects[i].RotationalOffset);
			e.SetBase(self);
			e.SetEmitterScale(DrawScale3D * DrawScale);
			
			for(j=0; j < e.Emitters.Length; j++)
			{	
				if(e.Emitters[j] != None && e.Emitters[j].Disabled)
				{
					e.Emitters[j].Trigger();
				}
			}
			
			if(DestructionEffects[i].bTriggerOnceOnly)
				DestructionEffects[i].bTriggered = true;
		}
	}
}

function HurtOthers()
{
	if(bDamageOthers && (Hitpoints <= 0))
	{
		HurtRadius(CausedDamageAmount,DamageRadius,MyDamageType,MomentumTransfer,Location);
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
	SetLocation(Location + DML.PositionalOffset);
	SetRotation(Rotation + DML.RotationalOffset);

	DML.bTriggered = true;
}


// Decompiled with UE Explorer.
defaultproperties
{
    bDestroyable=true
    HitPoints=100
    bGotoKarma=true
    bNoDelete=false
    bBlockKarma=true
    // Reference: KarmaParams'DestructibleMover.KarmaParams1'
    begin object name=KarmaParams1 class=Class'Engine.KarmaParams'
        bKAllowRotate=true
        KFriction=1.0000000
        KRestitution=0.3000000
        KImpactThreshold=5000.0000000
    end object
    KParams=KarmaParams1
}