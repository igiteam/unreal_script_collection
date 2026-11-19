/*
 * Base class for all infantry type pawns.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_Infantry extends GearPawn
	dependson(Item_HelmetBase,GearWeapon)
	abstract
	native(Pawn)
	implements(interface_NavMeshPathObstacle)
	implements(interface_NavMeshPathObject)
	nativereplication;

`include(GearPlayerPersistentDataConstants.uci)

struct native AttachmentData
{
	var EAttachmentType DesiredSlot;
	var class<ItemSpawnable> AttachmentType;

	structdefaultproperties
	{
		DesiredSlot=eATTACHTYPE_MAX;
		AttachmentType=None
	}
};

/** The attachments desired to be attached to this pawn. Pawns should add items here instead of AttachmentClasses */
var array< AttachmentData > Attachments;

/** The total number of attachment slots
 *	NOTE: NumAttachments MUST equal amount of EAttachmentType enum values in GearTypes, at least until we can set the size of static arrays using enum values
 */
const NumAttachments = 4;

/** The total number of bytes necessary to have a bool for each attachment slot (usually ceil(NumAttachments/8, but no less than 2)) */
const NumAttachmentBytes = 2;

/** Replicated array of the attachment classes*/
var repnotify class<ItemSpawnable> AttachmentClasses[NumAttachments];
var class<ItemSpawnable> AttachmentClasses_Old[NumAttachments];

/** Bools to determine if an attachment is currently shot off or not */
var repnotify byte bIsAttachmentShotOff[NumAttachmentBytes];
var byte bIsAttachmentShotOff_Old[NumAttachmentBytes];

/** The meshes for all of the attachments */
var() editinline MeshComponent AttachmentMeshes[NumAttachments];
var MeshComponent TaccomAttachmentMeshes[NumAttachments];

/** The PSC for any persistent effects that an item might have **/
var ParticleSystemComponent AttachmentParticleEffects[NumAttachments];

/** The MICs for all attachments */
var transient MaterialInstanceConstant AttachmentMaterials[NumAttachments];

/** Array of attachment */
var array<EAttachmentType> AttachmentsThatCannotBeShotOff;

var Array<Name>	StomachBones, RightShoulderBones, LeftShoulderBones, RightLegBones, LeftLegBones;
var Name		HitReactionStomach, HitReactionLeftShoulder, HitReactionRightShoulder;

/** Idle break animation info struct */
struct native IdleBreakAnimInfo
{
	var	Name					AnimName;
	var ECoverType				CoverType;
	var GearWeapon.EWeaponType	WeaponType;
	var bool					bAIOnly;
	/** Only plays on female characters */
	var bool                    bFemale;
	/** If TRUE, play on top of existing layer, rather than replacing it */
	var bool                    b2ndLayer;
	/** Specific to a character? */
	var Name                    CharacterName;
	/** Animation can be played during walks */
	var bool                    bWalkFriendly;
};
/** List of Idle Break information */
var	Array<IdleBreakAnimInfo>	IdleBreakList;
/** Idle break animation frequency */
var vector2d					IdleBreakFreq;
/** Last idle break anim index from IdleBreakList played */
var INT							LastIdleBreakAnimIndex;

struct native IdleBreakReplicationInfo
{
	var byte	Index;
	var byte	Count;
	var byte	padding1;
	var byte	padding2;
};
var	repnotify IdleBreakReplicationInfo	ReplicatedIdleBreakInfo;

/** Last Idle Break anim played */
var BodyStance		BS_LastIdleBreakAnim;
/** Forcibly disables idle breaks - set from Kismet action */
var bool			bDisableIdleBreaks;

/** TRUE when this is a female character */
var const bool bIsFemale;

/** Name of the most recent award earned that should be displayed. Blank name for no award to display */
var name AwardEarned;

/** The location that the pawn is aiming at
 *  ONLY USED BY HEAVY SNIPER ATM
 */
var repnotify transient vector AimLocation;

/* POI turned on when a player goes dbno */
var GearPointOfInterest_DBNO DBNO_POI;

/** if set, this pawn always goes DBNO when playing the Siege gametype */
var bool bForceDBNOInSiege;

// Animation Nodes
/** Controls blend node in AnimTree */
var transient FLOAT BreathingTypeProperty;
/** Bool Property controlling if weapon is one handed or not. */
var bool    bWeaponIsOneHandedToggle;
/** Traversing BarbedWire animation */
var const BodyStance BS_TraversingBarbedWire;

var transient GearCrowdPanicRepulsor CrowdPanicRepulsor;

var transient bool bNavMeshRegistered;
var transient vector LastNavMeshCheckLocation;
var transient float LastNavMeshCheckUpdateTime;
var() float NavMeshObstacleRegistrationTime;

/** mesh for event hat (if enabled in GearGRI's config) */
var StaticMeshComponent EventHatComp;

cpptext
{
	// Networking
	INT* GetOptimizedRepList( BYTE* InDefault, FPropertyRetirement* Retire, INT* Ptr, UPackageMap* Map, UActorChannel* Channel );

	// pathobstacle interface
	/**
	 * this function should populate out_polyshape with a list of verts which describe this object's
	 * convex bounding shape
	 * (verts should be clockwise wound)
	 * @param out_PolyShape - output array which holds the vertex buffer for this obstacle's bounding polyshape
	 * @return TRUE if this object should block things right now (FALSE means this obstacle shouldn't affect the mesh)
	 */
	virtual UBOOL GetBoundingShape(TArray<FVector>& out_PolyShape)
	{
		#define BUFFER 10.0f
		if( CylinderComponent == NULL )
		{
			debugf(TEXT("%s cylinder component is NULL? Bailing from GetBoundingShape()"),*GetName());
			return FALSE;
		}
		out_PolyShape.AddItem(Location + FVector(CylinderComponent->CollisionRadius+BUFFER,CylinderComponent->CollisionRadius+BUFFER,0.f));
		out_PolyShape.AddItem(Location + FVector(-(CylinderComponent->CollisionRadius+BUFFER),CylinderComponent->CollisionRadius+BUFFER,0.f));
		out_PolyShape.AddItem(Location + FVector(-(CylinderComponent->CollisionRadius+BUFFER),-(CylinderComponent->CollisionRadius+BUFFER),0.f));
		out_PolyShape.AddItem(Location + FVector(CylinderComponent->CollisionRadius+BUFFER,-(CylinderComponent->CollisionRadius+BUFFER),0.f));
		return TRUE;
	}

		/**
	 * when TRUE polys internal to this obstacle will be preserved, but still split. (useful for things like cost volumes that
	 * need to adjust cost but not completely destroy parts of the mesh
	 * @return TRUE if polys should be preserved internal to this obstacle
	 */
	virtual UBOOL PreserveInternalPolys() { return TRUE; }

	/**
	 * This function is called when an edge is going to be added connecting a polygon internal to this obstacle to another polygon which is not
	 * Default behavior just a normal edge, override to add special costs or behavior (e.g. link a pathobject to the obstacle)
	 * @param Status - current status of edges (e.g. what still needs adding)
	 * @param inV1 - vertex location of first vert in the edge
	 * @param inV2 - vertex location of second vert in the edge
	 * @param ConnectedPolys - the polys this edge links
	 * @param bEdgesNeedToBeDynamic - whether or not added edges need to be dynamic (e.g. we're adding edges between meshes)
	 * @param PolyAssocatedWithThisPO - the index into the connected polys array parmaeter which tells us which poly from that array is associated with this path object
	 * @(optional) param SupportedEdgeWidth - width of unit that this edge supports, defaults to -1.0f meaning the length of the edge itself will be used
	 * @(optional) param EdgeGroupID - ID of the edgegroup this edge is a part of (defaults to no group)
	 * @return returns an enum describing what just happened (what actions did we take) - used to determien what accompanying actions need to be taken
	 *         by other obstacles and calling code
	 */
	virtual EEdgeHandlingStatus AddObstacleEdge( EEdgeHandlingStatus Status, const FVector& inV1, const FVector& inV2, TArray<FNavMeshPolyBase*>& ConnectedPolys, UBOOL bEdgesNeedToBeDynamic, INT PolyAssocatedWithThisPO, FLOAT SupportedEdgeWidth=-1.0f, BYTE EdgeGroupID=MAXBYTE)
	{
		return AddObstacleEdgeForObstacle(Status,inV1,inV2,ConnectedPolys,bEdgesNeedToBeDynamic,PolyAssocatedWithThisPO,this,SupportedEdgeWidth,EdgeGroupID);
	}

	virtual void BeginDestroy()
	{
		Super::BeginDestroy();
		UnregisterNavmeshObstacle();
	}

	/**
	 *  Called from edges linked to this PO
	 *  @param Interface     - the navhandle interface of the entity pathing
	 *  @param PreviousPoint - the previous point in the path search (e.g. the point along the predecessor edge)
	 *  @param out_PathEdgePoint - the point we used along this edge to determine the cost
	 *  @param Edge - the edge linked to this PO which needs to compute cost
	 *  @return     - the cost for traversing this edge
	 */
	virtual INT CostFor( const FNavMeshPathParams& PathParams, const FVector& PreviousPoint, FVector& out_PathEdgePoint, FNavMeshPathObjectEdge* Edge, FNavMeshPolyBase* SourcePoly )
	{
		AGearAI* GAI = Cast<AGearAI>(PathParams.Interface->GetUObjectInterfaceInterface_NavigationHandle());
		if( GAI != NULL && GAI->Pawn != this )
		{
			// if it's someone else, return a super expensive cost so they go around unless there is no other path
			return 5000;
		}

		return Edge->FNavMeshEdgeBase::CostFor(PathParams, PreviousPoint, out_PathEdgePoint, SourcePoly);
	}
}

native final function RegisterNavMeshObstacle();
native final function UnregisterNavmeshObstacle();

replication
{
	if( Role == ROLE_Authority )
		AttachmentClasses, bIsAttachmentShotOff, ReplicatedIdleBreakInfo, bDisableIdleBreaks, AwardEarned, AimLocation;
}

/** replicated event */
simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
	case 'ReplicatedIdleBreakInfo':
		PlayIdleBreakAnimation(ReplicatedIdleBreakInfo.Index);
		break;
	case 'AttachmentClasses':
		HandleAttachmentClassesChange();
		break;
	case 'bIsAttachmentShotOff':
		HandleAttachmentShotOffChange();
		break;
	case 'AimLocation':
		HandleAimLocationUpdatedRemotely();
		break;
	}

	Super.ReplicatedEvent( VarName );
}


simulated event PostBeginPlay()
{
	local GearGRI GRI;

	Super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		SetTimer(RandRange(IdleBreakFreq.X, IdleBreakFreq.Y), false, nameof(ShouldPlayIdleBreakAnim));
	}

	// apply event hat if specified in config file
	GRI = GearGRI(WorldInfo.GRI);
	if ( GRI != None && GRI.EventHatIndex != INDEX_NONE && (GRI.IsMultiplayerGame() || ClassIsChildOf(GRI.GameClass, class'GearGameSP_Arcade')) &&
		Mesh.GetSocketByName(GRI.EventHats[GRI.EventHatIndex].AttachSocket) != None )
	{
		EventHatComp = new(self) class'StaticMeshComponent';
		EventHatComp.SetActorCollision(false, false, false);
		EventHatComp.SetBlockRigidBody(false);
		EventHatComp.SetStaticMesh(GRI.EventHats[GRI.EventHatIndex].Mesh);
		EventHatComp.bAllowAmbientOcclusion = false;
		EventHatComp.SetShadowParent(Mesh);
		EventHatComp.CastShadow = Mesh.CastShadow;
		EventHatComp.SetLightEnvironment(LightEnvironment);
		Mesh.AttachComponentToSocket(EventHatComp, GRI.EventHats[GRI.EventHatIndex].AttachSocket);
		// some event hats require special scaling that SetHeadScale() will apply
		SetHeadScale(1.0);
	}
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local SkelControlBase SkelControl;

	Super.PostInitAnimTree(SkelComp);

	// Enable corrective skel controls for females.
	if( bIsFemale && SkelComp == Mesh )
	{
		SkelControl = SkelComp.FindSkelControl('L_Arm_Correction_Female');
		if( SkelControl != None )
		{
			SkelControl.SetSkelControlActive(TRUE);
		}

		SkelControl = SkelComp.FindSkelControl('R_Arm_Correction_Female');
		if( SkelControl != None )
		{
			SkelControl.SetSkelControlActive(TRUE);
		}
	}
}

simulated event Destroyed()
{
	if (DBNO_POI != None)
	{
		DBNO_POI.Destroy();
	}

	Super.Destroyed();
}

simulated function SetHeadScale(float NewScale)
{
	local GearGRI GRI;
	local SkelControlSingleBone HeadControl;

	Super.SetHeadScale(NewScale);

	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None && GRI.EventHatIndex != INDEX_NONE && GRI.EventHats[GRI.EventHatIndex].HeadScale != 1.0)
	{
		HeadControl = SkelControlSingleBone(Mesh.FindSkelControl('HeadScaler'));
		if (HeadControl != None)
		{
			HeadControl.SetSkelControlStrength(1.0, 0.0);
			HeadControl.BoneScale = NewScale * GRI.EventHats[GRI.EventHatIndex].HeadScale;
		}
	}
}

simulated function RemoveTaccomMesh()
{
	local int Iter;

	Super.RemoveTaccomMesh();

	for (Iter = 0; Iter < NumAttachments; Iter++)
	{
		if (TaccomAttachmentMeshes[Iter] != None)
		{
			TaccomAttachmentMeshes[Iter].SetHidden(true);
			Mesh.DetachComponent(TaccomAttachmentMeshes[Iter]);
			TaccomAttachmentMeshes[Iter] = None;
		}
	}
}

/**
 * Overridden to handle GearPawn specifics.
 * @NOTE - we don't currently support the gameinfo preventing death (through a mutator etc),
 * so if that behavior is needed this code will have to be refactored.
 */
function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local Vehicle_RatTruck_Base VRTB;
	// derp
	VRTB = Vehicle_RatTruck_Base(Base);
	if( VRTB != none)
	{
		VRTB.KickPawn(self);
	}

	return Super.Died(Killer,DamageType,HitLocation);
}

/**
 * Responsible for playing any death effects, animations, etc.
 * Must turn off particle effects
 * Must hide and remove the taccom meshes when the player dies
 *
 * @param	DamageType - type of damage responsible for this pawn's death
 * @param	HitLoc - location of the final shot
 */
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local int Iter;

	for (Iter = 0; Iter < ArrayCount(AttachmentParticleEffects); Iter++)
	{
		TurnOffAttachmentParticleEffects(EAttachmentType(Iter));
	}

	Super.PlayDying( DamageType, HitLoc );
}


// if we're COG AI, and this is SP always DBNO
function bool ShouldForceDBNO(class<GearDamageType> GearDmgType, Pawn InstigatedBy, vector HitLocation )
{
	local GearPRI PRI;

	if ( bCanRechargeHealth && GetTeamNum() == TEAM_COG && !IsHumanControlled() && !WorldInfo.GRI.IsMultiplayerGame() &&
		!GearDmgType.static.IsScriptedDamageType() )
	{
		return true;
	}
	// leader in Guardian always goes DBNO first
	PRI = GearPRI(PlayerReplicationInfo);
	if (PRI != None && PRI.bIsLeader && WorldInfo.GRI.IsMultiplayerGame())
	{
		return true;
	}
	// check for Siege
	if (bForceDBNOInSiege && GearGameSiege_Base(WorldInfo.Game) != None && GearDmgType != class'GDT_FragTag' && GearDmgType != class'GDT_InkTag')
	{
		return true;
	}
	return Super.ShouldForceDBNO(GearDmgType,InstigatedBy,HitLocation);
}

// we want to DBNO when we have a kantus around
function bool WantsToDBNO(Pawn InInstigator, vector HitLocation, TraceHitInfo HitInfo)
{
	local GearAI_Kantus Member;
	// if we support DBNO, and we're locust
	if(!IsHumanControlled() && GetTeamNum() == TEAM_LOCUST)
	{
		// check to see if there is a Kantus in our squad
		foreach GearAI(Controller).Squad.AllMembers(class'GearAI_Kantus', Member)
		{
			// if we ARE the kantus, don't treat it differently
			if(Member == Controller)
			{
				return Super.WantsToDBNO(Instigator,HitLocation, HitInfo);
			}
			// there was a kantus in our squad, so we should try to dbno
			return TRUE;
		}
	}

	return Super.WantsToDBNO(Instigator,HitLocation, HitInfo);
}


simulated function bool CanBeCurbStomped()
{
	return (!bTearOff && (IsDBNO() || IsDoingAStumbleGoDown()) && !IsSpecialMeleeVictim() && !IsInCover());
}

/**
 * Handles shooting off attachments
 */
function DoDamageEffects(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, const out TraceHitInfo HitInfo)
{
	local vector ApplyImpulse;
	local EAttachmentType TypeToShootOff;

	TypeToShootOff = eATTACHTYPE_MAX;

	// check for which attachment, if any, will potentially get shot off
	if( bLastHitWasHeadShot )
	{
		TypeToShootOff = eATTACHTYPE_Helmet;
	}
	else if ( MatchNameArray( HitInfo.BoneName, LeftShoulderBones ) )
	{
		TypeToShootOff = eATTACHTYPE_ShoulderLeft;
	}
	else if ( MatchNameArray( HitInfo.BoneName, RightShoulderBones ) )
	{
		TypeToShootOff = eATTACHTYPE_ShoulderRight;
	}

	//If something is potentially getting shot off..
	if (TypeToShootOff != eATTACHTYPE_MAX)
	{
		//Do we even have it attached in the first place?
		if (AttachmentClasses[TypeToShootOff] != None
			&& AttachmentClasses[TypeToShootOff].default.bCanBeShotOff
			&& !GetIsAttachmentShotOff(TypeToShootOff, bIsAttachmentShotOff) )
		{
			//We do, so lets roll some dice!
			if( class<GearDamageType>(DamageType) == None || FRand() < class<GearDamageType>(DamageType).default.AttachmentRemovalChance )
			{
				//Success! Shoot it off!
				ApplyImpulse = Momentum * DamageType.default.KDamageImpulse + VSize(Momentum) * Vect(0, 0, 1);
				ShootOffAttachment(TypeToShootOff, ApplyImpulse, DamageType, FALSE);
			}
		}
	}

	Super.DoDamageEffects(Damage,InstigatedBy,HitLocation,DamageType,Momentum,HitInfo);
}

simulated function UpdatePawnLightEnvironment(LightEnvironmentComponent NewComponent)
{
	local int Iter;
	Super.UpdatePawnLightEnvironment(NewComponent);

	for (Iter = 0; Iter < ArrayCount(AttachmentMeshes); Iter++)
	{
		if( AttachmentMeshes[Iter] != None )
		{
			AttachmentMeshes[Iter].SetLightEnvironment(NewComponent);
		}
	}
}

/** Spawn repulsor to make npcs run away from my location */
simulated function CauseCrowdPanic()
{
	if ( !WorldInfo.bHaveActiveCrowd )
	{
		// FIXME - bHaveActiveCrowd is set when an agent is spawned - might be worth also checking if any current crowd agents active if bHaveActiveCrowd=true
		return;
	}
	if(CrowdPanicRepulsor == None)
	{
		CrowdPanicRepulsor = Spawn(class'GearCrowdPanicRepulsor', self,,Location,Rotation,,TRUE);
		CrowdPanicRepulsor.SetBase(self);
		CrowdPanicRepulsor.CausePanic();
	}
	else
	{
		CrowdPanicRepulsor.SetLocation(Location);
		CrowdPanicRepulsor.CausePanic();
	}

	// Panic will subside after some time
	CrowdPanicRepulsor.LifeSpan = 10.0;
}

/** Stop crowd from running away */
simulated function ClearCrowdPanic()
{
	if( CrowdPanicRepulsor != none )
	{
		CrowdPanicRepulsor.Destroy();
		CrowdPanicRepulsor = None;
	}
}

/**
 * This will remove the specified attachment off of the pawn and spawn the attached object object to throw on the floor
 * This is a quick placeholder for the real spawn which we might want to make it not so "jerky pop into view"
 *
 *	@param AttachmentType - The type of attachment we are shooting off
 *	@param ApplyImpulse - The force vector to throw the helmet on the floor with
 *	@param DamageType - The type of damage that caused the helmet to be removed
 *	@param bForced is meant to be a hint to the subclass saying:  Hey! They should be forced.  And up to subclass to obey or not.  (c.f. Theron)
 *           It is also used for client side replication, to let the client know: Yes, it says it was already shot off...but NOT FOR YOU YET! So do it!
 **/
simulated function ShootOffAttachment( EAttachmentType AttachmentType, Vector ApplyImpulse, class<DamageType> DamageType, bool bForced )
{
	local vector SpawnLoc;
	local rotator SpawnRot;
	local ItemSpawnable SpawnedAttachment;
	local ItemSpawnable_Skel SpawnedSkeletalAttachment;
	local Name SocketName;

	//Need to have a class for this attachment
	if ( AttachmentClasses[AttachmentType] != None )
	{
		//If this attachment is on the 'do not shoot off list' or if it is already shot off, then we do nothing. NOTHING.
		//Also do nothing if it is already shot off...unless we are forced to.
		if (AttachmentsThatCannotBeShotOff.Find(AttachmentType) != INDEX_NONE ||
				(!bForced && GetIsAttachmentShotOff(AttachmentType, bIsAttachmentShotOff) ) )
		{
			return;
		}
		//If this is the server, then flip the shot off bit to tell the client to remove it.
		//If it's the client, then the server has already told us that it was shot off (or a clientside function is forcing us to remove it).
		if (Role == ROLE_Authority)
		{
			SetIsAttachmentShotOff(AttachmentType, bIsAttachmentShotOff, True);
		}

		if( AttachmentMeshes[AttachmentType] != None )
		{
			SocketName = DetermineSocketName(AttachmentType, AttachmentClasses[AttachmentType].default.SpawnableData);

			Mesh.GetSocketWorldLocationAndRotation( SocketName, SpawnLoc, SpawnRot );

			if( AttachmentClasses[AttachmentType].default.SpawnableData.TheMesh != None )
			{
				SpawnedAttachment = Spawn( AttachmentClasses[AttachmentType],,, SpawnLoc, SpawnRot,, TRUE );
				SpawnedAttachment.StaticMeshComponent.SetStaticMesh( AttachmentClasses[AttachmentType].default.SpawnableData.TheMesh );
				if (AttachmentClasses[AttachmentType].default.SpawnableData.TheMaterial != None)
				{
					SpawnedAttachment.StaticMeshComponent.SetMaterial(0, AttachmentClasses[AttachmentType].default.SpawnableData.TheMaterial);
				}
				SpawnedAttachment.StaticMeshComponent.SetLightEnvironment(SpawnedAttachment.LightEnvironment);
				SpawnedAttachment.StaticMeshComponent.SetScale( AttachmentClasses[AttachmentType].default.SpawnableData.ItemScale);
				SpawnedAttachment.CollisionComponent.AddImpulse( ApplyImpulse * 1.2, vect(0,0,100) );
				SpawnedAttachment.CollisionComponent.SetRBAngularVelocity( vect(0,100,300), TRUE );
				SpawnedAttachment.TurnCollisionOff();
				SpawnedAttachment.PlayShotOffSound();
				SpawnedAttachment.SetTimer( 0.100f, FALSE, nameof(SpawnedAttachment.TurnCollisionOn) ); // to stop inter penetrating and then OOE as physics corrects and shoots it off
			}
			//It's a skeletal mesh instead
			else if( AttachmentClasses[AttachmentType].default.SpawnableData.TheSkelMesh != None )
			{
				SpawnedSkeletalAttachment = Spawn(class'ItemSpawnable_Skel',,, SpawnLoc, SpawnRot,, TRUE );
				SpawnedSkeletalAttachment.SkeletalMeshComponent.SetSkeletalMesh( AttachmentClasses[AttachmentType].default.SpawnableData.TheSkelMesh );
				if (AttachmentClasses[AttachmentType].default.SpawnableData.TheMaterial != None)
				{
					SpawnedSkeletalAttachment.SkeletalMeshComponent.SetMaterial(0, AttachmentClasses[AttachmentType].default.SpawnableData.TheMaterial);
				}
				SpawnedSkeletalAttachment.SkeletalMeshComponent.SetScale( AttachmentClasses[AttachmentType].default.SpawnableData.ItemScale );
				SpawnedSkeletalAttachment.SkeletalMeshComponent.SetPhysicsAsset( AttachmentClasses[AttachmentType].default.SpawnableData.ThePhysAsset );
				SpawnedSkeletalAttachment.SkeletalMeshComponent.SetHasPhysicsAssetInstance( TRUE );
				SpawnedSkeletalAttachment.SkeletalMeshComponent.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);
				SpawnedSkeletalAttachment.SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_Pawn, TRUE);
				SpawnedSkeletalAttachment.SkeletalMeshComponent.SetLightEnvironment(SpawnedSkeletalAttachment.LightEnvironment);
				SpawnedSkeletalAttachment.CollisionComponent.AddImpulse( ApplyImpulse * 1.2, vect(0,0,100) );
				SpawnedSkeletalAttachment.CollisionComponent.SetRBAngularVelocity( vect(0,100,300), TRUE );
				SpawnedSkeletalAttachment.TurnCollisionOff();
				SpawnedSkeletalAttachment.PlayShotOffSound();
				SpawnedSkeletalAttachment.SetTimer( 0.100f, FALSE, nameof(SpawnedSkeletalAttachment.TurnCollisionOn) ); // to stop inter penetrating and then OOE as physics corrects and shoots it off
			}

		}
	}
	RemoveAttachmentMeshes(AttachmentType);
}

/** Turn off the particle effects for a certain attachment
 *	@param AttachmentType - The attachment to turn off effects on
 */
simulated function TurnOffAttachmentParticleEffects(EAttachmentType AttachmentType)
{
	if( AttachmentParticleEffects[AttachmentType] != None )
	{
		AttachmentParticleEffects[AttachmentType].DeactivateSystem();
		Mesh.DetachComponent( AttachmentParticleEffects[AttachmentType] );
		AttachmentParticleEffects[AttachmentType] = None;
	}
}

simulated function bool HasHelmetOn()
{
	//`log( "HasHelmetOn(): " $ AttachmentClasses[eATTACHTYPE_Helmet] != None @ AttachmentClasses[eATTACHTYPE_Helmet] @ !GearGRI(WorldInfo.GRI).IsMultiPlayerGame() );
	//ScriptTrace();

	return AttachmentClasses[eATTACHTYPE_Helmet] != None
		&& AttachmentClasses[eATTACHTYPE_Helmet] != class'Item_Helmet_None'
		&& ClassIsChildOf(AttachmentClasses[eATTACHTYPE_Helmet], class'Item_HelmetBase')
		&& !GetIsAttachmentShotOff(eATTACHTYPE_Helmet, bIsAttachmentShotOff)
		&& !GearGRI(WorldInfo.GRI).IsMultiPlayerGame(); // if it is a MP game then helmets don't count
}

/** Function to determine the name of the socket a particular attachment should be attached to
 *	@param AttachmentType - The attachment
 *	@param ItemDatum - The instance of the item to be attached
 *	@return The name of the socket
 */
simulated function name DetermineSocketName(EAttachmentType AttachmentType, const out SpawnableItemDatum ItemDatum)
{
	local name SocketName;

	// when we say: "head" we really mean the HeadSocketName as some guys have completely different notions/names for the socket that represents the "head"
	if( ItemDatum.AttachSocketName == 'head' )
	{
		SocketName = HeadSocketName;
	}
	else
	{
		SocketName = ItemDatum.AttachSocketName;
	}

	//For shoulders, the socket name changes based on which of the shoulder attachment slots it is in
	if (AttachmentType == eATTACHTYPE_ShoulderLeft)
	{
		SocketName = Name(SocketName$"left");
	}
	else if (AttachmentType == eATTACHTYPE_ShoulderRight)
	{
		SocketName = Name(SocketName$"right");
	}

	return SocketName;
}

/** Removes all meshes currently in place for the specified attachment
 *	@param AttachmentType - the specified attachment
 */
simulated function RemoveAttachmentMeshes(EAttachmentType AttachmentType)
{
	if( Mesh != None && AttachmentMeshes[AttachmentType] != None )
	{
		AttachmentMeshes[AttachmentType].SetHidden(TRUE);
		Mesh.DetachComponent(AttachmentMeshes[AttachmentType]);
		if (StaticMeshComponent(AttachmentMeshes[AttachmentType]) != None)
		{
			StaticMeshComponent(AttachmentMeshes[AttachmentType]).SetStaticMesh( None );
		}
		else if (SkeletalMeshComponent(AttachmentMeshes[AttachmentType]) != None)
		{
			SkeletalMeshComponent(AttachmentMeshes[AttachmentType]).SetSkeletalMesh( None );
			SkeletalMeshComponent(AttachmentMeshes[AttachmentType]).SetPhysicsAsset( None );
		}
		AttachmentMeshes[AttachmentType] = None;
		AttachmentMaterials[AttachmentType] = None;
		TurnOffAttachmentParticleEffects(AttachmentType);

		//If there is a taccom attachment mesh, remove it also
		if ( TaccomAttachmentMeshes[AttachmentType] != none)
		{
			TaccomAttachmentMeshes[AttachmentType].SetHidden(TRUE);
			Mesh.DetachComponent(TaccomAttachmentMeshes[AttachmentType]);
			if (StaticMeshComponent(TaccomAttachmentMeshes[AttachmentType]) != None)
			{
				StaticMeshComponent(TaccomAttachmentMeshes[AttachmentType]).SetStaticMesh( None );
			}
			else if (SkeletalMeshComponent(TaccomAttachmentMeshes[AttachmentType]) != None)
			{
				SkeletalMeshComponent(TaccomAttachmentMeshes[AttachmentType]).SetSkeletalMesh( None );
				SkeletalMeshComponent(TaccomAttachmentMeshes[AttachmentType]).SetPhysicsAsset( None );
			}
			TaccomAttachmentMeshes[AttachmentType] = None;
		}
	}
}

/** Calls SetupAttachment on all attachments */
function SetupAllAttachments()
{
	local int Iter;
	local class<ItemSpawnable> TempClass;

	for (Iter = 0; Iter < Attachments.Length; Iter++)
	{
		if ( Attachments[Iter].AttachmentType != None && Attachments[Iter].DesiredSlot != eATTACHTYPE_MAX )
		{
			TempClass = Attachments[Iter].AttachmentType.static.GetSpawnableItemClass(Self, Attachments[Iter].DesiredSlot );
			if (TempClass != None)
			{
				AttachmentClasses[Attachments[Iter].DesiredSlot] = TempClass;
			}
		}
	}

	for (Iter = 0; Iter < ArrayCount(AttachmentClasses); Iter++)
	{
		SetupAttachment(EAttachmentType(Iter));
	}
}

/* Override possessed by to construct attachments, now that we know what team we are on
 * (Which is important for taccom meshes)
 */
function PossessedBy(Controller C, bool bVehicleTransition)
{
	super.PossessedBy(C,bVehicleTransition);
	if( Role == ROLE_Authority )
	{
		SetupAllAttachments();
	}
}

/** Sets up the taccom mesh for the specified attachment
 *  @param AttachmentType - the attachment
 *  @param ItemDatum - The item to setup for it
 */
simulated function SetupAttachmentTaccom(EAttachmentType AttachmentType, const out SpawnableItemDatum ItemDatum)
{
	local GearGRI GRI;
	local int MaterialIndex;
	local MaterialInstanceConstant MIC;

	GRI = GearGRI(WorldInfo.GRI);

	if ( GRI != None && GRI.GameClass != None && class<GearGame>(GRI.GameClass).default.bShouldDisplayAlliesViaTaccom &&
		GRI.AddTaccomPlayer(self, true) )
	{
		//It has a static mesh
		if( ItemDatum.TheMesh != None )
		{
			TaccomAttachmentMeshes[AttachmentType] = new(self) class'Item_Helmet_StaticMeshComponent';
			StaticMeshComponent(TaccomAttachmentMeshes[AttachmentType]).SetStaticMesh( ItemDatum.TheMesh );
		}
		//It's a skeletal mesh instead
		else if( ItemDatum.TheSkelMesh != None )
		{
			TaccomAttachmentMeshes[AttachmentType] = new(self) class'Item_Helmet_SkeletalMeshComponent';
			SkeletalMeshComponent(TaccomAttachmentMeshes[AttachmentType]).SetSkeletalMesh( ItemDatum.TheSkelMesh );
			SkeletalMeshComponent(TaccomAttachmentMeshes[AttachmentType]).SetPhysicsAsset( ItemDatum.ThePhysAsset );
		}
		if (TaccomAttachmentMeshes[AttachmentType] != none)
		{
			TaccomAttachmentMeshes[AttachmentType].SetScale( ItemDatum.ItemScale );

			// need to possibly adjust the location
			TaccomAttachmentMeshes[AttachmentType].SetTranslation( ItemDatum.Translation );
			TaccomAttachmentMeshes[AttachmentType].SetRotation( ItemDatum.Rotation );

			// attach the mesh to the body
			TaccomAttachmentMeshes[AttachmentType].CastShadow = false;
			TaccomAttachmentMeshes[AttachmentType].SetHidden(FALSE);
			TaccomAttachmentMeshes[AttachmentType].SetDepthPriorityGroup(SDPG_Foreground);
			Mesh.AttachComponentToSocket(TaccomAttachmentMeshes[AttachmentType], DetermineSocketName(AttachmentType, ItemDatum));

			//If it was a skeletal mesh, then it has a physics asset as well, which we must turn on
			//This need to comes after the AttachComponent so component is in right place.
			if (SkeletalMeshComponent(TaccomAttachmentMeshes[AttachmentType]) != None)
			{
				SkeletalMeshComponent(TaccomAttachmentMeshes[AttachmentType]).SetHasPhysicsAssetInstance( TRUE );
			}

			for (MaterialIndex = 0; MaterialIndex < TaccomAttachmentMeshes[AttachmentType].GetNumElements(); MaterialIndex++)
			{
				// use runtime material if the attachment matches our mesh's default material
				if (TaccomAttachmentMeshes[AttachmentType].GetMaterial(MaterialIndex) == default.Mesh.GetMaterial(MaterialIndex))
				{
					MIC = new(TaccomMesh) class'MaterialInstanceConstant';
					MIC.SetParent(Mesh.GetMaterial(MaterialIndex));
					TaccomAttachmentMeshes[AttachmentType].SetMaterial(MaterialIndex, MIC);
				}
				else
				{
					MIC = TaccomAttachmentMeshes[AttachmentType].CreateAndSetMaterialInstanceConstant(MaterialIndex);
				}
				MIC.SetScalarParameterValue('Taccom', 1.0);
			}
		}
	}
}

/** Sets up the specified attachment, which includes enabling meshes, particle effects, etc
 *	@param AttachmentType - the attachment to be set up
 */
simulated function SetupAttachment(EAttachmentType AttachmentType)
{
	local Name SocketName;

	if ( (Mesh != None) )
	{
		if (AttachmentClasses[AttachmentType] == None)
		{
			AttachmentClasses[AttachmentType] = class'ItemSpawnable';
		}

		//If the result is NOT the same as what we have, then this is a random chooser, and we should not have this!
		//It should have been dealt with in SetupAllAttachments on the server!
		if ( AttachmentClasses[AttachmentType].static.IsRandom() )
		{
			`log("Random chooser still in place in GearPawn_Infantry.SetupAttachment! - This should not be happening!");
			return;
		}

		//Remove existing meshes
		RemoveAttachmentMeshes(AttachmentType);

		//If the attachment has a static or skeletal mesh, and it was not already shot off, then we have something to construct here
		if( !GetIsAttachmentShotOff(AttachmentType, bIsAttachmentShotOff)
			&& (( AttachmentClasses[AttachmentType].default.SpawnableData.TheMesh != None ) ||
				( AttachmentClasses[AttachmentType].default.SpawnableData.TheSkelMesh != None )) )
		{
			//It has a static mesh
			if( AttachmentClasses[AttachmentType].default.SpawnableData.TheMesh != None )
			{
				AttachmentMeshes[AttachmentType] = new(self) class'Item_Helmet_StaticMeshComponent';
				StaticMeshComponent(AttachmentMeshes[AttachmentType]).SetStaticMesh( AttachmentClasses[AttachmentType].default.SpawnableData.TheMesh );
			}
			//It's a skeletal mesh instead
			else if( AttachmentClasses[AttachmentType].default.SpawnableData.TheSkelMesh != None )
			{
				AttachmentMeshes[AttachmentType] = new(self) class'Item_Helmet_SkeletalMeshComponent';
				SkeletalMeshComponent(AttachmentMeshes[AttachmentType]).SetSkeletalMesh( AttachmentClasses[AttachmentType].default.SpawnableData.TheSkelMesh );
				SkeletalMeshComponent(AttachmentMeshes[AttachmentType]).SetPhysicsAsset( AttachmentClasses[AttachmentType].default.SpawnableData.ThePhysAsset );
			}

			if (AttachmentClasses[AttachmentType].default.SpawnableData.TheMaterial != None)
			{
				AttachmentMeshes[AttachmentType].SetMaterial(0, AttachmentClasses[AttachmentType].default.SpawnableData.TheMaterial);
			}

			AttachmentMeshes[AttachmentType].SetScale( AttachmentClasses[AttachmentType].default.SpawnableData.ItemScale );

			// need to possibly adjust the location and rotation
			AttachmentMeshes[AttachmentType].SetTranslation( AttachmentClasses[AttachmentType].default.SpawnableData.Translation );
			AttachmentMeshes[AttachmentType].SetRotation( AttachmentClasses[AttachmentType].default.SpawnableData.Rotation );

			// attach the mesh to the body
			AttachmentMeshes[AttachmentType].bAllowAmbientOcclusion = false;
			AttachmentMeshes[AttachmentType].SetShadowParent(Mesh);
			AttachmentMeshes[AttachmentType].CastShadow = Mesh.CastShadow;
			AttachmentMeshes[AttachmentType].SetLightEnvironment(LightEnvironment);
			AttachmentMeshes[AttachmentType].SetHidden(FALSE);
			AttachmentMeshes[AttachmentType].SetActorCollision(FALSE, FALSE, FALSE);

			SocketName = DetermineSocketName(AttachmentType, AttachmentClasses[AttachmentType].default.SpawnableData);

			Mesh.AttachComponentToSocket(AttachmentMeshes[AttachmentType], SocketName);

			//If it was a skeletal mesh, then it has a physics asset as well, which we must turn on
			//This need to comes after the AttachComponent so component is in right place.
			if (SkeletalMeshComponent(AttachmentMeshes[AttachmentType]) != None)
			{
				SkeletalMeshComponent(AttachmentMeshes[AttachmentType]).SetHasPhysicsAssetInstance( TRUE );
			}

			if( AttachmentClasses[AttachmentType].default.SpawnableData.PS_PersistentEffect != none )
			{
				AttachmentParticleEffects[AttachmentType] = new(self)class'ParticleSystemComponent';
				Mesh.AttachComponentToSocket( AttachmentParticleEffects[AttachmentType], SocketName );
				AttachmentParticleEffects[AttachmentType].SetTemplate( AttachmentClasses[AttachmentType].default.SpawnableData.PS_PersistentEffect );
				AttachmentParticleEffects[AttachmentType].ActivateSystem();
			}

			AttachmentMaterials[AttachmentType] = AttachmentMeshes[AttachmentType].CreateAndSetMaterialInstanceConstant(0);

			SetupAttachmentTaccom(AttachmentType, AttachmentClasses[AttachmentType].default.SpawnableData);
		}
	}
}

/** Returns whether or not the attachment has been shot off
 *	@param Attachment - The attachment to check
 *	@param ByteArray - The specific bytearray to check for this attachment in. Expected to be bIsAttachmentShotOff or bIsAttachmentShotOff_Old
 *	@return True if the specified attachment was shot off in the specified array, otherwise False
 */
simulated function bool GetIsAttachmentShotOff(EAttachmentType AttachmentType, byte ByteArray[NumAttachmentBytes])
{
	local int ByteIndex;
	local byte AppropriateByte;

	ByteIndex = AttachmentType/8;
	//If the index is too big for the given byte array, just return false and log it
	if (ByteIndex >= ArrayCount(ByteArray))
	{
		`Log("GetIsAttachmentShotOff was given an Attachment value that was too large for the given ByteArray");
		return False;
	}
	AppropriateByte = ByteArray[ByteIndex];
	//Now repurpose ByteIndex to be the offset into the byte, without using mod because Rob says there are issues with mod
	ByteIndex = (AttachmentType - (8*ByteIndex));
	return (0 != (AppropriateByte & (1<<ByteIndex)) );
}

/** Sets the specified attachment to the specified value
 *	@param Attachment - The attachment to check
 *	@param ByteArray - The specific bytearray to set this attachment in. Expected to be bIsAttachmentShotOff or bIsAttachmentShotOff_Old
 *	@param Value - The value to set the attachment's shot off value to
 */
simulated function SetIsAttachmentShotOff(EAttachmentType AttachmentType, out byte ByteArray[NumAttachmentBytes], bool Value)
{
	local int ByteIndex;
	local int ByteOffset;

	ByteIndex = AttachmentType/8;
	//If the index is too big for the given byte array, just return false and log it
	if (ByteIndex >= ArrayCount(ByteArray))
	{
		`Log("SetIsAttachmentShotOff was given an Attachment value that was too large for the given ByteArray");
	}
	//Do we actually have to do anything?
	else if (GetIsAttachmentShotOff(AttachmentType, ByteArray) != Value)
	{
		// If so, find the right bit in the byte, and use xor to flip it.
		//ByteOffset is the offset into the byte, without using mod because Rob says there are issues with mod
		ByteOffset = (AttachmentType - (8*ByteIndex));
		ByteArray[ByteIndex] = ByteArray[ByteIndex] ^ (1<<ByteOffset);
	}
}

/** Client response to a change in the AttachmentClasses array */
simulated function HandleAttachmentClassesChange()
{
	local int Iter;

	// Check to see which members of the array have changed by comparing against the old copy
	for (Iter = 0; Iter < ArrayCount(AttachmentClasses); Iter++)
	{
		// If something is different, update the copy and set up the attachment that has changed
		if (AttachmentClasses[Iter] != AttachmentClasses_Old[Iter])
		{
			AttachmentClasses_Old[Iter] = AttachmentClasses[Iter];
			SetupAttachment(EAttachmentType(Iter));
		}
	}
}

/** Client response to a change in the bIsAttachmentShotOff array */
simulated function HandleAttachmentShotOffChange()
{
	local int Iter;
	local bool bIsShotOff;
	local vector MomentumVector;
	local class<GearDamageType> GDT;

	// Check to see which members of the array have changed by comparing against the old copy
	for (Iter = 0; Iter < eATTACHTYPE_MAX; Iter++)
	{
		// If something is different, update the copy and check to see if it was actually shot off
		bIsShotOff = GetIsAttachmentShotOff(EAttachmentType(Iter), bIsAttachmentShotOff);
		if ( bIsShotOff != GetIsAttachmentShotOff(EAttachmentType(Iter), bIsAttachmentShotOff_Old) )
		{
			//If it was shot off, then calculate the momentum vector to put on the shot off object and then call the appropriate function
			if (bIsShotOff)
			{
				GDT = class<GearDamageType>(LastTakeHitInfo.DamageType);
				if (GDT == none)
				{
					GDT = class'GearDamageType';
				}
				MomentumVector = LastTakeHitInfo.Momentum * GDT.default.KDamageImpulse + VSize(LastTakeHitInfo.Momentum) * Vect(0, 0, 1);
				ShootOffAttachment(EAttachmentType(Iter), MomentumVector, GDT, true);

			}
			else //Otherwise it was un-shot-off....so re-setup the attachment, which will put the meshes back on!
			{
				SetupAttachment(EAttachmentType(Iter));
			}
			SetIsAttachmentShotOff(EAttachmentType(Iter), bIsAttachmentShotOff_Old, bIsShotOff);
		}
	}
}

/** Heats up the skin by the given amount.  Skin heat constantly diminishes in Tick(). */
simulated function HeatSkin(float HeatIncrement)
{
	local int Iter;

	Super.HeatSkin( HeatIncrement );

	// Heat up all the attachments
	for (Iter = 0; Iter < ArrayCount(AttachmentMeshes); Iter++)
	{
		if (AttachmentMeshes[Iter] != None && AttachmentMaterials[Iter] != None)
		{
			AttachmentMaterials[Iter].SetScalarParameterValue('Heat', CurrentSkinHeat);
		}
	}
	// heat up the weapon if this guy has one
	if (MyGearWeapon != None && MyGearWeapon.MIC_WeaponSkin != None && MyGearWeapon.Mesh.bAttached)
	{
		MyGearWeapon.MIC_WeaponSkin.SetScalarParameterValue('Heat', CurrentSkinHeat);
	}
	// look into getting the weapons on back to light up also
}

/** Char skin to the given absolute char amount [0..1].  Charring does not diminish over time. */
simulated function CharSkin(float CharIncrement)
{
	local int Iter;

	Super.CharSkin( CharIncrement );

	// Heat up all the attachments
	for (Iter = 0; Iter < ArrayCount(AttachmentMeshes); Iter++)
	{
		if (AttachmentMeshes[Iter] != None && AttachmentMaterials[Iter] != None)
		{
			AttachmentMaterials[Iter].SetScalarParameterValue('Burn', CurrentSkinChar);
		}
	}
	// heat up the weapon if this guy has one
	if (MyGearWeapon != None && MyGearWeapon.MIC_WeaponSkin != None && MyGearWeapon.Mesh.bAttached)
	{
		MyGearWeapon.MIC_WeaponSkin.SetScalarParameterValue('Burn', CurrentSkinChar);
	}
	// look into getting the weapons on back to light up also
}


event Landed( vector HitNormal, actor FloorActor )
{
	Super.Landed(HitNormal, FloorActor);
	//PlayFootStepSound(0);
	//PlayFootStepSound(1);
}

simulated function HideMesh()
{
	local int Iter;
	Super.HideMesh();

	for (Iter = 0; Iter < ArrayCount(AttachmentMeshes); Iter++)
	{
		if (AttachmentMeshes[Iter] != None)
		{
			AttachmentMeshes[Iter].SetHidden(True);
		}
	}
}

/** We need to set the HeadSlotStaticMesh2 so we do Super() and then check to see if we have a HeadSlotStaticMesh2 **/
simulated function SetDepthPriorityGroup(ESceneDepthPriorityGroup NewDepthPriorityGroup)
{
	local bool bUseViewOwnerDepthPriorityGroup;
	local int Iter;

	Super.SetDepthPriorityGroup(NewDepthPriorityGroup);

	// If we're a kidnapper or a hostage, ignore DepthPriorityGroup setting
	// As this is creating sorting issues because both actors are not owned by the same viewport.
	// We don't really care because you can't go in cover in this context.
	if (IsAHostage() || IsAKidnapper())
	{
		NewDepthPriorityGroup = SDPG_World;
	}

	if (Mesh != None)
	{
		bUseViewOwnerDepthPriorityGroup = NewDepthPriorityGroup != SDPG_World;

		for (Iter = 0; Iter < ArrayCount(AttachmentMeshes); Iter++)
		{
			if (AttachmentMeshes[Iter] != None)
			{
				AttachmentMeshes[Iter].SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup, NewDepthPriorityGroup);
			}
		}

		if (EventHatComp != None)
		{
			EventHatComp.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup, NewDepthPriorityGroup);
		}
	}
}

simulated function bool PlayNearMissCringe()
{
	local BodyStance	BS_Cringe;

	if( !IsAliveAndWell() || IsAKidnapper() )
	{
		return FALSE;
	}

	// Disable cringe animations for heavy weapons.
	if( MyGearWeapon != None && (MyGearWeapon.WeaponType == WT_Heavy || MyGearWeapon.IsA('GearWeap_HOD')))
	{
		return FALSE;
	}

	// Do not overwrite currently playing animations on full body slot.
	// Have a delay between cringes.
	if( FullBodyNode != None && !FullBodyNode.bIsPlayingCustomAnim && !IsReloadingWeapon() )
	{
		// Do not play if local player is targeting.
		if( !bIsTargeting || !IsLocallyControlled() || !IsPlayerOwned() )
		{
			BS_Cringe.Stance.Length = 1; // Array of struct needs to be pre-sized.
			BS_Cringe.Stance[0].Slot = BS_FullBody;
			BS_Cringe.Stance[0].AnimName = 'ADD_Overlay_AR_Cringe_B';
			BS_Play(BS_Cringe, 1.f, 0.1f, 0.4f);
			return TRUE;
		}
	}

	return FALSE;
}

/** Sets BodyStance information for this Pawn- this allows customization of hit reaction animations**/
simulated function bool SetHitReactionAnimations(out BodyStance BS_HitReaction, Name AnimName)
{
	// If we're playing an animation on those nodes, don't override it.
	if( BodyStanceNodes.Length <= Min(BS_Std_Idle_Lower, BS_Std_Up) ||
		BodyStanceNodes[BS_Std_Idle_Lower] == None ||
		BodyStanceNodes[BS_Std_Idle_Lower].bIsPlayingCustomAnim ||
		BodyStanceNodes[BS_Std_Up] == None ||
		BodyStanceNodes[BS_Std_Up].bIsPlayingCustomAnim )
	{
		return FALSE;
	}

	BS_HitReaction.Stance.Length = 2; // Array of struct needs to be pre-sized.
	BS_HitReaction.Stance[0].Slot = BS_Std_Idle_Lower;
	BS_HitReaction.Stance[0].AnimName = AnimName;
	BS_HitReaction.Stance[1].Slot = BS_Std_Up;
	BS_HitReaction.Stance[1].AnimName = AnimName;

	return TRUE;
}

/** Play Hit Reaction animation */
simulated function bool PlayHitReactionAnimation(ImpactInfo Impact)
{
	local BodyStance	BS_HitReaction;
	local Name			AnimName;

	// We don't have heavy weapon variation of those, so skip.
	if( MyGearWeapon != None && MyGearWeapon.WeaponType == WT_Heavy )
	{
		return FALSE;
	}

	// Don't play hit reaction animations when in cover, we don't have any.
	if( CoverType != CT_None )
	{
		return FALSE;
	}

	// Find an animation to play based on which bone was hit.
	if( MatchNameArray(Impact.HitInfo.BoneName, StomachBones) )
	{
		AnimName = HitReactionStomach;
	}
	else if( MatchNameArray(Impact.HitInfo.BoneName, RightShoulderBones) )
	{
		AnimName = HitReactionRightShoulder;
	}
	else if( MatchNameArray(Impact.HitInfo.BoneName, LeftShoulderBones) )
	{
		AnimName = HitReactionLeftShoulder;
	}

	if( AnimName != '' )
	{
		// If we're playing an animation on those nodes, don't override it.
		if( SetHitReactionAnimations(BS_HitReaction, AnimName) == FALSE )
		{
			return FALSE;
		}

		NextHitReactionAnimTime = WorldInfo.TimeSeconds + RandRange(0.5f, 1.5f);

		return (BS_Play(BS_HitReaction, 0.67f, 0.25f, 0.5f) > 0.f);
	}

	return FALSE;
}

/** TRUE if NameToMatch is contained within NameArray */
simulated final native function bool MatchNameArray(Name NameToMatch, const out Array<Name> NameArray);

/** AnimSets list updated, post process them */
simulated event AnimSetListUpdated()
{
	Super.AnimSetListUpdated();

	SetAnimRotationOnly();
}

/** Sets the animsets for this mesh to be rotation only */
simulated function SetAnimRotationOnly()
{
	local int i;

	// In SP, we want each mesh to use their original height
	for(i=0; i<Mesh.AnimSets.Length; i++)
	{
		Mesh.AnimSets[i].bAnimRotationOnly = TRUE;
	}
}

/** Timer function called to see if an idle break animation should be played */
function ShouldPlayIdleBreakAnim()
{
	local int		i, PickedIndex;
	local bool		bInCombat;
	local FLOAT		LastPlayedTime;
	local GearGRI	GearGRI;

	bInCombat = (`TimeSince(LastShotAtTime) < 5.f) || (IsHumanControlled() && bIsInCombat) || (GearAI(Controller) != None && GearAI(Controller).Enemy != None);
/*	`log(GetFuncName() @ Self @ `showvar(bInCombat)
		@ `showvar(bDisableIdleBreaks)
		@ `showvar(bSwitchingWeapons)
		@ `showvar(bPlayedDeath)
		@ `showvar(IsDoingASpecialMove())
		@ `showvar(IsFiring())
		@ `showvar(IsReloadingWeapon())
		@ `showvar(bIsTargeting)
		@ `showvar(bUsingCommLink)
		@ `showvar(bSpeaking)
		@ `showvar(CoverType == CT_None && !bTargetingNodeIsInIdleChannel)
		@ `showvar(ReplicatedHeadTrackInfo.HeadLookAtActor)
		@ `showvar(LastTimeMoving)
		);
*/
	if( bInCombat
		|| bDisableIdleBreaks
		|| bPlayedDeath
		|| IsDoingASpecialMove()
		|| IsFiring()
		|| IsReloadingWeapon()
		|| bIsTargeting
		|| bUsingCommLink
		|| bSpeaking
		|| (CoverType == CT_None && !bTargetingNodeIsInIdleChannel)
		|| (ReplicatedHeadTrackInfo.HeadLookAtActor != None && ReplicatedHeadTrackInfo.HeadTrackPriority != EHTP_AIFocus)
		// If we're moving faster than walking speed, always skip.
		|| (VSize(Velocity) > DefaultGroundSpeed * WalkingPct)
/*		|| `TimeSince(LastTimeMoving) < 3.0*/ )
	{
		// skip
	}
	else
	{
		PickedIndex = INDEX_NONE;
		LastPlayedTime = 0.f;

		GearGRI = GearGRI(WorldInfo.GRI);
		if( GearGRI.InfantryIdleBreakLastPlayTime.Length < IdleBreakList.Length )
		{
			GearGRI.InfantryIdleBreakLastPlayTime.Length = IdleBreakList.Length;
		}

		for(i=0; i<IdleBreakList.Length; i++)
		{
			// 2nd layer is played on full body slot.
			if( IdleBreakList[i].b2ndLayer && FullBodyNode.bIsPlayingCustomAnim )
			{
				continue;
			}

			// If we're moving don't play non friendly walk idle breaks.
			if( !IdleBreakList[i].bWalkFriendly && `TimeSince(LastTimeMoving) < 3.0)
			{
				continue;
			}

			// Match by character name
			if( IdleBreakList[i].CharacterName != '' )
			{
				// if name not found in class name, then skip.
				if( InStr(String(class), string(IdleBreakList[i].CharacterName),, TRUE) == INDEX_NONE )
				{
					continue;
				}
			}

			// First see if we can even consider this guy
			// 2ndLayer overrides cover setting.
			if( (!IdleBreakList[i].b2ndLayer && IdleBreakList[i].CoverType != CoverType) ||
				// Handle female only idle breaks
				(IdleBreakList[i].bFemale && !bIsFemale) ||
				(IdleBreakList[i].bAIOnly && !IsPlayerOwned()) )
			{
				continue;
			}

			// All weapons types but heavies, or no weapon/hosltered.
			if( IdleBreakList[i].WeaponType == WT_NWAllButHeavy )
			{
				if( MyGearWeapon != None && MyGearWeapon.WeaponType == WT_Heavy )
				{
					continue;
				}
			}
			// All weapons types but heavies
			else if( IdleBreakList[i].WeaponType == WT_AllButHeavy )
			{
				if( MyGearWeapon == None || MyGearWeapon.WeaponType == WT_Heavy || MyGearWeapon.bTemporaryHolster || bSwitchingWeapons )
				{
					continue;
				}
			}
			// Weapon type has to match!
			else if( MyGearWeapon == None || IdleBreakList[i].WeaponType != MyGearWeapon.WeaponType || MyGearWeapon.bTemporaryHolster || bSwitchingWeapons )
			{
				continue;
			}

// 			`log("Testing" @ i @ IdleBreakList[i].AnimName @ GearGRI.InfantryIdleBreakLastPlayTime[i]);

			// If that animation has never played, or didn't play in the last 5 seconds, consider it.
			// We don't want those to be too repetitive.
			if( GearGRI.InfantryIdleBreakLastPlayTime[i] == 0 || `TimeSince(GearGRI.InfantryIdleBreakLastPlayTime[i]) > 5.f )
			{
				// Try to pick the oldest one that has played
				if( PickedIndex == INDEX_NONE ||
					GearGRI.InfantryIdleBreakLastPlayTime[i] == 0 ||
					GearGRI.InfantryIdleBreakLastPlayTime[i] < LastPlayedTime )
				{
					PickedIndex = i;
					LastPlayedTime = GearGRI.InfantryIdleBreakLastPlayTime[i];
				}
			}
		}

		if( PickedIndex != INDEX_NONE )
		{
// 			`log("Picked" @ PickedIndex @ IdleBreakList[PickedIndex].AnimName @ GearGRI.InfantryIdleBreakLastPlayTime[PickedIndex]);
			if( PlayIdleBreakAnimation(byte(PickedIndex)) )
			{
// 				`log("Successfully played!");
				GearGRI.InfantryIdleBreakLastPlayTime[PickedIndex] = WorldInfo.TimeSeconds;
			}
		}
	}

	// If we're dead, stop trying to play idle break animations.
	if( !bPlayedDeath )
	{
		SetTimer( RandRange(IdleBreakFreq.X, IdleBreakFreq.Y), FALSE, nameof(ShouldPlayIdleBreakAnim) );
	}
}


/** To play idle break animations. Check that a given slot is exists in the AnimTree, and is valid to use.
 *  Otherwise penalize the IdleBreak animation by marking it as played. So it is penalized on our next search.
 *  And we don't just keep picking it and fail every time.
 */
simulated final function bool CheckBodyStanceSlot(EBodyStance Slot, INT PickedIndex)
{
	local GearGRI GearGRI;

	if( BodyStanceNodes.Length >= Slot && BodyStanceNodes[Slot] != None )
	{
		return TRUE;
	}

	`log(Self @ GetFuncName() @ "Slot" @ Slot @ "not found!");
	// Slot wasn't found. Mark it as played still, so it's penalized next time we search.
	GearGRI = GearGRI(WorldInfo.GRI);
	GearGRI.InfantryIdleBreakLastPlayTime[PickedIndex] = WorldInfo.TimeSeconds;
	return FALSE;
}

simulated function bool PlayIdleBreakAnimation(byte PickedIndex)
{
	local BodyStance StanceToPlay;

	if( PickedIndex != INDEX_NONE )
	{
		// Play on full body slot
		if( IdleBreakList[PickedIndex].b2ndLayer )
		{
			if( CheckBodyStanceSlot(BS_FullBody, PickedIndex) && !BodyStanceNodes[BS_FullBody].bIsPlayingCustomAnim )
			{
				StanceToPlay.Stance.Length = 1; // Array of struct needs to be pre-sized.
				StanceToPlay.Stance[0].Slot = BS_FullBody;
				StanceToPlay.Stance[0].AnimName = IdleBreakList[PickedIndex].AnimName;
			}
		}
		// Outside of cover idle break
		else if( IdleBreakList[PickedIndex].CoverType == CT_None )
		{
			if(	CheckBodyStanceSlot(BS_Layer_Stand_Idle_Idle, PickedIndex) && !BodyStanceNodes[BS_Layer_Stand_Idle_Idle].bIsPlayingCustomAnim &&
				CheckBodyStanceSlot(BS_Layer_Stand_Walk_Idle, PickedIndex) && !BodyStanceNodes[BS_Layer_Stand_Walk_Idle].bIsPlayingCustomAnim
				)
			{
				StanceToPlay.Stance.Length = 2; // Array of struct needs to be pre-sized.
				StanceToPlay.Stance[0].Slot = BS_Layer_Stand_Idle_Idle;
				StanceToPlay.Stance[0].AnimName = IdleBreakList[PickedIndex].AnimName;
				StanceToPlay.Stance[1].Slot = BS_Layer_Stand_Walk_Idle;
				StanceToPlay.Stance[1].AnimName = IdleBreakList[PickedIndex].AnimName;
			}
		}
		else if( IdleBreakList[PickedIndex].CoverType == CT_MidLevel )
		{
			if( CheckBodyStanceSlot(BS_Layer_MidCov_Ready_Idle, PickedIndex) && !BodyStanceNodes[BS_Layer_MidCov_Ready_Idle].bIsPlayingCustomAnim )
			{
				StanceToPlay.Stance.Length = 1; // Array of struct needs to be pre-sized.
				StanceToPlay.Stance[0].Slot = BS_Layer_MidCov_Ready_Idle;
				StanceToPlay.Stance[0].AnimName = IdleBreakList[PickedIndex].AnimName;
			}
		}
		else if( IdleBreakList[PickedIndex].CoverType == CT_Standing )
		{
			if( CheckBodyStanceSlot(BS_Layer_StdCov_Ready_Idle, PickedIndex) && !BodyStanceNodes[BS_Layer_StdCov_Ready_Idle].bIsPlayingCustomAnim )
			{
				StanceToPlay.Stance.Length = 1; // Array of struct needs to be pre-sized.
				StanceToPlay.Stance[0].Slot = BS_Layer_StdCov_Ready_Idle;
				StanceToPlay.Stance[0].AnimName = IdleBreakList[PickedIndex].AnimName;
			}
		}
	}

	if( StanceToPlay.Stance.Length > 0 )
	{
		BS_LastIdleBreakAnim = StanceToPlay;
		BS_Play(StanceToPlay, 1.f, 1.f, 1.f);

		// If successful, replicate idle break information.
		if( Role == ROLE_Authority )
		{
			bForceNetUpdate = TRUE;
			ReplicatedIdleBreakInfo.Count++;
			ReplicatedIdleBreakInfo.Index = PickedIndex;
		}

		return TRUE;
	}

	return FALSE;
}

/** Stop Idle break animation */
simulated function StopIdleBreakAnim()
{
	if( BS_HasAnyWeight(BS_LastIdleBreakAnim) )
	{
		BS_Stop(BS_LastIdleBreakAnim, 0.33f);
	}
	else
	{
		BS_Stop(BS_LastIdleBreakAnim, 0.f);
	}
}

simulated event ConditionalMove2IdleTransition()
{
	// Stop idle break animation when stopped moving.
	StopIdleBreakAnim();

	Super.ConditionalMove2IdleTransition();
}

/** Is Pawn allowed to Head track his Focus Actor */
native simulated function bool ShouldHeadTrackFocusPoint();

static function MutatePawn(GearPawn Victim)
{
	local GearPawn_Infantry	InfantryPawn;

	Super.MutatePawn(Victim);

	InfantryPawn = GearPawn_Infantry(Victim);
	if( InfantryPawn != None )
	{
		InfantryPawn.AttachmentClasses[eATTACHTYPE_Helmet] = default.AttachmentClasses[eATTACHTYPE_Helmet];
		if( InfantryPawn.AttachmentClasses[eATTACHTYPE_Helmet] != None )
		{
			InfantryPawn.SetupAttachment(eATTACHTYPE_Helmet);
		}
	}
}

exec function ForceShootOffHelmet()
{
	local Vector		HitLocation, HitNormal,  TraceEnd, TraceStart, ApplyImpulse;
	local TraceHitInfo	HitInfo;

	// Play a cringe additive animation.
	TryPlayNearMissCringe();

	// Fake a hit
	TraceStart = Mesh.GetBoneLocation(HeadBoneNames[0]) + Vector(Rotation) * 50.f;
	TraceEnd = TraceStart - Vector(Rotation) * 100.f;
	TraceComponent(HitLocation, HitNormal, AttachmentMeshes[eATTACHTYPE_Helmet], TraceEnd, TraceStart, vect(0,0,0), HitInfo);
	// Force bone name to trigger specific hit reaction animation.
	HitInfo.BoneName = 'b_MF_UpperArm_R';
	PlayTakeHit(10, Self, HitLocation, class'GDT_LocustPistol', VRand(), HitInfo);

	// Drop off helmet
	ApplyImpulse = Normal(VRand() + vect(0,0,2)) * class'GDT_LocustPistol'.default.KDamageImpulse;
	ShootOffAttachment(eATTACHTYPE_Helmet, ApplyImpulse, class'GDT_LocustPistol', TRUE);
}

/** Kismet Hook to force shooting off helmets */
function OnForceShootOffHelmet(SeqAct_ForceShootOffHelmet Action)
{
	ForceShootOffHelmet();
}

exec function PutOnHelmet()
{
	ServerDoSpecialMove(SM_PutOnHelmet);
}

/** Kismet hook to allow for the adding of armor attachments */
function OnAddArmorAttachment(SeqAct_AddArmorAttachment Action)
{
	AttachmentClasses[Action.ArmorSlot] = Action.AttachmentType;
	SetupAttachment(Action.ArmorSlot);
}

/** Kismet hook to allow for the stripping of armor attachments */
function OnRemoveArmorAttachments(SeqAct_RemoveArmorAttachments Action)
{
	AttachmentClasses[Action.ArmorToRemove] = None;
	SetupAttachment(Action.ArmorToRemove);
}

/** Function used to ensure idle breaks are not turned off for the entire game */
function FallbackIdleBreakReEnable()
{
	bDisableIdleBreaks = FALSE;
}

/** Handle action to turn off idle breaks */
function OnToggleIdleBreaks(SeqAct_ToggleIdleBreaks Action)
{
	if (action.InputLinks[0].bHasImpulse)
	{
		bDisableIdleBreaks = FALSE;
		ClearTimer(nameof(FallbackIdleBreakReEnable));
	}
	else if (action.InputLinks[1].bHasImpulse)
	{
		bDisableIdleBreaks = TRUE;
		SetTimer(600.0, FALSE, nameof(FallbackIdleBreakReEnable));
	}
}


simulated function PlayFallDownPhysicsModify()
{
	local int Iter;

	Super.PlayFallDownPhysicsModify();

	for (Iter = 0; Iter < ArrayCount(AttachmentMeshes); Iter++)
	{
		if( SkeletalMeshComponent(AttachmentMeshes[Iter]) != None )
		{
			SkeletalMeshComponent(AttachmentMeshes[Iter]).SetRBChannel(RBCC_Untitled3);
			SkeletalMeshComponent(AttachmentMeshes[Iter]).SetRBCollidesWithChannel(RBCC_Untitled3, TRUE);
			SkeletalMeshComponent(AttachmentMeshes[Iter]).SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
			SkeletalMeshComponent(AttachmentMeshes[Iter]).SetRBCollidesWithChannel(RBCC_DeadPawn, FALSE);
		}
	}
}

simulated function StartPhysicsBodyImpactPhysicsModify()
{
	local int Iter;

	Super.StartPhysicsBodyImpactPhysicsModify();

	for (Iter = 0; Iter < ArrayCount(AttachmentMeshes); Iter++)
	{
		if( SkeletalMeshComponent(AttachmentMeshes[Iter]) != None )
		{
			SkeletalMeshComponent(AttachmentMeshes[Iter]).SetRBChannel(RBCC_Nothing);
			SkeletalMeshComponent(AttachmentMeshes[Iter]).SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
		}
	}
}

simulated function BodyImpactBlendOutNotifyPhysicsModify()
{
	local int Iter;

	Super.BodyImpactBlendOutNotifyPhysicsModify();

	for (Iter = 0; Iter < ArrayCount(AttachmentMeshes); Iter++)
	{
		if( SkeletalMeshComponent(AttachmentMeshes[Iter]) != None )
		{
			SkeletalMeshComponent(AttachmentMeshes[Iter]).SetRBChannel(SkeletalMeshComponent(AttachmentMeshes[Iter]).default.RBChannel);
			SkeletalMeshComponent(AttachmentMeshes[Iter]).SetRBCollidesWithChannel(RBCC_Pawn, SkeletalMeshComponent(AttachmentMeshes[Iter]).default.RBCollideWithChannels.Pawn);
		}
	}
}

simulated function PlayRagDollDeathPhysicsModify()
{
	Super.PlayRagDollDeathPhysicsModify();

	SkelMeshHelmetTurnItAllOff();
}


simulated function PlayDeathPhysicsModify()
{
	Super.PlayDeathPhysicsModify();

	SkelMeshHelmetTurnItAllOff();
}

/** Called to set the aim location
 *  @param NewAimLocation - The new aim location
 */
simulated function SetAimLocation(Vector NewAimLocation)
{
	AimLocation = NewAimLocation;
	bForceNetUpdate = TRUE; // Force replication
	HandleAimLocationUpdated();
}

/** Called when the aim location has changed via replication - don't let the server override you if you were the one who sent it in the first place */
simulated function HandleAimLocationUpdatedRemotely()
{
	if (!IsLocallyControlled())
	{
		HandleAimLocationUpdated();
	}
}

/** Called when the aim location has changed */
simulated function HandleAimLocationUpdated()
{
	local GearWeapon GW;

	GW = GearWeapon(Weapon);
	if (GW != none)
	{
		GW.AimLocationUpdated(AimLocation);
	}
}


simulated function SkelMeshHelmetTurnItAllOff()
{
	if( SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]) != None )
	{
		SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]).SetBlockRigidBody( FALSE );

		// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
		//HeadSlotSkeletalMesh.SetRBChannel(RBCC_DeadPawn);
		SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]).SetRBChannel(RBCC_Nothing);
		SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]).SetRBCollidesWithChannel(RBCC_Untitled3, FALSE);
		SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]).SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
		SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]).SetRBCollidesWithChannel(RBCC_DeadPawn, FALSE);
		SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]).SetRBCollidesWithChannel(RBCC_Default, FALSE);
		SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]).SetRBCollidesWithChannel(RBCC_EffectPhysics, FALSE);
		SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]).SetRBCollidesWithChannel(RBCC_BlockingVolume, FALSE);
		SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]).SetRBCollidesWithChannel(RBCC_FracturedMeshPart, FALSE);
		SkeletalMeshComponent(AttachmentMeshes[eATTACHTYPE_Helmet]).SetRBCollidesWithChannel(RBCC_SoftBody, FALSE);
	}
}

/** Util to try and see if pawn is stuck in */
final native function bool InfantryStuckInWorld();

simulated function Tick(float DeltaTime)
{
	local float Speed;

	Super.Tick(DeltaTime);

	// Handle toning down breathing when in downsights
	if( BreathingAdditiveControl != None )
	{
		// Disable breathing layer for those special moves, because they have a different IK setup, that doesn't allow b_MF_IK_Gun bone to move around.
		if( SpecialMove == SM_Kidnapper || SpecialMove == SM_Hostage || SpecialMove == GSM_DragInjured_Leader || SpecialMove == GSM_DragInjured_Follower )
		{
			if( BreathingAdditiveControl.Child2WeightTarget != 0.0 )
			{
				BreathingAdditiveControl.SetBlendTarget(0.0, 1.0);
			}
		}
		else if( MyGearWeapon != None && MyGearWeapon.bAllowDownsightsStance && bIsTargeting && !IsReloadingWeapon() )
		{
			if( BreathingAdditiveControl.Child2WeightTarget != 0.5 )
			{
				BreathingAdditiveControl.SetBlendTarget(0.5, 2.0);
			}
		}
		else
		{
			if( BreathingAdditiveControl.Child2WeightTarget != 1.0 )
			{
				BreathingAdditiveControl.SetBlendTarget(1.0, 2.0);
			}
		}
	}

	Speed = VSize(Velocity);

	// Turn on Heavy Breathing when running
	if( Speed > WalkingPct * GroundSpeed * 1.1 )
	{
		// Heavy Breathing
		BreathingTypeProperty = FInterpConstantTo(BreathingTypeProperty, 0.0, DeltaTime, 0.2);
	}
	// Turn on Heavy Breathing when running
	else if( Speed > WalkingPct * GroundSpeed * 0.33 )
	{
		// medium high breathing
		BreathingTypeProperty = FInterpConstantTo(BreathingTypeProperty, 0.6, DeltaTime, 0.2);
	}
	else
	{
		// Normal Breathing
		BreathingTypeProperty = FInterpConstantTo(BreathingTypeProperty, 1.0, DeltaTime, 0.1);
	}

	// Handle traversing barbed wire.
	if( bTraversingBarbedWire )
	{
		TickTraversingBarbedWire();
	}

	UpdateNavMeshObstacleForCoverUse();
}

function UpdateNavMeshObstacleForCoverUse()
{
	if( GetTeamNum() != TEAM_COG )
	{
		return;
	}
	// Register obstacle when we're in cover and haven't moved for enough time
	if( VSize2D(Location - LastNavMeshCheckLocation) > 100.f )
	{
		UnregisterNavmeshObstacle();
		LastNavMeshCheckLocation = Location;
		LastNavMeshCheckUpdateTime = WorldInfo.TimeSeconds;
	}


	if( IsInCover() )
	{
		if( !bNavMeshRegistered && `TimeSince(LastNavMeshCheckUpdateTime) > NavMeshObstacleRegistrationTime)
		{
			RegisterNavMeshObstacle();
		}
	}
	else if(bNavMeshRegistered)
	{
		LastNavMeshCheckUpdateTime = WorldInfo.TimeSeconds;
		UnregisterNavmeshObstacle();
	}
}

/** Toggle between one hand and two hand IK */
exec function ToggleHandIK()
{
	bWeaponIsOneHandedToggle = !bWeaponIsOneHandedToggle;
}

/** Handles anything we need to happen to the pawn if the pawn is taken hostage (meatbagged) */
simulated function TakenHostageNotify();

/** Returns TRUE if this Pawn can be chainsaw attacked */
simulated function bool CanBeBayonetAttacked()
{
	return TRUE;
}

/** this is anim notifier for arm breaking */
simulated function ANIMNOTIFY_BreakLeftArm()
{
	local vector BreakLoc;

	// remove from taccom mesh, so that it doesn't stretch
	RemoveTaccomMesh();

	if ( WorldInfo.GRI.ShouldShowGore() && EnableGoreMesh() )
	{
		BreakLoc = Mesh.GetBoneLocation('b_MF_UpperArm_L');
		Mesh.BreakConstraint(vect(0, 0, 1),BreakLoc,'b_MF_UpperArm_L');
	}
}

/** this is anim notifier first trike of hitting head for hammber burst execution*/
/** DEPRECATED - renmove this notifier from the animation - hammer burst execution **/
simulated function ANIMNOTIFY_FirstStrike()
{
	//RemoveAttachmentMeshes(eATTACHTYPE_Helmet);
	//RemoveAttachmentMeshes(eATTACHTYPE_Face);
}

/** this is anim notifier last strike of hitting head for hammber burst execution - break face*/
simulated function ANIMNOTIFY_BreakFace()
{
	// remove from taccom mesh, so that it doesn't stretch
	RemoveTaccomMesh();

	AddGoreHitMask('b_MF_Head', 20.f);

	if ( WorldInfo.GRI.ShouldShowGore() && EnableGoreMesh() )
	{
		// Hide Face bone
		Mesh.HideBoneByName('b_MF_Face', PBO_Term);
		// replace to rigid for Face, otherwise, you'll see stretch
		// You need to replace with parent
		Mesh.AddInstanceVertexWeightBoneParented( 'b_MF_Face', TRUE );

		// Spawn face chunks
		SpawnFaceChunks();
	}
}

/** this is anim notifier last strike of hitting head for hammber burst execution - break face*/
simulated function ANIMNOTIFY_BreakHeadDigger()
{
	// remove from taccom mesh, so that it doesn't stretch
	RemoveTaccomMesh();

	RemoveAttachmentMeshes(eATTACHTYPE_Helmet);
	RemoveAttachmentMeshes(eATTACHTYPE_Face);

	AddGoreHitMask('b_MF_Head', 20.f);

	if ( WorldInfo.GRI.ShouldShowGore() && EnableGoreMesh() )
	{
		// Hide Face bone
		Mesh.HideBoneByName('b_MF_Head', PBO_Term);

		// use animation and just let it roll
		// since it's unfixed
		Mesh.BreakConstraint(vect(0, 0, 0),Mesh.GetBoneLocation('b_MF_Head'),'b_MF_Head');

		// Spawn face chunks
		SpawnFaceChunks();
	}
}

/** this is anim notifier for cleaver execution where hand/head get cut */
simulated function ANIMNOTIFY_BreakHead()
{
	// remove from taccom mesh, so that it doesn't stretch
	RemoveTaccomMesh();

	if ( WorldInfo.GRI.ShouldShowGore() && EnableGoreMesh() )
	{
		// use animation and just let it roll
		// since it's unfixed
		Mesh.BreakConstraint(vect(0, 0, 0),Mesh.GetBoneLocation('b_MF_Head'),'b_MF_Head');
		Mesh.BreakConstraint(vect(0, 0, 0),Mesh.GetBoneLocation('b_MF_Hand_R'),'b_MF_Hand_R');

		// I want to simulate head using physics but animation driven... Only wake up head and set physics weight to 1.
		// Make it start simulating
		Mesh.WakeRigidBody('b_MF_Head');
		// Enable full physics on body
		Mesh.PhysicsWeight = 1.f;
	}
}

/** Spawn Face Chunks - called by hammerburst execution **/
simulated final function SpawnFaceChunks()
{
	local int               HeadIdx, ChunkNb;
	local Vector			HeadLoc;
	local Rotator			HeadRot;
	local matrix            HeadMat;

	// Spawn several physics Head Chunks
	if( HeadChunks.Length > 0 )
	{
		// HeadRot is pointing up.
		HeadIdx = Mesh.MatchRefBone('b_MF_Face');
		HeadMat = Mesh.GetBoneMatrix(HeadIdx);
		HeadLoc = MatrixGetOrigin(HeadMat);
		HeadRot = MatrixGetRotator(HeadMat);

		// Spawn several physics Head Chunks
		for(ChunkNb=0; ChunkNb<8; ChunkNb++)
		{
			// don't spawn the 0 (head) twice
			SpawnAHeadChunk( HeadLoc, HeadRot, HeadChunks[ Max( 1, Rand(HeadChunks.Length)) ] );
		}
	}
}

/** GetPartialBreakInfo : This is used by heavy sniper damage breaks
 *  This only breaks partially depending on where it hits.
 *  Since it's very specific I didn't make it to gore settings
 *  This returns list of break list
 */
simulated function int GetPartialBreakInfo( out array<PartialBreakInfo> BreakList )
{
	local PartialBreakInfo BreakInfo;

	// this check happens from 0-last index
	// if found, it won't search any more
	// so if you put higher bone parent to be earlier index
	// it won't work

	// if it's child of thigh, hide bone of calf
	BreakInfo.BoneNameToChild = 'b_MF_Thigh_L';
	BreakInfo.BoneNameToBreak = 'b_MF_Calf_L';
	BreakInfo.bHideBone = TRUE;

	BreakList[0] = BreakInfo;

	BreakInfo.BoneNameToChild = 'b_MF_Thigh_R';
	BreakInfo.BoneNameToBreak = 'b_MF_Calf_R';
	BreakInfo.bHideBone = TRUE;

	BreakList[1] = BreakInfo;

	// if it's left side of arm, just break spine_03
	BreakInfo.BoneNameToChild = 'b_MF_Clavicle_L';
	BreakInfo.BoneNameToBreak = 'b_MF_Spine_03';
	BreakInfo.bHideBone = TRUE;

	BreakList[2] = BreakInfo;

	// if it's left side of arm, just break spine_03
	BreakInfo.BoneNameToChild = 'b_MF_Clavicle_R';
	BreakInfo.BoneNameToBreak = 'b_MF_Spine_03';
	BreakInfo.bHideBone = FALSE;

	BreakList[3] = BreakInfo;

	// if it hits spine 03, break spine 03
	BreakInfo.BoneNameToChild = 'b_MF_Spine_03';
	BreakInfo.BoneNameToBreak = 'b_MF_Spine_03';
	BreakInfo.bHideBone = TRUE;

	BreakList[4] = BreakInfo;

	return BreakList.Length;
}

/** this is anim notifier first trike of hitting head for hammber burst execution*/
simulated function ANIMNOTIFY_Chainsaw()
{
// 	if ( EnableGoreMesh() )
// 	{
// 		// remove from taccom mesh, so that it doesn't stretch
// 		RemoveTaccomMesh();
//
// 		// use animation and just let it roll
// 		// since it's unfixed
// 		Mesh.BreakConstraint(vect(0, 0, 0),Mesh.GetBoneLocation('b_MF_Spine_03'),'b_MF_Spine_03');
// 	}
}

/** We're sharing a single Slot with other animations (such as melee or weapon reload)
 *  This animation is lower priority. So just make sure it plays when nothing is playing on that slot. */
simulated function TickTraversingBarbedWire()
{
	// If no animation is playing on that slot, then play ours.
	if( BodyStanceNodes.Length > BS_Layer1 && BodyStanceNodes[BS_Layer1] != None && !BodyStanceNodes[BS_Layer1].bIsPlayingCustomAnim )
	{
		BS_Play(BS_TraversingBarbedWire, 1.f, 0.67f,, TRUE,, 'RunWalk');
	}
}

/** Notification when bTraversingBarbedWire flag is updated.
 *  Called on all net modes */
simulated function TraversingBarbedWireUpdated()
{
	// If we're done traversing BarbedWire, interrupt our animation if it was playing.
	if( !bTraversingBarbedWire )
	{
		BS_Stop(BS_TraversingBarbedWire, 0.67f);
	}
}

defaultproperties
{
	BS_TraversingBarbedWire=(Stance=((Slot=BS_Layer1,AnimName="ADD_Walk_FWD_Baricade")))
	LastIdleBreakAnimIndex=INDEX_NONE
// 	IdleBreakFreq=(X=25.f,Y=40.f)
	IdleBreakFreq=(X=5.f,Y=10.f)
	// Rifle pose
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Check_Gun",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Look_Alert",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Look_Alert_B",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Kick_Boots_A",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Kick_Boots_B",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Stretch_B",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Subtle_LookAround_A",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Subtle_LookAround_B",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Subtle_LookAround_C",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Subtle_LookAround_D",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Subtle_Sway_A",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Subtle_Sway_B",CoverType=CT_None,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_sam_AR_Idle_Break_HairFlip",CoverType=CT_None,WeaponType=WT_Normal,CharacterName="sam"))
	IdleBreakList.Add((AnimName="ADD_sam_AR_Idle_WeightShift_A",CoverType=CT_None,WeaponType=WT_Normal,CharacterName="sam"))
	IdleBreakList.Add((AnimName="ADD_sam_AR_Idle_WeightShift_B",CoverType=CT_None,WeaponType=WT_Normal,CharacterName="sam"))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cole_KissArm",CoverType=CT_None,WeaponType=WT_Normal,CharacterName="gus"))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cole_Lifting",CoverType=CT_None,WeaponType=WT_Normal,CharacterName="gus"))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cole_Shuffle",CoverType=CT_None,WeaponType=WT_Normal,CharacterName="gus"))

	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cov_Mid_Check_Gun",CoverType=CT_MidLevel,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cov_Mid_Look_Alert",CoverType=CT_MidLevel,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cov_Mid_Look_Alert_B",CoverType=CT_MidLevel,WeaponType=WT_Normal))

	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cov_Std_Check_Gun",CoverType=CT_Standing,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cov_Std_Look_Alert",CoverType=CT_Standing,WeaponType=WT_Normal))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cov_Std_Look_Alert_B",CoverType=CT_Standing,WeaponType=WT_Normal))

	// Pistol
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Look_Alert",CoverType=CT_None,WeaponType=WT_Holster))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Look_Alert_B",CoverType=CT_None,WeaponType=WT_Holster))

	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cov_Mid_Look_Alert",CoverType=CT_MidLevel,WeaponType=WT_Holster))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cov_Mid_Look_Alert_B",CoverType=CT_MidLevel,WeaponType=WT_Holster))

	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cov_Std_Look_Alert",CoverType=CT_Standing,WeaponType=WT_Holster))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Cov_Std_Look_Alert_B",CoverType=CT_Standing,WeaponType=WT_Holster))

	// Neutral
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Adjust_Armor_A",WeaponType=WT_AllButHeavy))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Stretch_A",WeaponType=WT_AllButHeavy))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Brow_Wipe_A",WeaponType=WT_NWAllButHeavy))
	IdleBreakList.Add((AnimName="ADD_anya_AR_Idle_HairPush",WeaponType=WT_NWAllButHeavy,CharacterName="anya"))

	// On top of existing Layer
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Foot_Shift",b2ndLayer=TRUE,WeaponType=WT_NWAllButHeavy))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Finger_Adjust",b2ndLayer=TRUE,WeaponType=WT_NWAllButHeavy,bWalkFriendly=TRUE))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Head_Look_A",b2ndLayer=TRUE,WeaponType=WT_NWAllButHeavy,bWalkFriendly=TRUE))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Head_Look_B",b2ndLayer=TRUE,WeaponType=WT_NWAllButHeavy,bWalkFriendly=TRUE))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Subtle_LookAround_Walk_A",b2ndLayer=TRUE,WeaponType=WT_NWAllButHeavy,bWalkFriendly=TRUE))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Subtle_LookAround_Walk_B",b2ndLayer=TRUE,WeaponType=WT_NWAllButHeavy,bWalkFriendly=TRUE))
	IdleBreakList.Add((AnimName="ADD_Idle_Break_Subtle_LookAround_Walk_C",b2ndLayer=TRUE,WeaponType=WT_NWAllButHeavy,bWalkFriendly=TRUE))

	// Female
	IdleBreakList.Add((AnimName="ADD_AR_Idle_Break_Check_Gun",bFemale=TRUE,WeaponType=WT_Normal))

	MeleeDamageBoneName="b_MF_Spine_02"
	NeckBoneName="b_MF_Neck"
	LeftFootBoneName="b_MF_Foot_L"
	RightFootBoneName="b_MF_Foot_R"
	LeftKneeBoneName="b_MF_Calf_L"
	RightKneeBoneName="b_MF_Calf_R"
	LeftHandBoneName="b_MF_Hand_L"
	RightHandBoneName="b_MF_Hand_R"
	EyeBoneNameLeft="b_MF_Face_RtEye"
	EyeBoneNameRight="b_MF_Face_LtEye"

	StomachBones=("b_MF_Pelvis","b_MF_Armor_Crotch","b_MF_Spine_01","b_MF_Spine_02","b_MF_Spine_03")
	RightShoulderBones=("b_MF_Clavicle_R","b_MF_Armor_Sho_R","b_MF_UpperArm_R","b_MF_Forearm_R","b_MF_Hand_R")
	LeftShoulderBones=("b_MF_Clavicle_L","b_MF_Armor_Sho_L","b_MF_UpperArm_L","b_MF_Forearm_L","b_MF_Hand_L")
	RightLegBones=("b_MF_Thigh_R","b_MF_Calf_R","b_MF_Foot_R")
	LeftLegBones=("b_MF_Thigh_L","b_MF_Calf_L","b_MF_Foot_L")
	HitReactionStomach="Hit_Stomach"
	HitReactionLeftShoulder="Hit_Shoulder_Left"
	HitReactionRightShoulder="Hit_Shoulder_Right"

	ViewLocationOffset=(X=-50,Y=-25,Z=10)

	AimAttractors(0)=(OuterRadius=64.f,InnerRadius=4.f,BoneName="b_MF_Spine_02")
	AimAttractors(1)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Head")
	AimAttractors(2)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Calf_L")
	AimAttractors(3)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Calf_R")

	// List of BodySetups turned to physics for physical impacts
	PhysicsBodyImpactBoneList=("b_MF_Spine_01","b_MF_Spine_02","b_MF_Spine_03","b_MF_Head","b_MF_Neck","b_MF_Clavicle_L","b_MF_UpperArm_L","b_MF_Forearm_L","b_MF_Hand_L","b_MF_Clavicle_R","b_MF_UpperArm_R","b_MF_Hand_R","b_MF_Forearm_R","b_MF_Armor_Sho_L","b_MF_Armor_Sho_R")

	bPlayDeathAnimations=TRUE
	DeathAnimHighFwd=("ar_death_running_b","ar_death_running_d","ar_death_running_e")
	DeathAnimHighBwd=("ar_death_standing_b","ar_death_standing_c","ar_death_standing_d","ar_death_standing_f")
	DeathAnimStdFwd=("AR_Death_Running_A","ar_death_running_c","ar_death_running_f")
	DeathAnimStdBwd=("ar_death_standing_a","ar_death_standing_e")

	// Remap physical impulses to RigidBodies which provide better visual results.
	PhysicsImpactRBRemapTable(0)=(RB_FromName="b_MF_Spine_01",RB_ToName="b_MF_Spine_02")

	// List of springs that use be connected to RigidBodies
	PhysicsImpactSpringList=("b_MF_Hand_L","b_MF_Hand_R")
	MeatShieldUnfixedBoneList=("b_MF_Head","b_MF_Neck","b_MF_Forearm_L","b_MF_Hand_L","b_MF_Hand_R","b_MF_Forearm_R","b_MF_Thigh_L","b_MF_Calf_L","b_MF_Foot_L","b_MF_Thigh_R","b_MF_Calf_R","b_MF_Foot_R")

	// Joint limits to scale down when dead.
	RagdollLimitScaleTable(0)=(RB_ConstraintName="b_MF_Thigh_L",Swing1Scale=0.55,Swing2Scale=0.2,TwistScale=0.25)
	RagdollLimitScaleTable(1)=(RB_ConstraintName="b_MF_Thigh_R",Swing1Scale=0.55,Swing2Scale=0.2,TwistScale=0.25)
	RagdollLimitScaleTable(2)=(RB_ConstraintName="b_MF_Foot_L",Swing1Scale=0.5,Swing2Scale=0.5,TwistScale=0.45)
	RagdollLimitScaleTable(3)=(RB_ConstraintName="b_MF_Foot_R",Swing1Scale=0.5,Swing2Scale=0.5,TwistScale=0.45)
	RagdollLimitScaleTable(4)=(RB_ConstraintName="b_MF_Neck",Swing1Scale=0.5,Swing2Scale=0.5,TwistScale=0.5)
	RagdollLimitScaleTable(5)=(RB_ConstraintName="b_MF_Spine01",Swing1Scale=0.3,Swing2Scale=0.3,TwistScale=0.1)
	RagdollLimitScaleTable(6)=(RB_ConstraintName="b_MF_Spine02",Swing1Scale=0.3,Swing2Scale=0.3,TwistScale=0.1)
	//These constraints cause 'jazz hands'
	//RagdollLimitScaleTable(7)=(RB_ConstraintName="b_MF_UpperArm_L",Swing1Scale=0.35,Swing2Scale=0.3,TwistScale=0.25)
	//RagdollLimitScaleTable(8)=(RB_ConstraintName="b_MF_UpperArm_R",Swing1Scale=0.35,Swing2Scale=0.3,TwistScale=0.25)
	//RagdollLimitScaleTable(9)=(RB_ConstraintName="b_MF_Clavicle_L",Swing1Scale=0.1,Swing2Scale=0.1,TwistScale=0.5)
	//RagdollLimitScaleTable(10)=(RB_ConstraintName="b_MF_Clavicle_R",Swing1Scale=0.1,Swing2Scale=0.1,TwistScale=0.5)

	TimeToScaleLimits=1.f

	bDoWalk2IdleTransitions=TRUE

	Begin Object Name=GearPawnMesh
		//bRootMotionExtractedNotify=TRUE // DEBUG DEBUG DEBUG
	    bHasPhysicsAssetInstance=TRUE	// Needed by PhysicsBodyImpact
		AnimSets.Empty()
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel')
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_Overlay')
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_LayeredNew')
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_HitsAndDeaths')
		AnimSets.Add(AnimSet'COG_MarcusFenix.Chainsaw_Duel')
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.Shield_Anims') // 143542  bytes
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.Meat_Shield_Anims')
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_DBNO')
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.AnimSet_CameraMovement')
		AnimSets.Add(AnimSet'Gesture_Animations.COG_Rifle')
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.Animset_Lever_Pulls') // 56304 bytes
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_Cleaver_Execution')
		AnimTreeTemplate=AnimTree'COG_MarcusFenix_LD.Animations.AT_MarcusLayered'
		Translation=(Z=-74)
	End Object

	Begin Object Name=CollisionCylinder
	    CollisionRadius=+0030.000000
		CollisionHeight=+0072.000000
	End Object

	CrouchHeight=+60.0
	CrouchRadius=+30.0
	MeleeRange=35.0
	JumpZ=2500.f

	SpecialMoveClasses(SM_Emerge_Type1)		=class'GSM_Emerge'
	SpecialMoveClasses(SM_Emerge_Type2)		=class'GSM_EmergeBurst'
	SpecialMoveClasses(SM_Emerge_Type3)		=class'GSM_EmergeQuickJump'
	SpecialMoveClasses(SM_Emerge_Pod)		=class'GSM_EmergePod'
	SpecialMoveClasses(SM_Emerge_PodJump)	=class'GSM_EmergeQuickJump_Pod'

	SpecialMoveClasses(SM_ReviveTeammate)		=class'GSM_ReviveTeammate'
	SpecialMoveClasses(SM_DeathAnim)			=class'GSM_DeathAnim'
	SpecialMoveClasses(SM_DeathAnimFire)		=class'GSM_DeathAnimFire'
	SpecialMoveClasses(SM_DeathAnimCleaver)		=class'GSM_DeathAnimCleaver'
	SpecialMoveClasses(SM_RecoverFromRagdoll)	=class'GSM_RecoverFromRagdoll'

	SpecialMoveClasses(SM_Walk2Idle)		=class'GSM_TransitionWalk2Idle'
	SpecialMoveClasses(SM_Run2Idle)			=class'GSM_TransitionRun2Idle'

	SpecialMoveClasses(SM_Run2MidCov)		=class'GSM_Run2MidCov'
	SpecialMoveClasses(SM_Run2StdCov)		=class'GSM_Run2StdCov'
	SpecialMoveClasses(SM_PushOutOfCover)	=class'GSM_PushOutOfCover'
	SpecialMoveClasses(GSM_CoverDestroyed)	=class'GSM_CoverDestroyed'

	SpecialMoveClasses(SM_RoadieRun)		=class'GSM_RoadieRun'
	SpecialMoveClasses(SM_CoverRun)			=class'GSM_CoverRun'
	SpecialMoveClasses(SM_RoadieRunStab)	=class'GSM_RoadieRunStab'
	SpecialMoveClasses(SM_CoverSlip)		=class'GSM_CoverSlip'
	SpecialMoveClasses(SM_StdLvlSwatTurn)	=class'GSM_StdLvlSwatTurn'
	SpecialMoveClasses(SM_MidLvlJumpOver)	=class'GSM_MidLvlJumpOver'
	SpecialMoveClasses(SM_MantleUpLowCover)	=class'GSM_MantleUpLowCover'
	SpecialMoveClasses(SM_MantleDown)		=class'GSM_MantleDown'
	SpecialMoveClasses(SM_EvadeFwd)			=class'GSM_EvadeFwd'
	SpecialMoveClasses(SM_EvadeBwd)			=class'GSM_EvadeBwd'
	SpecialMoveClasses(SM_EvadeLt)			=class'GSM_EvadeLt'
	SpecialMoveClasses(SM_EvadeRt)			=class'GSM_EvadeRt'
	SpecialMoveClasses(SM_EvadeFromCoverCrouching)=class'GSM_EvadeFromCoverCrouching'
	SpecialMoveClasses(SM_EvadeFromCoverStanding) =class'GSM_EvadeFromCoverStanding'
	SpecialMoveClasses(GSM_Leap)            =class'GSM_Leap'

	SpecialMoveClasses(SM_WeaponPickup)			=class'GSM_Pickup'
	SpecialMoveClasses(SM_DoorPush)				=class'GSM_DoorPush'
	SpecialMoveClasses(SM_DoorKick)				=class'GSM_DoorKick'
	SpecialMoveClasses(SM_PushButton)			=class'GSM_PushButton'
	SpecialMoveClasses(SM_Engage_Loop)			=class'GSM_EngageLoop'
	SpecialMoveClasses(SM_Engage_Start)			=class'GSM_EngageStart'
	SpecialMoveClasses(SM_Engage_End)			=class'GSM_EngageEnd'
	SpecialMoveClasses(SM_Engage_Idle)			=class'GSM_EngageIdle'
	SpecialMoveClasses(SM_Engage_ForceOff)		=class'GSM_EngageForceOff'
	SpecialMoveClasses(SM_LadderClimbUp)		=class'GSM_LadderClimbUp'
	SpecialMoveClasses(SM_LadderClimbDown)		=class'GSM_LadderClimbDown'
	SpecialMoveClasses(SM_GrapplingHook_Climb)	=class'GSM_GrapplingHook_Climb'
	SpecialMoveClasses(SM_GrapplingHook_DynamicClimb)	=class'GSM_GrapplingHook_DynamicClimb'
	SpecialMoveClasses(SM_Rappel)	            =class'GSM_Rappel'
	SpecialMoveClasses(SM_ZiplineStart)         =class'GSM_ZiplineStart'
	SpecialMoveClasses(SM_ZiplineIdle)          =class'GSM_ZiplineIdle'
	SpecialMoveClasses(SM_ZiplineEnd)           =class'GSM_ZiplineEnd'

	SpecialMoveClasses(SM_RidingRatTruck)       =class'GSM_RidingRatTruck'


	SpecialMoveClasses(SM_PushCover)			=class'GSM_PushCover'
	SpecialMoveClasses(SM_PushObject)			=class'GSM_PushObject'

	SpecialMoveClasses(SM_FlankedReaction_Left)				=class'GSM_FlankedReaction_Left'
	SpecialMoveClasses(SM_FlankedReaction_Right)			=class'GSM_FlankedReaction_Right'
	SpecialMoveClasses(SM_FlankedReaction_Back)				=class'GSM_FlankedReaction_Back'
	SpecialMoveClasses(SM_FlankedReaction_Front)			=class'GSM_StumbleFromMelee'
	SpecialMoveClasses(SM_Reaction_InitCombat)				=class'GSM_InitCombatReaction'
	SpecialMoveClasses(SM_FullBodyHitReaction)				=class'GSM_FullBodyHitReaction'

	SpecialMoveClasses(SM_StumbleBackOutOfCover)			=class'GSM_StumbleBackOutOfCover'
	SpecialMoveClasses(SM_StumbleGoDown)					=class'GSM_StumbleGoDown'
	SpecialMoveClasses(SM_StumbleGoDownFromExplosion)		=class'GSM_StumbleGoDownFromExplosion'
	SpecialMoveClasses(SM_StumbleGoDownFromCloseRangeShot)	=class'GSM_StumbleGoDownFromCloseRangeShot'
	SpecialMoveClasses(SM_StumbleGetUp)						=class'GSM_StumbleGetUp'
	SpecialMoveClasses(SM_StumbleForwardFromExplosion)		=class'GSM_StumbleForwardFromExplosion'
	SpecialMoveClasses(SM_CoverHead)						=class'GSM_CoverHead'
	SpecialMoveClasses(SM_CoverHeadPushed)                  =class'GSM_CoverHeadPushed'
	SpecialMoveClasses(SM_CoverHeadPushed_ByCorpser)        =class'GSM_CoverHeadPushed_ByMomCorpser'
	SpecialMoveClasses(SM_FaceShield)						=class'GSM_FaceShield'
	SpecialMoveClasses(SM_CleaverStabbed)					=class'GSM_CleaverStabbed'
	SpecialMoveClasses(SM_StumbleFromMelee)					=class'GSM_StumbleFromMelee'
	SpecialMoveClasses(SM_StumbleFromMelee2)				=class'GSM_StumbleFromMelee2'
	SpecialMoveClasses(SM_ChainsawInterrupt)=class'GSM_ChainsawInterrupt'
	SpecialMoveClasses(SM_StumbleFromMantleKick)			=class'GSM_StumbleFromMantleKick'
	SpecialMoveClasses(SM_DBNO)								=class'GSM_DBNO'
	SpecialMoveClasses(SM_RecoverFromDBNO)					=class'GSM_RecoverFromDBNO'
	SpecialMoveClasses(SM_RoadieRunHitReactionStumble)		=class'GSM_RoadieRunHitReactionStumble'

	SpecialMoveClasses(SM_CQC_Victim)				=class'GSM_CQC_Victim'
	SpecialMoveClasses(SM_CQCMove_CurbStomp)		=class'GSM_CQCMove_CurbStomp'
	SpecialMoveClasses(SM_CQCMove_PunchFace)		=class'GSM_CQCMove_PunchFace'
	SpecialMoveClasses(SM_CQCMove_Shield)			=class'GSM_CQCMove_Shield'
	SpecialMoveClasses(SM_CQCMove_B)				=class'GSM_CQCMove_B'
	SpecialMoveClasses(SM_ChainSawHold)				=class'GSM_ChainSawHold'
	SpecialMoveClasses(SM_ChainSawAttack)			=class'GSM_ChainSawAttack'
	SpecialMoveClasses(SM_ChainSawVictim)			=class'GSM_ChainsawVictim'
	SpecialMoveClasses(SM_ChainsawDuel_Leader)		=class'GSM_ChainsawDuel_Leader'
	SpecialMoveClasses(SM_ChainsawDuel_Follower)	=class'GSM_ChainsawDuel_Follower'
	SpecialMoveClasses(SM_ChainsawDuel_Draw)		=class'GSM_ChainsawDuel_Draw'
	SpecialMoveClasses(SM_ChainSawAttack_Object)	=class'GSM_ChainSawAttack_Object'
	SpecialMoveClasses(SM_ChainSawAttack_Object_NoCamera)	=class'GSM_ChainSawAttack_Object_NoCamera'
	SpecialMoveClasses(SM_BayonetAttack)			=class'GSM_BayonetAttack'
	SpecialMoveClasses(SM_BayonetVictim)			=class'GSM_BayonetVictim'
	SpecialMoveClasses(SM_BayonetDraw_Leader)			=class'GSM_BayonetDraw_Leader'
	SpecialMoveClasses(SM_BayonetDraw_Follower)			=class'GSM_BayonetDraw_Victim'
	SpecialMoveClasses(SM_DiggerChestDrill)			=class'GSM_DiggerChestDrill'
	SpecialMoveClasses(SM_FlailSmashAttack)			=class'GSM_Flail_Smash'

	SpecialMoveClasses(SM_PutOnHelmet)				=class'GSM_PutOnHelmet'
	SpecialMoveClasses(SM_UsingCommLink)			=class'GSM_UsingCommLink'
	SpecialMoveClasses(SM_TargetMortar)				=class'GSM_TargetMortar'
	SpecialMoveClasses(SM_TargetMinigun)			=class'GSM_TargetMinigun'
	SpecialMoveClasses(SM_TargetHeavySniper)		=class'GSM_TargetHeavySniper'
	SpecialMoveClasses(SM_UnMountMinigun)			=class'GSM_UnMountMinigun'
	SpecialMoveClasses(SM_UnMountMortar)			=class'GSM_UnMountMortar'
	SpecialMoveClasses(SM_UnMountHeavySniper)		=class'GSM_UnMountHeavySniper'
	SpecialMoveClasses(SM_DeployShield)				=class'GSM_DeployShield'
	SpecialMoveClasses(SM_PlantShield)				=class'GSM_PlantShield'
	SpecialMoveClasses(SM_RaiseShieldOverHead)		=class'GSM_RaiseShieldOverHead'
	SpecialMoveClasses(SM_ShieldBash)				=class'GSM_ShieldBash'
	SpecialMoveClasses(SM_CleaverThrow)             =class'GSM_CleaverThrow'
	SpecialMoveClasses(SM_CleaverSwipe)             =class'GSM_CleaverSwipe'

	// Pawn to Pawn Interactions
	SpecialMoveClasses(SM_GrabWretch)				=None
	SpecialMoveClasses(SM_Kidnapper)				=class'GSM_Kidnapper'
	SpecialMoveClasses(SM_Kidnapper_Execution)		=class'GSM_Kidnapper_Execution'
	SpecialMoveClasses(SM_Kidnapper_GrenadeRelease) =class'GSM_Kidnapper_GrenadeRelease'
	SpecialMoveClasses(SM_Hostage)					=class'GSM_Hostage'
	SpecialMoveClasses(SM_Hostage_GrenadeRelease)=class'GSM_Hostage_GrenadeRelease'
	SpecialMoveClasses(SM_MantleKick)				=class'GSM_MantleKick'

	SpecialMoveClasses(SM_BloodMountDriver_CalmMount)	=class'GSM_BloodMountDriver_CalmMount'
	SpecialMoveClasses(GSM_BloodMount_Melee)		=class'GSM_BloodMount_Melee'
	SpecialMoveClasses(GSM_Silverback_GetOut)=class'GSM_SilverbackDriver_GetOut'

	SpecialMoveClasses(SM_LeaderShout)=class'GSM_LeaderShout'

	SpecialMoveClasses(GSM_DragInjured_Leader)=class'GSM_DragInjured_Leader'
	SpecialMoveClasses(GSM_DragInjured_Follower)=class'GSM_DragInjured_Follower'

	SpecialMoveClasses(SM_ScriptedMove)				=class'GSM_ScriptedMove'

	SpecialMoveClasses(GSM_SiegeBeast_Gunner)       =class'GSM_SiegeBeast_Gunner'
	SpecialMoveClasses(GSM_SiegeBeast_Loader)       =class'GSM_SiegeBeast_Loader'

	SpecialMoveClasses(SM_AmmoBoxDrop)  =class'GSM_DropAmmoBox'

	PawnToPawnInteractionList=(SM_Kidnapper)

	bBlockCamera=FALSE
	DeadBodyImpactSound=SoundCue'Foley_BodyMoves.BodyMoves.BodyFall_LocustCue'
	PS_MeleeImpactEffect=ParticleSystem'Effects_Gameplay.Blood.P_Melee_Blood'
	PS_RadialDamageEffect=ParticleSystem'Effects_Gameplay.Blood.P_Blood_Explosive_RadialDamage_Impact'

	DamageActorCameraAnim=CameraAnim'Effects_Camera.Explosions.CA_Lambent_Berzerker_Gas_Damage'

	bCanDoFloorConform=TRUE
	bDoFootPlacement=TRUE

	bCanDBNO=true
	bCanUseCover=true
	bForceDBNOInSiege=true
	BloodMountFixedBoneList=("b_MF_Thigh_L","b_MF_Calf_L","b_MF_Foot_L","b_MF_Thigh_R","b_MF_Calf_R","b_MF_Foot_R")
	NavMeshObstacleRegistrationTime=3.0

	bCanRoadieRunWhileTargeting=true
}
