class NaziNightAPCMG_Persistent extends NaziAPCMG_Persistent
    abstract;

var SpotLightComponent			 Spotlight_L;
var SpotLightComponent			 Spotlight_R;
var PointLightComponent			 SourceLight_L;
var PointLightComponent			 SourceLight_R;

var SpotlightInterpActor		 SpotlightCone_L;
var SpotlightInterpActor		 SpotlightCone_R;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	Mesh.AttachComponentToSocket(Spotlight_L,'Spotlight_L');
	Spotlight_L.SetEnabled(true);
	Mesh.AttachComponentToSocket(Sourcelight_L,'Spotlight_L');
	Sourcelight_L.SetEnabled(true);
	SpotlightCone_L = Spawn(class'SpotlightInterpActor');
	SpotlightCone_L.SetBase(self,, Mesh, 'Spotlight_L');
	SpotlightCone_L.SetDrawScale3D(vect(0.3f,0.2f,0.2f));

	Mesh.AttachComponentToSocket(Spotlight_R,'Spotlight_R');
	Spotlight_R.SetEnabled(true);
	Mesh.AttachComponentToSocket(Sourcelight_R,'Spotlight_R');
	Sourcelight_R.SetEnabled(true);
	SpotlightCone_R = Spawn(class'SpotlightInterpActor');
	SpotlightCone_R.SetBase(self,, Mesh, 'Spotlight_R');
	SpotlightCone_R.SetDrawScale3D(vect(0.3f,0.2f,0.2f));
}

event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local bool CanDamage;	
	
	if (DestructComponent != None)
	{
		CanDamage = DestructComponent.CanDoDamageType(damageType);
	}
	else
	{
		CanDamage = true;
	}

	if (CanDamage && ((Health - Damage) <= 0))
	{
		SpotlightCone_L.Destroy();
		SpotlightCone_R.Destroy();

		DetachFromController();
	}

	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo, DamageCauser);
}

