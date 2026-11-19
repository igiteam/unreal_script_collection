class InventoryInteractionActor extends StaticMeshActor abstract;

var(InventoryTrigger)	float	fActivationDelay; 

var ZombieUseTrigger UseTrigger;

event Activate(ZombieUseTrigger zut)
{
////	Log(Self$"::Activate()");
	UseTrigger = zut;
	GotoState('Armed');
}

event Deactivate()
{
}

state Armed
{
	simulated function BeginState()
	{
		SetTimer(fActivationDelay, false);
//	//	Log(Self$"::Armed::Activate()");
	
	}

	function Tick(float Delta)
	{
//	//	Log(Self$"::Armed::Tick()");
		Super.Tick(Delta); 
	}

	simulated function Timer()
	{
		TimesUp();
		UseTrigger.InteractionDone();
		Destroy();
	}

	function TimesUp()
	{
			local Projectile P; 

//	//	Log(Self$"::Armed::TimesUp()");
		P = Spawn(class'DelayedProjectile' ,Owner,, Location,Rotation);	
		P.Speed = 0; 
		P.LifeSpan = 0.1; 

	}
}



// Decompiled with UE Explorer.
defaultproperties
{
    fActivationDelay=5.0000000
    bStatic=false
    bWorldGeometry=false
    Rotation=(Pitch=200,Yaw=-16000,Roll=-1100)
    bShadowCast=false
    bStaticLighting=false
    bEdShouldSnap=false
}