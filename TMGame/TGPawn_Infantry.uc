class TGPawn_Infantry extends TGPawn
	abstract
	dependson(Item_HelmetBase,TGWeapon)
	native(TGPawn)
	nativereplication;

/** if this pawn has a helmet on **/
var bool bHasHelmetOn;

/** Type of helmet to setup for this pawn */
var class<Item_HelmetBase> HelmetType;
var repnotify class<Item_HelmetBase> HelmetTypeReplicated;

/** replicated out to all people to have the helmet pop off **/
var repnotify byte RemoveHelmet;
var repnotify byte RemoveHelmet2;

/** Head static mesh for helmets, etc */
var() editinline StaticMeshComponent HeadSlotStaticMesh;

/** For layering goggles and helmets! **/
var StaticMeshComponent HeadSlotStaticMesh2;

/** Head skeletal mesh for helmets, etc */
var() editinline SkeletalMeshComponent HeadSlotSkeletalMesh;


/** The PSC for any persistent effects that an item might have **/
var ParticleSystemComponent PSC_HelmetParticleEffect;


/** Type of helmet to setup for this pawn */
var class<Item_ShoulderPadBase> ShoulderPadLeftType;
var repnotify class<Item_ShoulderPadBase> ShoulderPadLeftTypeReplicated;

/** replicated out to all people to have the shoulderpad pop off **/
var repnotify byte RemoveShoulderPadLeft;

/** Shoulder pad left**/
var StaticMeshComponent ShoulderPadLeftMesh;


/** Type of helmet to setup for this pawn */
var class<Item_ShoulderPadBase> ShoulderPadRightType;
var repnotify class<Item_ShoulderPadBase> ShoulderPadRightTypeReplicated;

/** replicated out to all people to have the shoulderpad pop off **/
var repnotify byte RemoveShoulderPadRight;

/** Shoulder pad right**/
var StaticMeshComponent ShoulderPadRightMesh;

var Array<Name>	StomachBones, RightShoulderBones, LeftShoulderBones, RightLegBones, LeftLegBones;
var Name		HitReactionStomach, HitReactionLeftShoulder, HitReactionRightShoulder;

/** Idle break animation info struct */
struct native IdleBreakAnimInfo
{
	var	Name					AnimName;
	var ECoverType				CoverType;
	var TGWeapon.EWeaponType	WeaponType;
	var bool					bAIOnly;
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

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

replication
{
	if( Role == ROLE_Authority )
		RemoveHelmet, RemoveHelmet2, bHasHelmetOn, RemoveShoulderPadLeft, RemoveShoulderPadRight, ReplicatedIdleBreakInfo, bDisableIdleBreaks;

	// Replicated to ALL once (at spawn time)
	if( Role == ROLE_Authority && bNetInitial )
		HelmetTypeReplicated, ShoulderPadLeftTypeReplicated, ShoulderPadRightTypeReplicated;
}



/** replicated event */
simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
	case 'ReplicatedIdleBreakInfo':
		PlayIdleBreakAnimation(ReplicatedIdleBreakInfo.Index);
		break;
	case 'HelmetTypeReplicated':
		SetupHelmet();
		break;
	case 'ShoulderPadLeftTypeReplicated':
		SetupShoulderPadLeft();
		break;
	case 'ShoulderPadRightTypeReplicated':
		SetupShoulderPadRight();
		break;
	case 'RemoveHelmet':
		DoRemoveHelmet();
		break;
	case 'RemoveHelmet2':
		DoRemoveHelmet2();
		break;
	case 'RemoveShoulderPadLeft':
		DoRemoveShoulderPadLeft();
		break;
	case 'RemoveShoulderPadRight':
		DoRemoveShoulderPadRight();
		break;
	}

	Super.ReplicatedEvent( VarName );
}


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// the server will set these and then replicate out the clients in bNetInitial
	if( Role == ROLE_Authority )
	{
		SetupHelmet();	// setup the default helmet
		SetUpShoulderPads();  // setup the shoulder pads this guy might have!
		SetTimer( RandRange(IdleBreakFreq.X, IdleBreakFreq.Y), FALSE, nameof(ShouldPlayIdleBreakAnim) );
	}
}


simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	TurnOffHelmetParticleEffects();

	Super.PlayDying( DamageType, HitLoc );
}


// if we're COG AI, and this is SP always DBNO
function bool ShouldForceDBNO(class<TGDamageType> TMDmgType, Pawn InstigatedBy, vector HitLocation )
{
	if (GetTeamNum() == TEAM_COG && !IsHumanControlled() && !WorldInfo.GRI.IsMultiplayerGame() && !TMDmgType.static.IsScriptedDamageType())
	{
		;
		return TRUE;
	}
	return Super.ShouldForceDBNO(TMDmgType,InstigatedBy,HitLocation);
}

// we want to DBNO when we have a kantus around
function bool WantsToDBNO(Pawn InInstigator, vector HitLocation, TraceHitInfo HitInfo)
{
	//local TGAI_Kantus Member;
	//// if we support DBNO, and we're locust
	//if(!IsHumanControlled() && GetTeamNum() == TEAM_LOCUST)
	//{
	//	// check to see if there is a Kantus in our squad
	//	foreach TGAI(Controller).Squad.AllMembers(class'TGAI_Kantus', Member)
	//	{
	//		// if we ARE the kantus, don't treat it differently
	//		if(Member == Controller)
	//		{
	//			return Super.WantsToDBNO(Instigator,HitLocation, HitInfo);
	//		}
	//		// there was a kantus in our squad, so we should try to dbno
	//		return TRUE;
	//	}
	//}

	return Super.WantsToDBNO(Instigator,HitLocation, HitInfo);
}


simulated function bool CanBeCurbStomped()
{
	return( !bTearOff &&
		(IsDBNO() || IsDoingAStumbleGoDown()) &&
		!IsSpecialMeleeVictim() &&
		!IsAHostage() &&
		!IsInCover() );
}


simulated function PlayKickSound()
{
	//PlaySound(SoundCue'Foley_BodyMoves.BodyMoves.LocustLegKick_Cue');
}

/**
 * Handles detaching various body parts.
 */
function DoDamageEffects(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, TraceHitInfo HitInfo)
{
	local vector ApplyImpulse;

	// check for head hits
	if( bLastHitWasHeadShot && HelmetType != None && HelmetType.default.bCanBeShotOff &&
		HelmetType != class'Item_Helmet_None' &&
		HelmetType != class'Item_Helmet_LocustGogglesDown' &&
		HelmetType != class'Item_Helmet_LocustGogglesUp' )
	{
		if( class<TGDamageType>(DamageType) == None || FRand() < class<TGDamageType>(DamageType).default.HelmetRemovalChance )
		{
			ApplyImpulse = Momentum * DamageType.default.KDamageImpulse + VSize(Momentum) * Vect(0, 0, 1);
			RemoveAndSpawnAHelmet( ApplyImpulse, DamageType, FALSE );
		}
	}

	//// check to remove the shoulder pads
	// just re-use the HelmetRemovalChance ^^
	if( MatchNameArray( HitInfo.BoneName, LeftShoulderBones ) )
	{
		if (class<TGDamageType>(DamageType) == None || FRand() < class<TGDamageType>(DamageType).default.HelmetRemovalChance)
		{
			ApplyImpulse = Momentum * DamageType.default.KDamageImpulse + VSize(Momentum) * Vect(0, 0, 1);
			RemoveAndSpawnAShoulderPadLeft( ApplyImpulse, DamageType );
		}
	}

	if( MatchNameArray( HitInfo.BoneName, RightShoulderBones ) )
	{
		if (class<TGDamageType>(DamageType) == None || FRand() < class<TGDamageType>(DamageType).default.HelmetRemovalChance)
		{
			ApplyImpulse = Momentum * DamageType.default.KDamageImpulse + VSize(Momentum) * Vect(0, 0, 1);
			RemoveAndSpawnAShoulderPadRight( ApplyImpulse, DamageType );
		}
	}


	Super.DoDamageEffects(Damage,InstigatedBy,HitLocation,DamageType,Momentum,HitInfo);
}

simulated function UpdatePawnLightEnvironment(LightEnvironmentComponent NewComponent)
{
	Super.UpdatePawnLightEnvironment(NewComponent);

	if( HeadSlotStaticMesh != None )
	{
		HeadSlotStaticMesh.SetLightEnvironment(NewComponent);
	}
	if( HeadSlotStaticMesh2 != None )
	{
		HeadSlotStaticMesh2.SetLightEnvironment(NewComponent);
	}
	if( ShoulderPadLeftMesh != None )
	{
		ShoulderPadLeftMesh.SetLightEnvironment(NewComponent);
	}
	if( ShoulderPadRightMesh != None )
	{
		ShoulderPadRightMesh.SetLightEnvironment(NewComponent);
	}
}

/**
 * This will spawn a helmet near the locust's head.  This is
 * a quick placeholder for the real spawn which we might want to
 * make it not so "jerky pop into view"
 *
 * @param bForced is meant to be a hint to the subclass saying:  Hey! They should be forced.  And up to subclass to obey or not.  (c.f. Theron)
 **/
simulated function RemoveAndSpawnAHelmet( Vector ApplyImpulse, class<DamageType> DamageType, bool bForced )
{
	local vector SpawnLoc;
	local rotator SpawnRot;
	local float Radius, Height;
	local SpawnableItemDatum ItemDatum;
	local Item_HelmetBase AHelmet;

	if (bHasHelmetOn)
	{
		GetBoundingCylinder( Radius, Height );

		// check to see if we have an "outer shell helmet"
		if( HeadSlotStaticMesh2 != none && HeadSlotStaticMesh2.StaticMesh != none )
		{
			bHasHelmetOn = FALSE; // this will now allow pawns to be headshot (outer shells are the important part of the head dress when goggles are included)

			HeadSlotStaticMesh2.SetHidden( TRUE );
			Mesh.DetachComponent(HeadSlotStaticMesh2);
			RemoveHelmet2++;
			HeadSlotStaticMesh2.SetStaticMesh( none );

			ItemDatum = HelmetTypeReplicated.static.GetSpawnableItemDatum();

			if( ItemDatum.TheMesh != None )
			{
				Mesh.GetSocketWorldLocationAndRotation( ItemDatum.AttachSocketName, SpawnLoc, SpawnRot );

				AHelmet = Spawn( class'Item_Helmet_LocustOpenFace',,, SpawnLoc,,, TRUE );
				AHelmet.StaticMeshComponent.SetStaticMesh( class'Item_Helmet_LocustOpenFace'.static.GetSpawnableItemDatum().TheMesh );
				AHelmet.StaticMeshComponent.SetLightEnvironment(LightEnvironment); // just use the pawn's DLE for now this will die soon

				AHelmet.CollisionComponent.AddImpulse( ApplyImpulse * 1.2, vect(0,0,100) );
				AHelmet.CollisionComponent.SetRBAngularVelocity( vect(0,100,300), TRUE );
			}
		}
		else if( HeadSlotStaticMesh != none )
		{
			bHasHelmetOn = FALSE; // this will now allow pawns to be headshot

			HeadSlotStaticMesh.SetHidden( TRUE );
			Mesh.DetachComponent(HeadSlotStaticMesh);
			RemoveHelmet++;

			ItemDatum = HelmetTypeReplicated.static.GetSpawnableItemDatum();

			Mesh.GetSocketWorldLocationAndRotation( ItemDatum.AttachSocketName, SpawnLoc, SpawnRot );

			AHelmet = Spawn( HelmetType,,, SpawnLoc,,, TRUE );

			AHelmet.StaticMeshComponent.SetStaticMesh( ItemDatum.TheMesh );
			AHelmet.StaticMeshComponent.SetLightEnvironment(LightEnvironment); // just use the pawn's DLE for now this will die soon

			AHelmet.CollisionComponent.AddImpulse( ApplyImpulse * 1.2, vect(0,0,100) );
			AHelmet.CollisionComponent.SetRBAngularVelocity( vect(0,100,300), TRUE );
		}
		else if( HeadSlotSkeletalMesh != none )
		{
			bHasHelmetOn = FALSE; // this will now allow pawns to be headshot

			// for right now we are not tossing off skorge helmet in MP.  so just don't do any of this code


// 			HeadSlotSkeletalMesh.SetHidden( TRUE );
// 			Mesh.DetachComponent(HeadSlotSkeletalMesh);
// 			RemoveHelmet++;
//
// 			ItemDatum = HelmetTypeReplicated.static.GetSpawnableItemDatum();
//
// 			Mesh.GetSocketWorldLocationAndRotation( ItemDatum.AttachSocketName, SpawnLoc, SpawnRot );
//
// 			AHelmet = Spawn( HelmetType,,, SpawnLoc,,, TRUE );
//
//
// 			// This is our temp function for setting up the skel mesh helmet.
// 			//
// 			//	Post Gears2:  move this over to the UTGib way of doing things.
// 			AHelmet.TheSkelMeshHelmet = new(AHelmet) class'Item_SkeletalMeshComponent';
// 			AHelmet.CollisionComponent = AHelmet.TheSkelMeshHelmet;
//
// 			AHelmet.TheSkelMeshHelmet.SetSkeletalMesh( ItemDatum.TheSkelMesh );
// 			AHelmet.TheSkelMeshHelmet.SetLightEnvironment(LightEnvironment); // just use the pawn's DLE for now this will die soon
// 			AHelmet.TheSkelMeshHelmet.SetPhysicsAsset( ItemDatum.ThePhysAsset );
// 			AHelmet.AttachComponent( AHelmet.TheSkelMeshHelmet );
//
// // 			//AHelmet.TheSkelMeshHelmet.bNotifyRigidBodyCollision = TRUE;
// // 			AHelmet.TheSkelMeshHelmet.ScriptRigidBodyCollisionThreshold = 5.0f;
// // 			AHelmet.TheSkelMeshHelmet.PhysicsWeight = 1.0f;
//
// 			AHelmet.TheSkelMeshHelmet.SetHasPhysicsAssetInstance( TRUE ); // this need to comes after the AttachComponent so component is in right place.
//
// 			AHelmet.CollisionComponent.AddImpulse( ApplyImpulse * 1.2, vect(0,0,100) );
// 			AHelmet.CollisionComponent.SetRBAngularVelocity( vect(0,100,300), TRUE );
		}


		TurnOffHelmetParticleEffects();

		if( AHelmet != None )
		{
			AHelmet.PlayShotOffSound();

			AHelmet.TurnCollisionOff();

			AHelmet.SetTimer( 0.100f, FALSE, nameof(AHelmet.TurnCollisionOn) ); // to stop inter penetrating and then OOE as physics corrects and shoots it off
		}
	}
}



/**
 * This will spawn a shoulderpad near the locust's shoulder.
 *
 **/
simulated function RemoveAndSpawnAShoulderPadLeft( Vector ApplyImpulse, class<DamageType> DamageType )
{
	local vector SpawnLoc;
	local rotator SpawnRot;
	local float Radius, Height;
	local SpawnableItemDatum ItemDatum;
	local Item_ShoulderPadBase AShoulderPad;

	if( ( ShoulderPadLeftMesh != None ) && ( ShoulderPadLeftMesh.StaticMesh != None ) )
	{
		GetBoundingCylinder( Radius, Height );

		ShoulderPadLeftMesh.SetHidden( TRUE );
		Mesh.DetachComponent(ShoulderPadLeftMesh);
		ShoulderPadLeftMesh = None;
		RemoveShoulderPadLeft++;

		ItemDatum = ShoulderPadLeftTypeReplicated.static.GetSpawnableItemDatum();

		if( ItemDatum.TheMesh != None )
		{
			Mesh.GetSocketWorldLocationAndRotation( name(ItemDatum.AttachSocketName$"left"), SpawnLoc, SpawnRot );

			AShoulderPad = Spawn( ShoulderPadLeftType,,, SpawnLoc, SpawnRot,, TRUE );
			AShoulderPad.StaticMeshComponent.SetStaticMesh( ItemDatum.TheMesh );
			AShoulderPad.StaticMeshComponent.SetLightEnvironment(LightEnvironment); // just use the pawn's DLE for now this will die soon

			AShoulderPad.CollisionComponent.AddImpulse( ApplyImpulse * 1.2, vect(0,0,100) );
			AShoulderPad.CollisionComponent.SetRBAngularVelocity( vect(0,100,300), TRUE );

			AShoulderPad.PlayShotOffSound();

			AShoulderPad.TurnCollisionOff();

			AShoulderPad.SetTimer( 0.100f, FALSE, nameof(AShoulderPad.TurnCollisionOn) ); // to stop inter penetrating and then OOE as physics corrects and shoots it off
		}
	}
}


/**
 * This will spawn a shoulderpad near the locust's shoulder.
 *
 **/
simulated function RemoveAndSpawnAShoulderPadRight( Vector ApplyImpulse, class<DamageType> DamageType )
{
	local vector SpawnLoc;
	local rotator SpawnRot;
	local float Radius, Height;
	local SpawnableItemDatum ItemDatum;
	local Item_ShoulderPadBase AShoulderPad;

	if( ( ShoulderPadRightMesh != None ) && ( ShoulderPadRightMesh.StaticMesh != None ) )
	{
		GetBoundingCylinder( Radius, Height );

		ShoulderPadRightMesh.SetHidden( TRUE );
		Mesh.DetachComponent(ShoulderPadRightMesh);
		ShoulderPadRightMesh = None;
		RemoveShoulderPadRight++;

		ItemDatum = ShoulderPadRightTypeReplicated.static.GetSpawnableItemDatum();

		if( ItemDatum.TheMesh != None )
		{
			Mesh.GetSocketWorldLocationAndRotation( name(ItemDatum.AttachSocketName$"right"), SpawnLoc, SpawnRot );

			AShoulderPad = Spawn( ShoulderPadRightType,,, SpawnLoc, SpawnRot,, TRUE );
			AShoulderPad.StaticMeshComponent.SetStaticMesh( ItemDatum.TheMesh );
			AShoulderPad.StaticMeshComponent.SetLightEnvironment(LightEnvironment); // just use the pawn's DLE for now this will die soon

			AShoulderPad.CollisionComponent.AddImpulse( ApplyImpulse * 1.2, vect(0,0,100) );
			AShoulderPad.CollisionComponent.SetRBAngularVelocity( vect(0,100,300), TRUE );

			AShoulderPad.PlayShotOffSound();

			AShoulderPad.TurnCollisionOff();

			AShoulderPad.SetTimer( 0.100f, FALSE, nameof(AShoulderPad.TurnCollisionOn) ); // to stop inter penetrating and then OOE as physics corrects and shoots it off
		}
	}
}


simulated function TurnOffHelmetParticleEffects()
{
	if( PSC_HelmetParticleEffect != None )
	{
		PSC_HelmetParticleEffect.DeactivateSystem();
		Mesh.DetachComponent( PSC_HelmetParticleEffect );
		PSC_HelmetParticleEffect = None;
	}
}


simulated function DoRemoveHelmet()
{
	HeadSlotStaticMesh.SetHidden( TRUE );
	Mesh.DetachComponent(HeadSlotStaticMesh);

	TurnOffHelmetParticleEffects();
}

simulated function DoRemoveHelmet2()
{
	HeadSlotStaticMesh2.SetHidden( TRUE );
	Mesh.DetachComponent(HeadSlotStaticMesh2);

	TurnOffHelmetParticleEffects();
}

simulated function DoRemoveShoulderPadLeft()
{
	ShoulderPadLeftMesh.SetHidden( TRUE );
	Mesh.DetachComponent(ShoulderPadLeftMesh);
}

simulated function DoRemoveShoulderPadRight()
{
	ShoulderPadRightMesh.SetHidden( TRUE );
	Mesh.DetachComponent(ShoulderPadRightMesh);
}



simulated function bool HasHelmetOn()
{
	//`log( "HasHelmetOn(): " $ bHasHelmetOn @ HelmetTypeReplicated @ !TGGRI(WorldInfo.GRI).IsMultiPlayerGame() );
	//ScriptTrace();

	return bHasHelmetOn
		&& ( ( HelmetTypeReplicated != class'Item_Helmet_LocustGogglesDown' )
		&& ( HelmetTypeReplicated != class'Item_Helmet_LocustGogglesUp' )
		|| (( HelmetTypeReplicated == class'Item_Helmet_LocustOpenFaceWithGogglesDown' ) && ( RemoveHelmet2 == 0 ) ) ) // check to see if the outer shell has been blow off
		&& !WorldInfo.GRI.IsMultiPlayerGame(); // if it is a MP game then helmets don't count
}


/**
 * Handles setting up the helmet for this character based on HelmetType.
 */
simulated function SetupHelmet()
{
	local ActorComponent Component;
	local SkeletalMeshSocket HeadSocket;
	local SpawnableItemDatum ItemDatum;

	//`log( "SetupHelmet " $ HelmetType @ HelmetTypeReplicated @ Mesh @ HeadSlotStaticMesh );

	if( ( Mesh != None) )
	{
		if( Role == ROLE_Authority )
		{
			if( HelmetType != none )
			{
				HelmetTypeReplicated = class<Item_HelmetBase>(HelmetType.static.GetSpawnableItemClass());
			}
		}

		if( HelmetTypeReplicated == none )
		{
			//`warn( "HelmetTypeReplicated was none!" );
			return;
		}

		ItemDatum = HelmetTypeReplicated.static.GetSpawnableItemDatum();

		if( ( ItemDatum.TheMesh != None ) || ( ItemDatum.TheSkelMesh != None ) )
		{
			// if no helmet, clear up slot
			if( HelmetTypeReplicated == class'Item_Helmet_None' )
			{
				// remove/hide any existing one
				if( HeadSlotStaticMesh != none )
				{
					HeadSlotStaticMesh.SetHidden(TRUE);
					HeadSocket = Mesh.GetSocketByName(HeadSocketName);
					if( HeadSocket != None )
					{
						Component = Mesh.FindComponentAttachedToBone( HeadSocket.BoneName );
						if( Component != None )
						{
							Mesh.DetachComponent(Component);
						}
					}
				}
			}
			else
			{
				bHasHelmetOn = TRUE;
				//`log( "bHasHelmetOn " $ bHasHelmetOn );

				if( ItemDatum.TheMesh != None )
				{
					HeadSlotStaticMesh = new(self) class'Item_Helmet_StaticMeshComponent';
					// figure out the mesh to attach
					HeadSlotStaticMesh.SetStaticMesh( ItemDatum.TheMesh );
					HeadSlotStaticMesh.SetScale( ItemDatum.ItemScale );

					// need to possibly adjust the location (e.g. goggles)
					//`log( "Setting trans: " $ ItemDatum.Translation $ " for " $ ItemDatum.TheMesh @ HelmetType );
					HeadSlotStaticMesh.SetTranslation( ItemDatum.Translation );

					// attach the head mesh to the body
					HeadSlotStaticMesh.SetShadowParent(Mesh);
					HeadSlotStaticMesh.SetLightEnvironment(LightEnvironment);
					HeadSlotStaticMesh.SetHidden(FALSE);
					HeadSlotStaticMesh.SetActorCollision(FALSE, FALSE, FALSE);

					// when we say: "head" we really mean the HeadSocketName as some guys have completely different
					// notions/names for the socket that represents the "head"
					if( ItemDatum.AttachSocketName == 'head' )
					{
						Mesh.AttachComponentToSocket(HeadSlotStaticMesh, HeadSocketName);
					}
					else
					{
						Mesh.AttachComponentToSocket(HeadSlotStaticMesh, ItemDatum.AttachSocketName);
					}
				}
				else if( ItemDatum.TheSkelMesh != None )
				{
					HeadSlotSkeletalMesh = new(self) class'Item_Helmet_SkeletalMeshComponent';

					// figure out the mesh to attach
					HeadSlotSkeletalMesh.SetSkeletalMesh( ItemDatum.TheSkelMesh );
					HeadSlotSkeletalMesh.SetPhysicsAsset( ItemDatum.ThePhysAsset );
					HeadSlotSkeletalMesh.SetScale( ItemDatum.ItemScale );

					// need to possibly adjust the location (e.g. goggles)
					//`log( "Setting trans: " $ ItemDatum.Translation $ " for " $ ItemDatum.TheMesh @ HelmetType );
					HeadSlotSkeletalMesh.SetTranslation( ItemDatum.Translation );

					// attach the head mesh to the body
					HeadSlotSkeletalMesh.SetShadowParent(Mesh);
					HeadSlotSkeletalMesh.SetLightEnvironment(LightEnvironment);
					HeadSlotSkeletalMesh.SetHidden(FALSE);
					HeadSlotSkeletalMesh.SetActorCollision(FALSE, FALSE, FALSE);

					// when we say: "head" we really mean the HeadSocketName as some guys have completely different
					// notions/names for the socket that represents the "head"
					if( ItemDatum.AttachSocketName == 'head' )
					{
						Mesh.AttachComponentToSocket(HeadSlotSkeletalMesh, HeadSocketName);
					}
					else
					{
						Mesh.AttachComponentToSocket(HeadSlotSkeletalMesh, ItemDatum.AttachSocketName);
					}

					HeadSlotSkeletalMesh.SetHasPhysicsAssetInstance( TRUE ); // this need to comes after the AttachComponent so component is in right place.
				}


				if( ItemDatum.PS_PersistentEffect != none )
				{
					PSC_HelmetParticleEffect = new(self)class'ParticleSystemComponent';
					Mesh.AttachComponentToSocket( PSC_HelmetParticleEffect, HeadSocketName );
					PSC_HelmetParticleEffect.SetTemplate( ItemDatum.PS_PersistentEffect );
					PSC_HelmetParticleEffect.ActivateSystem();
				}

				if( HelmetTypeReplicated == class'Item_Helmet_LocustOpenFaceWithGogglesDown' )
				{
					ItemDatum = class'Item_Helmet_LocustOpenFace'.static.GetSpawnableItemDatum();
					HeadSlotStaticMesh2 = new(self) class'Item_Helmet_StaticMeshComponent';
					HeadSlotStaticMesh2.SetStaticMesh( ItemDatum.TheMesh );
					HeadSlotStaticMesh2.SetScale( ItemDatum.ItemScale );
					HeadSlotStaticMesh2.SetTranslation( ItemDatum.Translation );

					HeadSlotStaticMesh2.SetShadowParent(Mesh);
					HeadSlotStaticMesh2.SetLightEnvironment(LightEnvironment);
					HeadSlotStaticMesh2.SetHidden(FALSE);
					HeadSlotStaticMesh2.SetActorCollision(FALSE, FALSE, FALSE);

					Mesh.AttachComponentToSocket(HeadSlotStaticMesh2, HeadSocketName);
				}
			}

			SetupHelmetMaterialInstanceConstant();
		}
	}
}

/**
 * Handles setting up the shoulder pads for this character based on Shoulderpad types.
 */
simulated function SetUpShoulderPads()
{
	SetupShoulderPadLeft();
	SetupShoulderPadRight();
}

simulated function SetupShoulderPadLeft()
{
	local ActorComponent Component;
	local SkeletalMeshSocket DasSocket;
	local SpawnableItemDatum ItemDatum;

	if( (ShoulderPadLeftType != None) && (Mesh != None) )
	{
		if( Role == ROLE_Authority )
		{
			ShoulderPadLeftTypeReplicated = class<Item_ShoulderPadBase>(ShoulderPadLeftType.static.GetSpawnableItemClass());
		}

		if( ShoulderPadLeftTypeReplicated == none )
		{
			;
			return;
		}


		ItemDatum = ShoulderPadLeftTypeReplicated.static.GetSpawnableItemDatum();

		if( ItemDatum.TheMesh != None )
		{
			// if no helmet, clear up slot
			if( ShoulderPadLeftTypeReplicated == class'Item_ShoulderPad_None' )
			{
				// remove/hide any existing one
				if( ShoulderPadLeftMesh != none )
				{
					ShoulderPadLeftMesh.SetHidden(TRUE);
					DasSocket = Mesh.GetSocketByName(name(ItemDatum.AttachSocketName$"left"));
					if( DasSocket != None )
					{
						Component = Mesh.FindComponentAttachedToBone( DasSocket.BoneName );
						if( Component != None )
						{
							Mesh.DetachComponent(Component);
						}
					}
				}
			}
			else
			{
				// figure out the mesh to attach
				ShoulderPadLeftMesh = new(self) class'StaticMeshComponent';
				ShoulderPadLeftMesh.SetStaticMesh( ItemDatum.TheMesh );
				ShoulderPadLeftMesh.SetScale( ItemDatum.ItemScale );
				ShoulderPadLeftMesh.SetTranslation( ItemDatum.Translation );
				ShoulderPadLeftMesh.SetActorCollision(FALSE, FALSE, FALSE);

				// attach the head mesh to the body
				ShoulderPadLeftMesh.SetShadowParent(Mesh);
				ShoulderPadLeftMesh.SetLightEnvironment(LightEnvironment);
				ShoulderPadLeftMesh.SetHidden(FALSE);

				Mesh.AttachComponentToSocket( ShoulderPadLeftMesh, name(ItemDatum.AttachSocketName$"left") );
			}

			SetupShoulderPadLeftMaterialInstanceConstant();
		}
	}

}

simulated function SetupShoulderPadRight()
{
	local ActorComponent Component;
	local SkeletalMeshSocket DasSocket;
	local SpawnableItemDatum ItemDatum;

	if( (ShoulderPadRightType != None) && (Mesh != None) )
	{
		if( Role == ROLE_Authority )
		{
			ShoulderPadRightTypeReplicated = class<Item_ShoulderPadBase>(ShoulderPadRightType.static.GetSpawnableItemClass());
		}

		if( ShoulderPadRightTypeReplicated == none )
		{
			;
			return;
		}


		ItemDatum = ShoulderPadRightTypeReplicated.static.GetSpawnableItemDatum();

		if( ItemDatum.TheMesh != None )
		{
			// if no helmet, clear up slot
			if( ShoulderPadRightTypeReplicated == class'Item_ShoulderPad_None' )
			{
				// remove/hide any existing one
				if( ShoulderPadRightMesh != none )
				{
					ShoulderPadRightMesh.SetHidden(TRUE);
					DasSocket = Mesh.GetSocketByName(name(ItemDatum.AttachSocketName$"right"));
					if( DasSocket != None )
					{
						Component = Mesh.FindComponentAttachedToBone( DasSocket.BoneName );
						if( Component != None )
						{
							Mesh.DetachComponent(Component);
						}
					}
				}
			}
			else
			{
				// figure out the mesh to attach
				ShoulderPadRightMesh = new(self) class'StaticMeshComponent';
				ShoulderPadRightMesh.SetStaticMesh( ItemDatum.TheMesh );
				ShoulderPadRightMesh.SetScale( ItemDatum.ItemScale );
				ShoulderPadRightMesh.SetTranslation( ItemDatum.Translation );
				ShoulderPadRightMesh.SetActorCollision(FALSE, FALSE, FALSE);

				// attach the head mesh to the body
				ShoulderPadRightMesh.SetShadowParent(Mesh);
				ShoulderPadRightMesh.SetLightEnvironment(LightEnvironment);
				ShoulderPadRightMesh.SetHidden(FALSE);

				Mesh.AttachComponentToSocket( ShoulderPadRightMesh, name(ItemDatum.AttachSocketName$"right") );

			}

			SetupShoulderPadRightMaterialInstanceConstant();
		}
	}

}


/** This will set up all of the MICs on the helmets if this pawn has one **/
simulated function SetupHelmetMaterialInstanceConstant()
{
	if( ( HeadSlotStaticMesh != None ) && ( bHasHelmetOn == TRUE ) )
	{
		MIC_PawnMatHelmet = HeadSlotStaticMesh.CreateAndSetMaterialInstanceConstant(0);
	}

	if( ( HeadSlotSkeletalMesh != None ) && ( bHasHelmetOn == TRUE ) )
	{
		MIC_PawnMatHelmet = HeadSlotSkeletalMesh.CreateAndSetMaterialInstanceConstant(0);
	}
}

/** This will set up all of the MICs on the shoulderpads if this pawn has one **/
simulated function SetupShoulderPadLeftMaterialInstanceConstant()
{
	if( ( ShoulderPadLeftMesh != None ) )
	{
		MIC_PawnMatShoulderPadLeft = ShoulderPadLeftMesh.CreateAndSetMaterialInstanceConstant(0);
	}
}

/** This will set up all of the MICs on the shoulderpads if this pawn has one **/
simulated function SetupShoulderPadRightMaterialInstanceConstant()
{
	if( ( ShoulderPadRightMesh != None ) )
	{
		MIC_PawnMatShoulderPadRight = ShoulderPadRightMesh.CreateAndSetMaterialInstanceConstant(0);
	}
}


/** Heats up the skin by the given amount.  Skin heat constantly diminishes in Tick(). */
simulated function HeatSkin(float HeatIncrement)
{
	Super.HeatSkin( HeatIncrement );

	if( ( HeadSlotStaticMesh != None ) && ( bHasHelmetOn == TRUE ) && ( MIC_PawnMatHelmet != None ) )
	{
		MIC_PawnMatHelmet.SetScalarParameterValue('Heat', CurrentSkinHeat);
	}

	if( ( ShoulderPadLeftMesh != None ) && ( MIC_PawnMatShoulderPadLeft != None ) )
	{
		MIC_PawnMatShoulderPadLeft.SetScalarParameterValue('Heat', CurrentSkinHeat);
	}

	if( ( ShoulderPadRightMesh != None ) && ( MIC_PawnMatShoulderPadRight != None ) )
	{
		MIC_PawnMatShoulderPadRight.SetScalarParameterValue('Heat', CurrentSkinHeat);
	}

	// heat up the weapon if this guy has one
	if( ( MyTGWeapon != None ) && ( MyTGWeapon.MIC_WeaponSkin != none ) )
	{
		MyTGWeapon.MIC_WeaponSkin.SetScalarParameterValue('Heat', CurrentSkinHeat);
	}

	// look into getting the weapons on back to light up also

}

/** Char skin to the given absolute char amount [0..1].  Charring does not diminish over time. */
simulated function CharSkin(float CharIncrement)
{
	Super.CharSkin( CharIncrement );

	if( ( HeadSlotStaticMesh != None ) && ( bHasHelmetOn == TRUE ) && ( MIC_PawnMatHelmet != None ) )
	{
		MIC_PawnMatHelmet.SetScalarParameterValue('Burn', CurrentSkinChar);
	}

	if( ( ShoulderPadLeftMesh != None ) && ( MIC_PawnMatShoulderPadLeft != None ) )
	{
		MIC_PawnMatShoulderPadLeft.SetScalarParameterValue('Burn', CurrentSkinChar);
	}

	if( ( ShoulderPadRightMesh != None ) && ( MIC_PawnMatShoulderPadRight != None ) )
	{
		MIC_PawnMatShoulderPadRight.SetScalarParameterValue('Burn', CurrentSkinChar);
	}

	// heat up the weapon if this guy has one
	if( ( MyTGWeapon != None ) && ( MyTGWeapon.MIC_WeaponSkin != none ) )
	{
		MyTGWeapon.MIC_WeaponSkin.SetScalarParameterValue('Burn', CurrentSkinHeat);
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
	Super.HideMesh();

	HeadSlotStaticMesh.SetHidden(true);
	HeadSlotStaticMesh2.SetHidden(true);

	ShoulderPadLeftMesh.SetHidden(true);
	ShoulderPadRightMesh.SetHidden(true);
}



/** We need to set the HeadSlotStaticMesh2 so we do Super() and then check to see if we have a HeadSlotStaticMesh2 **/
simulated function SetDepthPriorityGroup(ESceneDepthPriorityGroup NewDepthPriorityGroup)
{
	local bool bUseViewOwnerDepthPriorityGroup;

	Super.SetDepthPriorityGroup( NewDepthPriorityGroup );

	// If we're a kidnapper or a hostage, ignore DepthPriorityGroup setting
	// As this is creating sorting issues because both actors are not owned by the same viewport.
	// We don't really care because you can't go in cover in this context.
	if( IsAHostage() || IsAKidnapper() )
	{
		NewDepthPriorityGroup = SDPG_World;
	}

	if( Mesh != None )
	{
		bUseViewOwnerDepthPriorityGroup = NewDepthPriorityGroup != SDPG_World;

		// do helmets
		if( HeadSlotStaticMesh2 != None )
		{
			HeadSlotStaticMesh.SetViewOwnerDepthPriorityGroup( bUseViewOwnerDepthPriorityGroup, NewDepthPriorityGroup );
		}

		if( HeadSlotStaticMesh != None )
		{
			HeadSlotStaticMesh.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup,NewDepthPriorityGroup);
		}

		if( HeadSlotSkeletalMesh != None )
		{
			HeadSlotSkeletalMesh.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup,NewDepthPriorityGroup);
		}

		// do shoulderpads
		if( ShoulderPadLeftMesh != None )
		{
			ShoulderPadLeftMesh.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup,NewDepthPriorityGroup);
		}

		if( ShoulderPadRightMesh != None )
		{
			ShoulderPadRightMesh.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup,NewDepthPriorityGroup);
		}
	}
}

/** stub for playing flail attack animation. Placed here because we don't have boomer base class in GearGame native land. */
simulated function float PlayFlailAttack(float InRate, float InBlendInTime, float InBlendOutTime)
{
	return 0.f;
}

simulated function bool PlayNearMissCringe()
{
	local BodyStance	BS_Cringe;

	if( !IsAliveAndWell() || IsAKidnapper() )
	{
		return FALSE;
	}

	// Disable cringe animations for heavy weapons.
	if( MyTGWeapon != None && (MyTGWeapon.WeaponType == WT_Heavy || MyTGWeapon.IsA('TGWeap_HOD')))
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
			BS_Cringe.AnimName[BS_FullBody] = 'ADD_Overlay_AR_Cringe_B';
			BS_Play(BS_Cringe, 1.f, 0.1f, 0.4f);
			return TRUE;
		}
	}

	return FALSE;
}

/** Play Hit Reaction animation */
simulated function bool PlayHitReactionAnimation(ImpactInfo Impact)
{
	//local BodyStance	BS_HitReaction;
	//local Name			AnimName;

	//// We don't have heavy weapon variation of those, so skip.
	//if( MyTGWeapon != None && MyTGWeapon.WeaponType == WT_Heavy )
	//{
	//	return FALSE;
	//}

	//// Don't play hit reaction animations when in cover, we don't have any.
	//if( CoverType != CT_None )
	//{
	//	return FALSE;
	//}

	//// Find an animation to play based on which bone was hit.
	//if( MatchNameArray(Impact.HitInfo.BoneName, StomachBones) )
	//{
	//	AnimName = HitReactionStomach;
	//}
	//else if( MatchNameArray(Impact.HitInfo.BoneName, RightShoulderBones) )
	//{
	//	AnimName = HitReactionRightShoulder;
	//}
	//else if( MatchNameArray(Impact.HitInfo.BoneName, LeftShoulderBones) )
	//{
	//	AnimName = HitReactionLeftShoulder;
	//}

	//if( AnimName != '' )
	//{
	//	// If we're playing an animation on those nodes, don't override it.
	//	if( BodyStanceNodes.Length <= Min(BS_Std_Idle_Lower, BS_Std_Up) ||
	//		BodyStanceNodes[BS_Std_Idle_Lower] == None ||
	//		BodyStanceNodes[BS_Std_Idle_Lower].bIsPlayingCustomAnim ||
	//		BodyStanceNodes[BS_Std_Up] == None ||
	//		BodyStanceNodes[BS_Std_Up].bIsPlayingCustomAnim )
	//	{
	//		return FALSE;
	//	}

	//	BS_HitReaction.AnimName[BS_Std_Idle_Lower] = AnimName;
	//	BS_HitReaction.AnimName[BS_Std_Up] = AnimName;
	//	NextHitReactionAnimTime = WorldInfo.TimeSeconds + RandRange(0.5f, 1.5f);

	//	return (BS_Play(BS_HitReaction, 0.67f, 0.25f, 0.5f) > 0.f);
	//}

	return FALSE;
}

/** TRUE if NameToMatch is contained within NameArray */
simulated final native function bool MatchNameArray(Name NameToMatch, const out Array<Name> NameArray);

/** AnimSets list updated, post process them */
simulated function AnimSetsListUpdated()
{
	local int	i;

	// In SP, we want each mesh to use their original height
	for(i=0; i<Mesh.AnimSets.Length; i++)
	{
		Mesh.AnimSets[i].bAnimRotationOnly = TRUE;
	}
}

simulated function bool CanBeAHostage()
{
	return TRUE;
}

/** Timer function called to see if an idle break animation should be played */
function ShouldPlayIdleBreakAnim()
{
	local int		i, PickedIndex;
	local bool		bInCombat;
	local FLOAT		LastPlayedTime;
	local TGGRI	TGGRI;

	bInCombat = (TimeSince(LastShotAtTime) < 5.f) || (IsHumanControlled() && bIsInCombat) || (TGAI(Controller) != None && TGAI(Controller).Enemy != None);
	if( bInCombat
		|| bDisableIdleBreaks
		|| bSwitchingWeapons
		|| bPlayedDeath
		|| IsDoingASpecialMove()
		|| MyTGWeapon == None
		|| IsFiring()
		|| IsReloadingWeapon()
		|| bIsTargeting
		|| bUsingCommLink
		|| bSpeaking
		|| (CoverType == CT_None && !bTargetingNodeIsInIdleChannel)
		|| HeadLookAtActor != None
		|| TimeSince(LastTimeMoving) < 3.0 )
	{
		// skip
	}
	else
	{
		PickedIndex = INDEX_NONE;
		LastPlayedTime = 0.f;

		TGGRI = TGGRI(WorldInfo.GRI);
		if( TGGRI.InfantryIdleBreakLastPlayTime.Length < IdleBreakList.Length )
		{
			TGGRI.InfantryIdleBreakLastPlayTime.Length = IdleBreakList.Length;
		}

		for(i=0; i<IdleBreakList.Length; i++)
		{
			if( IdleBreakList[i].CoverType != CoverType ||
				IdleBreakList[i].WeaponType != MyTGWeapon.WeaponType ||
				(IdleBreakList[i].bAIOnly && !IsPlayerOwned()) )
			{
				continue;
			}

			// Try to pick the oldest one that's played
			if( PickedIndex == INDEX_NONE ||
				 TGGRI.InfantryIdleBreakLastPlayTime[i] < LastPlayedTime ||
				(TGGRI.InfantryIdleBreakLastPlayTime[i] == LastPlayedTime && FRand() > 0.5f) )
			{
				PickedIndex = i;
				LastPlayedTime = TGGRI.InfantryIdleBreakLastPlayTime[i];
			}
		}

		if( PickedIndex != INDEX_NONE )
		{
			if( PlayIdleBreakAnimation(byte(PickedIndex)) )
			{
				TGGRI.InfantryIdleBreakLastPlayTime[PickedIndex] = WorldInfo.TimeSeconds;
			}
		}
	}

	// If we're dead, stop trying to play idle break animations.
	if( !bPlayedDeath )
	{
		SetTimer( RandRange(IdleBreakFreq.X, IdleBreakFreq.Y), FALSE, nameof(ShouldPlayIdleBreakAnim) );
	}
}

simulated function bool PlayIdleBreakAnimation(byte PickedIndex)
{
	local BodyStance	StanceToPlay;

	if( Role == ROLE_Authority )
	{
		bForceNetUpdate = TRUE;
		ReplicatedIdleBreakInfo.Count++;
		ReplicatedIdleBreakInfo.Index = PickedIndex;
	}

	if( PickedIndex != INDEX_NONE )
	{
		// Outside of cover idle break
		if( IdleBreakList[PickedIndex].CoverType == CT_None )
		{
			if( BodyStanceNodes.Length >= BS_Std_idle_FullBody && BodyStanceNodes[BS_Std_idle_FullBody] != None && !BodyStanceNodes[BS_Std_idle_FullBody].bIsPlayingCustomAnim )
			{
				StanceToPlay.AnimName[BS_Std_idle_FullBody] = IdleBreakList[PickedIndex].AnimName;
			}
		}
		else if( IdleBreakList[PickedIndex].CoverType == CT_MidLevel )
		{
			if( BodyStanceNodes.Length >= BS_CovMidIdle_Up && BodyStanceNodes[BS_CovMidIdle_Up] != None && !BodyStanceNodes[BS_CovMidIdle_Up].bIsPlayingCustomAnim )
			{
				StanceToPlay.AnimName[BS_CovMidIdle_Up] = IdleBreakList[PickedIndex].AnimName;
			}
		}
		else if( IdleBreakList[PickedIndex].CoverType == CT_Standing )
		{
			if( BodyStanceNodes.Length >= BS_CovStdIdle_Up && BodyStanceNodes[BS_CovStdIdle_Up] != None && !BodyStanceNodes[BS_CovStdIdle_Up].bIsPlayingCustomAnim )
			{
				StanceToPlay.AnimName[BS_CovStdIdle_Up] = IdleBreakList[PickedIndex].AnimName;
			}
		}
	}

	if( StanceToPlay.AnimName.Length > 0 )
	{
		BS_LastIdleBreakAnim.AnimName.length = 0;
		BS_LastIdleBreakAnim = StanceToPlay;

		BS_Play(StanceToPlay, 0.75f, 1.f, 1.f);
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

static function MutatePawn(TGPawn Victim)
{
	local TGPawn_Infantry	InfantryPawn;

	Super.MutatePawn(Victim);

	InfantryPawn = TGPawn_Infantry(Victim);
	if( InfantryPawn != None )
	{
		InfantryPawn.HelmetType = default.HelmetType;
		if( InfantryPawn.HelmetType != None )
		{
			InfantryPawn.SetupHelmet();
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
	TraceComponent(HitLocation, HitNormal, HeadSlotStaticMesh, TraceEnd, TraceStart, vect(0,0,0), HitInfo);
	// Force bone name to trigger specific hit reaction animation.
	HitInfo.BoneName = 'b_MF_UpperArm_R';

	PlayTakeHit(10, Self, HitLocation, class'GDT_LocustPistol', VRand(), HitInfo);

	// Drop off helmet
	ApplyImpulse = Normal(VRand() + vect(0,0,2)) * class'GDT_LocustPistol'.default.KDamageImpulse;
	RemoveAndSpawnAHelmet(ApplyImpulse, class'GDT_LocustPistol', TRUE);
}

///** Kismet Hook to force shooting off helmets */
//function OnForceShootOffHelmet(SeqAct_ForceShootOffHelmet Action)
//{
//	ForceShootOffHelmet();
//}

exec function PutOnHelmet()
{
	ServerDoSpecialMove(SM_PutOnHelmet);
}

///** Kismet Hook to force shooting off helmets */
function OnDoSpecialMove(SeqAct_DoSpecialMove Action)
{
	if( Action.SpecialMoveToDo == EKSM_PutOnHelmet )
	{
		ForceShootOffHelmet();
	}
}

/** Function used to ensure idle breaks are not turned off for the entire game */
function FallbackIdleBreakReEnable()
{
	bDisableIdleBreaks = FALSE;
}

///** Handle action to turn off idle breaks */
//function OnToggleIdleBreaks(SeqAct_ToggleIdleBreaks Action)
//{
//	if (action.InputLinks[0].bHasImpulse)
//	{
//		bDisableIdleBreaks = FALSE;
//		ClearTimer(nameof(FallbackIdleBreakReEnable));
//	}
//	else if (action.InputLinks[1].bHasImpulse)
//	{
//		bDisableIdleBreaks = TRUE;
//		SetTimer(600.0, FALSE, nameof(FallbackIdleBreakReEnable));
//	}
//}


simulated function PlayFallDownPhysicsModify()
{
	Super.PlayFallDownPhysicsModify();

	if( HeadSlotSkeletalMesh != none )
	{
		HeadSlotSkeletalMesh.SetRBChannel(RBCC_Untitled3);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_Untitled3, TRUE);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_DeadPawn, FALSE);
	}

}

simulated function StartPhysicsBodyImpactPhysicsModify()
{
	Super.StartPhysicsBodyImpactPhysicsModify();

	if( HeadSlotSkeletalMesh != none )
	{
		HeadSlotSkeletalMesh.SetRBChannel(RBCC_Nothing);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
	}
}

simulated function BodyImpactBlendOutNotifyPhysicsModify()
{
	Super.BodyImpactBlendOutNotifyPhysicsModify();

	if( HeadSlotSkeletalMesh != none )
	{
		// Restore collision to defaults.
		HeadSlotSkeletalMesh.SetRBChannel(HeadSlotSkeletalMesh.default.RBChannel);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_Pawn, HeadSlotSkeletalMesh.default.RBCollideWithChannels.Pawn);
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


simulated function SkelMeshHelmetTurnItAllOff()
{
	if( HeadSlotSkeletalMesh != none )
	{
		HeadSlotSkeletalMesh.SetBlockRigidBody( FALSE );

		// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
		//HeadSlotSkeletalMesh.SetRBChannel(RBCC_DeadPawn);
		HeadSlotSkeletalMesh.SetRBChannel(RBCC_Nothing);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_Untitled3, FALSE);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_DeadPawn, FALSE);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_Default, FALSE);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_EffectPhysics, FALSE);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_BlockingVolume, FALSE);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_FracturedMeshPart, FALSE);
		HeadSlotSkeletalMesh.SetRBCollidesWithChannel(RBCC_SoftBody, FALSE);
	}
}

///** Util to try and see if pawn is stuck in */
//final native function bool InfantryStuckInWorld();

