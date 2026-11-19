//-----------------------------------------------------------
//   ??????????????MeshActor????????
//-----------------------------------------------------------
class HDDestroyMeshActor extends StaticMeshActor //DynamicSMActor
native(HDGame);

struct native ParticleInfo
{
    var()  ParticleSystem	    Particle;
    var()  float                ParticleScale;
    var()  vector               ParticleLocation;
    var()  rotator              ParticleRotation;
    var()  transient Emitter    RefEmitter;  //help getting location & rotation

    structdefaultproperties
    {
    	ParticleScale=1.0f
    }
};

struct native DestroyInfo
{
    var()  int Health;
    var()  int AutoDestory;
    var()  MaterialInterface              MaterialOnDestroy;
    var()  StaticMesh		              MeshOnDestroy;
    var()  vector                         MeshLocation;
    var()  rotator                        MeshRotation;
    var()  SoundCue		                  SoundOnDestroy;
    var()  array<ParticleInfo>            ParticlesOnDestroy;
};

struct native DestroyPart
{
    var() int   SubIndex;
    /**MaxDestroyInfoSize = 5*/
    var() array<DestroyInfo> Info;
    var() bool  bAutoStopPS;

    var   transient bool  bDestroyed;
    var   transient array<ParticleSystemComponent>  ActivePSC;
};

//for NET
struct native DestroyNetInfo
{
    var  byte  DestroyInfo[5];
    var  bool  bDestroyed;

    structdefaultproperties
    {
  		DestroyInfo[0] = 255
  		DestroyInfo[1] = 255
  		DestroyInfo[2] = 255
  		DestroyInfo[3] = 255
  		DestroyInfo[4] = 255
    }
};

struct native AutoDestroyInfo
{
    var  int  PartIndex;
    var  int  InfoIndex;
    var  int  AutoDestroy;
};

/**MaxPartsSize = 5*/
var()   array<DestroyPart>       DestroyParts;
var()   array<Actor>             ChildrenParts;
var()   array<Actor>             NewPartsWhenDestroyed;
var()   Actor                    ReplaceActor;
var()   Actor                    ExtraImpulseActor;

var     transient array<int>    ChangedMat;

var()   int                     FinalPart;
var()   Material                PenetratedMat;
var()   bool                    bHiddenOnDestroy;

var()   bool                    bSameLightMap;
var()   const  DynamicLightEnvironmentComponent LightEnvironment;

/*When FinalPart destroyed, would cause Explode Damage*/
var()   bool                    bExplodeDamage;
var()   float                   ExplodeRadius;
var()   int                     ExplodeDamage;
var()   float                   ExplodeImpulse;
var()   float                   ExplodePhysicTime;

var()   array< class<DamageType> > DamageTypes<AllowAbstract>;
var()	class<DamageType> DmgType;

var transient repnotify DestroyNetInfo DNetInfo;

var transient AutoDestroyInfo ADInfo;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

replication
{
     if( Role == ROLE_Authority && bNetInitial )
		 DNetInfo;
}

final reliable server function ForceSync()
{
    ReplaceActor.bForceNetUpdate = TRUE;
}

simulated event ReplicatedEvent(name VarName)
{
    local KActor KA;
    local int i;

	if(VarName == 'DNetInfo')
	{
        for(i = 0; i < 5; i++)
        {
            //`logd("#HDDestroyMeshActor::DestroyPartsIndex="@DNetInfo.DestroyPartsIndex@"DestroyInfoIndex="@DNetInfo.DestroyInfoIndex);
             if(DNetInfo.DestroyInfo[i] < 255)
                DoDestroy(i, DNetInfo.DestroyInfo[i], DNetInfo.bDestroyed, true);
        }

      	if(DNetInfo.bDestroyed)
      	{
     	    OnFullDestroyed(true);

            KA = KActor(ReplaceActor);
            if(KA != none)
            {
        	   	ForceSync();
            }
  	    }
	}
	else
	{
       ;

		Super.ReplicatedEvent(VarName);
	}
}

final simulated function SetPhysicsEx(Actor A, bool bEnable)
{
	A.SetPhysics( (bEnable && KActor(A) != none) ? PHYS_RigidBody : PHYS_None );

	A.SetCollision(bEnable, bEnable);
	if(A.CollisionComponent != None)
	{
		A.CollisionComponent.SetBlockRigidBody(bEnable);
	}
}

// Note that PostBeginPlay() and SetInitialState() are never called for StaticMeshActors
/** Used to shut down actor on the server to reduce overhead. */
event PreBeginPlay()
{
    local Actor A;
    local KActor KA;

	Super.PreBeginPlay();

    foreach NewPartsWhenDestroyed(A)
    {
    	SetPhysicsEx(A, false);

    	KA = KActor(A);
    	if(KA != none)
    	   KA.bDamageAppliesImpulse = false;

    	A.SetHidden(true);
    }

    if(ReplaceActor != none)
    {
        SetPhysicsEx(ReplaceActor, false);

       	KA = KActor(ReplaceActor);
    	if(KA != none)
    	   KA.bDamageAppliesImpulse = false;

        ReplaceActor.SetHidden(true);
    }
}

final native function BecomeDynamic(bool bDynamic);

final reliable sync function SyncOnFullDestroyed(Controller EventInstigator)
{
   OnFullDestroyed(false, (Role == ROLE_Authority) ? EventInstigator : none);
}

final simulated function OnFullDestroyed(bool bSkipPhysics, optional Controller EventInstigator)
{
    local Actor A;
    //local KActorFromStatic NewKActor;

    foreach ChildrenParts(A)
    {
       //if( StaticMeshActor(A) != none )
       //   NewKActor = class'KActorFromStatic'.Static.MakeDynamic( StaticMeshActor(A).StaticMeshComponent );

          if( HDDestroyMeshActor(A) != none )
          {
             	SetPhysicsEx(A, false);
    	        A.SetHidden(true);
          }
          else
          {
              A.ShutDown();
          }
    }

    foreach NewPartsWhenDestroyed(A)
    {
        if(!bSkipPhysics || KActor(A) == none)
        {
            SetPhysicsEx(A, true);
  	        A.SetHidden(false);
        }
    }

    if(bHiddenOnDestroy)
    {
    	SetPhysicsEx(self, false);
    	SetHidden(true);
    }

    if(ReplaceActor != none && !bSkipPhysics)
    {
        //if(WorldInfo.NetMode == NM_Standalone)
        //{
            SetPhysicsEx(ReplaceActor, true);
        //}
       // else //disable physics in netmode?
//        {
//           	ReplaceActor.SetCollision(true, true);
//        	if(ReplaceActor.CollisionComponent != None)
//        	{
//        		ReplaceActor.CollisionComponent.SetBlockRigidBody(true);
//        	}
//        }

    	ReplaceActor.SetHidden(false);
    }

    if(bExplodeDamage)
        Explode(EventInstigator, bSkipPhysics);
}

final simulated function Explode(Controller EventInstigator, bool bSkipPhysics)
{
	local Actor	Victim, HitActor;
	local vector BBoxCenter, ExplodeLocation;
	local vector HurtNormal, HurtLocation;
	local Box BBox;
	local HDPawn P;
	local float	Momentum;
	local KActor KA;
	local RB_LineImpulseActor RBL;
	local RB_RadialImpulseActor RBR;
	local SeqAct_Toggle AgentToggle;

    GetComponentsBoundingBox(BBox);
    ExplodeLocation = (BBox.Min + BBox.Max) * 0.5f;

    if(Role == ROLE_Authority) //only server
    {
        Momentum = (ExplodeImpulse >= 0.0) ? ExplodeImpulse : ExplodeDamage * 2.0;

        foreach CollidingActors( class'Actor', Victim, ExplodeRadius, ExplodeLocation )
    	{
    		if( Victim != self && Victim != ReplaceActor && (!Victim.bWorldGeometry || !Victim.bStatic) && (Victim.bProjTarget || NavigationPoint(Victim) == None) )
    		{
                HitActor = Trace(HurtNormal, HurtLocation, ExplodeLocation, Victim.Location, FALSE,,, TRACEFLAG_Bullet);
    			if(HitActor != none && HitActor != Victim)
    			{
    			    //one more time
       		        Victim.GetComponentsBoundingBox(BBox);
    				BBoxCenter = (BBox.Min + BBox.Max) * 0.5f;
    				HitActor = Trace(HurtNormal, HurtLocation, ExplodeLocation, BBoxCenter, FALSE,,, TRACEFLAG_Bullet);

        			if(HitActor != none && HitActor != Victim) //check block
        			{
        			    if( HitActor == ReplaceActor || NewPartsWhenDestroyed.Find(HitActor) >=0 )
        			        HurtLocation = Victim.Location;
                        else
                           continue;
                    }
    			}

    			KA = KActor(Victim);
    			if(KA != none)
    			{
    			    KA.ApplyImpulse(KA.Location - ExplodeLocation, Momentum, HurtLocation);
                }
                else
                {
              		Victim.TakeRadiusDamage(EventInstigator, ExplodeDamage, ExplodeRadius, DmgType, Momentum, ExplodeLocation, false, self);
                }
    		}
    	}

    	SetTimer(ExplodePhysicTime, false, nameof(DisablePhysics));
    }

    //Shake
    P = HDPawn( GetALocalPlayerController().Pawn );
    if(P != none && VSizeSq(P.Location - ExplodeLocation) < ExplodeRadius * ExplodeRadius * 2.25 )
	{
        P.OnShakeCameraEffect(ExplodeLocation, true, ExplodeRadius * 2.0, 0.5);
	}

    //Need more impulse
	if(ExtraImpulseActor != none && !bSkipPhysics)
	{
        AgentToggle = new(self) class'SeqAct_Toggle';
        AgentToggle.InputLinks[0].bHasImpulse = true;

        RBL = RB_LineImpulseActor(ExtraImpulseActor);
        if(RBL != none)
        {
            RBL.OnToggle(AgentToggle);
        }
        else
        {
            RBR = RB_RadialImpulseActor(ExtraImpulseActor);
            if(RBR != none)
            {
              RBR.OnToggle(AgentToggle);
            }
        }
    }
}

final function DisablePhysics()
{
    local Actor A;
    local KActor KA;

    foreach NewPartsWhenDestroyed(A)
    {
         KA = KActor(A);
         if(KA != none)
         {
	         KA.ShutDown(); //bNoDelete=true, couldn't use Destroy
	     }
    }

    KA = KActor(ReplaceActor);
    if(KA != none)
    {
        KA.SetPhysics(PHYS_None);
        //KA.StaticMeshComponent.PutRigidBodyToSleep();
        KA.bDamageAppliesImpulse = false;

        KA.NetUpdateFrequency = 0.1;
	    // force immediate network update of these changes
	    KA.bForceNetUpdate = TRUE;
    }
}

final function int GetHitSubIndex(Material HitMaterial)
{
    local int MatIdx, NumElements;
    local MaterialInterface MI;

    NumElements = StaticMeshComponent.GetNumElements();
    for( MatIdx = 0; MatIdx < NumElements; MatIdx++ )
	{
	    MI = StaticMeshComponent.GetMaterial(MatIdx);  //MaterialInterface!
		if(MI.GetMaterial() == HitMaterial) //need Material
		{
			return MatIdx;
		}
	}

	return -1;
}

final function OnTakeDamage(int PartsIndex, int InfoIndex, Controller EventInstigator)
{
    if(PartsIndex >= 5)
    {
       ;
    }
    DNetInfo.DestroyInfo[PartsIndex] = InfoIndex;

    SyncDoDestroy(PartsIndex, InfoIndex, EventInstigator);

    if(InfoIndex == DestroyParts[PartsIndex].Info.Length - 1) //final step
    {
      DestroyParts[PartsIndex].bDestroyed = true;

      if(PartsIndex == FinalPart)
      {
         DNetInfo.bDestroyed = true;
         ClearTimer(nameof(AutoDestoryTimer));

         SyncOnFullDestroyed(EventInstigator);
      }
    }
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int PartsIndex, InfoIndex, Matching, HitIndex;
    //`logd("DamageAmount="@DamageAmount@"EventInstigator="@EventInstigator@"DamageCauser="@DamageCauser);

    if(!DNetInfo.bDestroyed && IsValidDamageType(DamageType))
    {
        // call Actor's version to handle any SeqEvent_TakeDamage for scripting
        Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

        HitIndex = (HitInfo.HitComponent != none) ? GetHitSubIndex(HitInfo.Material) : -1;

        for(PartsIndex = 0; PartsIndex < DestroyParts.Length; PartsIndex++)
        {
            if( (HitIndex >= 0 && DestroyParts[PartsIndex].SubIndex == HitIndex) || (HitIndex < 0 && PartsIndex == FinalPart) ) //check sub mesh
            {
                if(!DestroyParts[PartsIndex].bDestroyed)
                {
                    for(InfoIndex = 0; InfoIndex < DestroyParts[PartsIndex].Info.Length; InfoIndex++)  //check info
                    {
                        if(DestroyParts[PartsIndex].Info[InfoIndex].Health > 0)
                        {
                            DestroyParts[PartsIndex].Info[InfoIndex].Health -= DamageAmount;
                            Matching = InfoIndex;

                            if(DestroyParts[PartsIndex].Info[InfoIndex].Health < 0)  //go to next info
                            {
                                for(Matching = InfoIndex + 1; Matching < DestroyParts[PartsIndex].Info.Length; Matching++)
                                {
                                    DestroyParts[PartsIndex].Info[Matching].Health += DestroyParts[PartsIndex].Info[Matching-1].Health;

                                    if(DestroyParts[PartsIndex].Info[Matching].Health >= 0) //need no further
                                       break;
                                }

                                if(Matching == DestroyParts[PartsIndex].Info.Length || DestroyParts[PartsIndex].Info[Matching].Health > 0)
                                    Matching--;  //step back
                            }

                           if(DestroyParts[PartsIndex].Info[Matching].Health <= 0)
                           {
                               OnTakeDamage(PartsIndex, Matching, EventInstigator);
                           }

                           break;
                        }
                    }
                }

                break;
            }
        }

    }
}

final simulated function ParticleSystemComponent SpawnEmitter(ParticleSystem EmitterTemplate, vector SpawnLocation, optional rotator SpawnRotation)
{
	//local int i;
	local ParticleSystemComponent Result;

	if(EmitterTemplate != None)
	{
		// try to grab one from the pool
		Result = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(EmitterTemplate);

		//Result.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
		Result.OnSystemFinished = MyOnParticleSystemFinished;
		//Result.bUpdateComponentInTick = true;
		 //Result.SetAbsolute(true, true, true);
		Result.SetTranslation(SpawnLocation);
		Result.SetRotation(SpawnRotation);

		AttachComponent(Result);  //unload/destroy this Actor, PS would be cleaned

		return Result;
	}
	else
	{
		;
		ScriptTrace();

		return None;
	}
}

simulated function MyOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    // clear component and return to pool
    DetachComponent(PSC);
    WorldInfo.MyEmitterPool.OnParticleSystemFinished(PSC);
}

final reliable sync function SyncDoDestroy(int PartsIndex, int InfoIndex, Controller EventInstigator)
{
    DoDestroy(PartsIndex, InfoIndex, false, false, (Role == ROLE_Authority) ? EventInstigator : none);
}

final simulated function DoDestroy(int PartsIndex, int InfoIndex, bool bSkipEffects, bool bSkipSound, optional Controller EventInstigator)
{
    local int i;
    local ParticleSystemComponent PSC;
    local vector RetLoc;

    //Clear old PS
    if(DestroyParts[PartsIndex].bAutoStopPS)
    {
        foreach DestroyParts[PartsIndex].ActivePSC(PSC)
        {
           PSC.DeactivateSystem();
           PSC.KillParticlesForced();
        }
        DestroyParts[PartsIndex].ActivePSC.Length = 0;
    }

    //New Mesh if any
    if(DestroyParts[PartsIndex].Info[InfoIndex].MeshOnDestroy != None)
    {
   	    if(!bSameLightMap)
        {
           BecomeDynamic(true);
           LightEnvironment.SetEnabled(true);
        }

  	    StaticMeshComponent.SetStaticMesh(DestroyParts[PartsIndex].Info[InfoIndex].MeshOnDestroy);
  	    StaticMeshComponent.SetTranslation(DestroyParts[PartsIndex].Info[InfoIndex].MeshLocation);
  	    StaticMeshComponent.SetRotation(DestroyParts[PartsIndex].Info[InfoIndex].MeshRotation);

  	     //Change Mesh should reset Material
        for(i = 0; i < ChangedMat.Length; i++)
    	{
    	    StaticMeshComponent.SetMaterial(ChangedMat[i], none);
    	}
    	ChangedMat.Length = 0;
    }

    //New Material if any
	if(DestroyParts[PartsIndex].Info[InfoIndex].MaterialOnDestroy != none)
	{
        StaticMeshComponent.SetMaterial(DestroyParts[PartsIndex].SubIndex, DestroyParts[PartsIndex].Info[InfoIndex].MaterialOnDestroy);

        ChangedMat.AddItem(DestroyParts[PartsIndex].SubIndex);   //record
	}

     if(!bSkipEffects)
     {
        //New Particles if any
        for(i = 0; i < DestroyParts[PartsIndex].Info[InfoIndex].ParticlesOnDestroy.Length; i++)
        {
            if(DestroyParts[PartsIndex].Info[InfoIndex].ParticlesOnDestroy[i].Particle != None)
            {
                RetLoc = TransformVector( MakeRotationTranslationMatrix(vect(0,0,0), Rotation), DestroyParts[PartsIndex].Info[InfoIndex].ParticlesOnDestroy[i].ParticleLocation );

                PSC = SpawnEmitter(DestroyParts[PartsIndex].Info[InfoIndex].ParticlesOnDestroy[i].Particle, Location + RetLoc, Rotation + DestroyParts[PartsIndex].Info[InfoIndex].ParticlesOnDestroy[i].ParticleRotation);
                PSC.SetScale(DestroyParts[PartsIndex].Info[InfoIndex].ParticlesOnDestroy[i].ParticleScale);
                PSC.SetIgnoreOwnerHidden(true);

                if(DestroyParts[PartsIndex].bAutoStopPS)
                {
                    DestroyParts[PartsIndex].ActivePSC.AddItem(PSC); //record
                }
            }
        }
     }

    // Play Sound if any
    if(!bSkipSound)
    {
        if(DestroyParts[PartsIndex].Info[InfoIndex].SoundOnDestroy != None)
        {
        	PlaySound(DestroyParts[PartsIndex].Info[InfoIndex].SoundOnDestroy, True);

        	if(EventInstigator != none)
        	    EventInstigator.MakeNoise(0.5);
            else
                MakeNoise(0.5);
        }
    }

    //Auto Destroy if any
    if(Role == ROLE_Authority && DestroyParts[PartsIndex].Info[InfoIndex].AutoDestory > 0 && InfoIndex < DestroyParts[PartsIndex].Info.Length - 1)
    {
        ADInfo.PartIndex = PartsIndex;
        ADInfo.InfoIndex = InfoIndex + 1;
        ADInfo.AutoDestroy = DestroyParts[PartsIndex].Info[InfoIndex].AutoDestory;

        SetTimer(1.0, true, nameof(AutoDestoryTimer)); //only once!
    }
}

final function AutoDestoryTimer()
{
    if(DestroyParts[ADInfo.PartIndex].Info[ADInfo.InfoIndex].Health > 0)
    {
         DestroyParts[ADInfo.PartIndex].Info[ADInfo.InfoIndex].Health -= ADInfo.AutoDestroy;
         if(DestroyParts[ADInfo.PartIndex].Info[ADInfo.InfoIndex].Health <= 0)
         {
             ClearTimer(nameof(AutoDestoryTimer));

             OnTakeDamage(ADInfo.PartIndex, ADInfo.InfoIndex, none);
         }
    }
    else
    {
         ClearTimer(nameof(AutoDestoryTimer));
    }
}

final simulated function bool DamagePenetrate(const out TraceHitInfo HitInfo)
{
    return HitInfo.Material != none && HitInfo.Material == PenetratedMat;
}

/* Reset()
reset actor to initial state - used when restarting level without reloading.
*/
//event Reset()
//{
//}

final function bool IsValidDamageType(class<DamageType> inDamageType)
{
	local int Idx;
	local bool bValidDamageType;

	// if any damage types are specified, then verify the inDamageType is a child of at least one
	if (DamageTypes.Length > 0)
	{
		bValidDamageType = FALSE;
		for (Idx = 0; Idx < DamageTypes.Length; Idx++)
		{
			if (ClassIsChildOf(inDamageType,DamageTypes[Idx]))
			{
				bValidDamageType = TRUE;
				// no need to keep looking
				break;
			}
		}

		if (!bValidDamageType)
		{
			return FALSE;
		}
	}

	return TRUE;
}


