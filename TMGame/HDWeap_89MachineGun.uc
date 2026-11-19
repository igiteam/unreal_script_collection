// HD Begin
class HDWeap_89MachineGun	extends HDWeap_TurretBase;

var float LastFireTime;
var float LastCoolDownTime;

simulated function PostBeginPlay()
{
 	local HDTurret_Base HTurret;
 	super.PostBeginPlay();
	HTurret = HDTurret_Base(Instigator);
 	if(HTurret != None)
    {
      //CoolDownTime = HTurret.CoolDownTime;
      TopOverload = HTurret.TopOverload;
      OverloadPerBullet = HTurret.OverloadPerBullet;
      CoolDownRate = HTurret.CoolDownRate;

      InstantHitDamage[0] = HTurret.HitDamage;
      Spread[0] = HTurret.FireSpread;
	}
}

simulated event Tick( float DeltaTime )
{
	if(bOverload)
	{
	  if(CurrOverload <= 0.f)
	  {
	  	bOverload = false;
	  	CurrOverload = 0.f;
	  }
	}
	if((WorldInfo.TimeSeconds - LastFireTime) > 1.f)
	{
		if(CurrOverload > 0.f)
		{
      		CurrOverload -= CoolDownRate * DeltaTime;
      		LastCoolDownTime = WorldInfo.TimeSeconds;
		}
	}
	super.Tick(DeltaTime);
}

//simulated function UpdateHUD()
//{
//  if(WeapHDHUD == none)
//    WeapHDHUD = HDHUD(HDPlayerController(HDTurret_Base(Instigator).Controller).myHUD);
//  if(WeapHDHUD != none && OverloadPerBullet > 0)
//    WeapHDHUD.DrawMGun(TopOverload,CurrOverload,bOverload);
//}
//
//simulated function CloseHUD()
//{
//  if(WeapHDHUD != none)
//    WeapHDHUD.CloseMGun();
//  WeapHDHUD = none;
//}


simulated function InstantFire()
{
	local vector StartTrace, EndTrace,realStartTrace;
	local Array<ImpactInfo>	ImpactList;
	local ImpactInfo RealImpact, NearImpact;
	local int i, FinalImpactIndex;

    local HDPawn HDP;
	local TGPawn TGP;
    local HDTurret_Base HDH;
	local float t;
    //HDP = HDPawn(Instigator);

    //if (HDP == none)
    HDH = HDTurret_Base(Instigator);
    if(HDH != None)
	{
       HDP = HDPawn(HDH.Driver);
	   TGP = TGPawn(HDH.Driver);
	}
    else
        return;

    if(bOverload)
	 	return;

	if (BulletCount > 0)
	{
		t = (CrosshairScaling - min_scaling) / (max_scaling - min_scaling);
		t = t ** 0.5;
		angle = min_angle * (1 - t) + max_angle * t;
		CrosshairScaling = max_scaling;
		//Clamp(CrosshairScaling, min_scaling, max_scaling);
		//bullet has no limit
		//BulletCount -= 1;

    	// define range to use for CalcWeaponFire()
    	StartTrace = InstantFireStartTrace();
    	EndTrace = InstantFireEndTrace(StartTrace);
    	realStartTrace = StartTrace + vector(GetAdjustedAim(StartTrace)) * 30.f;
    	bUsingAimingHelp = false;
    	// Perform shot
    	RealImpact = CalcWeaponFire(realStartTrace, EndTrace, ImpactList);
		//you cant shoot yourself! I guess...
		for(i = 0;i < ImpactList.Length;++i)
		{
			if(ImpactList[i].HitActor == HDP)
			{
				ImpactList.Remove(i,1);
			}
		}

		FinalImpactIndex = ImpactList.length - 1;
    	if (FinalImpactIndex >= 0 && (ImpactList[FinalImpactIndex].HitActor == None || !ImpactList[FinalImpactIndex].HitActor.bProjTarget))
    	{
    		// console aiming help
    		NearImpact = InstantAimHelp(StartTrace, EndTrace, RealImpact);
    		if ( NearImpact.HitActor != None )
    		{
    			bUsingAimingHelp = true;
    			ImpactList[FinalImpactIndex] = NearImpact;
    		}
    	}

    	for (i = 0; i < ImpactList.length; i++)
    	{
    		ProcessInstantHit(CurrentFireMode, ImpactList[i]);
    	}

    	if (Role == ROLE_Authority)
    	{
    		// Set flash location to trigger client side effects.
    		// if HitActor == None, then HitLocation represents the end of the trace (maxrange)
    		// Remote clients perform another trace to retrieve the remaining Hit Information (HitActor, HitNormal, HitInfo...)
    		// Here, The final impact is replicated. More complex bullet physics (bounce, penetration...)
    		// would probably have to run a full simulation on remote clients.
    		if ( NearImpact.HitActor != None )
    		{
    			SetFlashLocation(NearImpact.HitLocation);
    		}
    		else if (RealImpact.HitActor != None)
    		{
    			SetFlashLocation(RealImpact.HitLocation);
    		}
			else
			{
				SetFlashLocation(EndTrace);
			}
			if (HDP != none)
			{
				if (HDP.CurrentWeaponAttachment != none)
				{
					for (i = 1; i < ImpactList.length; i++)
					{
						if (ImpactList[i].HitLocation != Vect(0,0,0) && (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone) )
						{
							HDWeaponAttachment(HDP.CurrentWeaponAttachment).TPlayImpactEffects(ImpactList[i]);
						}
					}
				}
			}
			else if (TGP != none)
			{
				if (TGP.weapon_attachment != none)
				{
					for (i = 0; i < ImpactList.length; i++)
					{
						HDWeaponAttachment(TGP.weapon_attachment).TPlayImpactEffects(ImpactList[i]);
					}
				}
			}
    	}

		shots_fired ++;
		if (ZoomState == ZST_Zoomed || HDH.bZoomed)
			KickBack(0.25f, 0.1f, 0.10f, 0.02f, 1.f, 0.25f, 7);
		else
            KickBack(0.35f, 0.15f, 0.15f, 0.025f, 2.5f, 0.3f, 7);

        //overload
        CurrOverload += HDH.OverloadPerBullet;
        LastFireTime = WorldInfo.TimeSeconds;
        if(CurrOverload >= TopOverload)
        {
	        bOverload = true;
	        CurrOverload = TopOverload;
	        StopLoopFireSound();
	        TriFireCount=0;
		}
	}

    if (BulletCount == 0)
	{
		Reload();
	}
	return;
}

/**
 * Turns the MuzzleFlashlight off
 */
 /*
simulated event MuzzleFlashTimer()
{
	local HDTurret_Base HDH;
	super.MuzzleFlashTimer();
	HDH = HDTurret_Base(Instigator);
	if(HDH != none)
		HDH.BulletShellsComponent.DeactivateSystem();
}
*/

simulated function DrawWeaponCrosshair( Hud HUD )
{
	local vector2d CrosshairSize;
	local float x,y,PickupScale, ScreenX, ScreenY;
	local TMHUD	H;
	local vector2d sz;
	local HDTurret_Base HDT;
	local float target_scaling, scaling_speed;
	local rotator r;
	local float alpha, t;
	local vector2d hotpoint;
	local vector2d tilesize;
// 	if (!bShowHud)
// 	  return;

	if (ZoomState == ZST_Zoomed)
	    return;
	HDT = HDTurret_Base(Instigator);
	if(HDT.bZoomed)
	    return;

	H = TMHUD(HUD);
	if ( H == None )
		return;

	// Apply pickup scaling
	if ( H.LastPickupTime > WorldInfo.TimeSeconds - 0.3 )
	{
		if ( H.LastPickupTime > WorldInfo.TimeSeconds - 0.15 )
		{
			PickupScale = (1 + 5 * (WorldInfo.TimeSeconds - H.LastPickupTime));
		}
		else
		{
			PickupScale = (1 + 5 * (H.LastPickupTime + 0.3 - WorldInfo.TimeSeconds));
		}
	}
	else
	{
		PickupScale = 1.0;
	}

	hotpoint.X = 3;
	hotpoint.Y = 7;

	tilesize.X = 8;
	tilesize.Y = 8;

	if (max_scaling == min_scaling)
		t = 0.0;
	else
		t = (CrosshairScaling - min_scaling) / (max_scaling - min_scaling);
	angle = min_angle * (1 - t) + max_angle * t;

 	CrosshairSize.Y = H.ConfiguredCrosshairScaling * CrosshairScaling * crosshair_range.Y * PickupScale * H.Canvas.ClipY/720;
  	CrosshairSize.X = CrosshairSize.Y * (crosshair_range.X / crosshair_range.Y);

	X = H.Canvas.ClipX * 0.5;
	Y = H.Canvas.ClipY * 0.5;
	ScreenX = X - (CrosshairSize.X * 0.5);
	ScreenY = Y - (CrosshairSize.Y * 0.5);

	if (max_scaling == min_scaling)
		alpha = 1.0;
	else
		alpha = 1.0 - (CrosshairScaling - min_scaling) / (max_scaling - min_scaling);
	alpha = 255 * alpha + 180 * (1 - alpha);

	sz.X = crosshair_size.X;
	sz.Y = crosshair_size.Y;

	H.Canvas.SetDrawColor(255, 255, 255, alpha);

	// left
	H.Canvas.SetPos(ScreenX - sz.x * hotpoint.x / (tilesize.x - 1), Y - sz.y * (hotpoint.y / (tilesize.y - 1)));
	r.yaw = 270.0 / 360.0 * 65536.0;
	H.Canvas.DrawRotatedTile(CrosshairImage, r, sz.X, sz.Y, 0, 0, CrosshairImage.GetSurfaceWidth(), CrosshairImage.GetSurfaceHeight(), hotpoint.x / (tilesize.x - 1), hotpoint.y / (tilesize.y - 1));

	// right
	H.Canvas.SetPos(X + (X - ScreenX) - sz.x * (hotpoint.x / (tilesize.x - 1)), Y - sz.y * hotpoint.y / (tilesize.y - 1));
	r.yaw = 90.0 / 360.0 * 65536.0;
	H.Canvas.DrawRotatedTile(CrosshairImage, r, sz.X, sz.Y, 0, 0, CrosshairImage.GetSurfaceWidth(), CrosshairImage.GetSurfaceHeight(), hotpoint.x / (tilesize.x - 1), hotpoint.y / (tilesize.y - 1));

	// top
	H.Canvas.SetPos(X - sz.X * hotpoint.X / (tilesize.X - 1), ScreenY - sz.Y * hotpoint.Y / (tilesize.Y - 1));
	r.yaw = 0.0 / 360.0 * 65536.0;
	H.Canvas.DrawRotatedTile(CrosshairImage, r, sz.X, sz.Y, 0, 0, CrosshairImage.GetSurfaceWidth(), CrosshairImage.GetSurfaceHeight(), hotpoint.x / (tilesize.x - 1), hotpoint.y / (tilesize.y - 1));

	// bottom
	H.Canvas.SetPos(X - sz.X * hotpoint.X / (tilesize.X - 1), Y + (Y - ScreenY) - sz.y * (hotpoint.y / (tilesize.y - 1)));
	r.yaw = 180.0 / 360.0 * 65536.0;
	H.Canvas.DrawRotatedTile(CrosshairImage, r, sz.X, sz.Y, 0, 0, CrosshairImage.GetSurfaceWidth(), CrosshairImage.GetSurfaceHeight(), hotpoint.x / (tilesize.x - 1), hotpoint.y / (tilesize.y - 1));

	if (HDT != none)
	{
//		if (VSize(HDT.Velocity) > 20.0)
//		{
//			target_scaling = max_scaling;
//			scaling_speed = (max_scaling - min_scaling) / crosshair_zoomout;
//			CrosshairScaling = CrosshairScaling + scaling_speed * WorldInfo.DeltaSeconds;
//			if (CrosshairScaling > target_scaling)
//				CrosshairScaling = target_scaling;
//		}
//		else
//		{
			target_scaling = min_scaling;
			scaling_speed = -(max_scaling - min_scaling) / crosshair_zoomin;
			CrosshairScaling = CrosshairScaling + scaling_speed * WorldInfo.DeltaSeconds;
			if (CrosshairScaling < target_scaling)
				CrosshairScaling = target_scaling;
//		}
	}
}

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
    local TGTurret TGT;
	local AnimNodeSequence WeapNode;
	local AnimTree Tree;
    TGT = TGTurret(Instigator);

	if (TGT.Mesh != None && TGT.Mesh.bAttached)
	{
	// do not play on a dedicated server
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	if ( SkelMesh == None )
	{
		SkelMesh = TGT.Mesh;
	}

	if( SkelMesh == none)
	{
	  return;
	}
	// Check we have access to mesh and animations
//	if( SkelMesh == none || GetWeaponAnimNodeSeq() == none )
//	{
//		return;
//	}

	if(fDesiredDuration > 0.0)
	{
		// @todo - this should call GetWeaponAnimNodeSeq, move 'duration' code into AnimNodeSequence and use that.
		SkelMesh.PlayAnim(Sequence, 0.0, bLoop);
	}
	else
	{
		//Try getting an animtree first
		Tree = AnimTree(SkelMesh.Animations);
		if (Tree != None)
		{
			WeapNode = AnimNodeSequence(Tree.Children[0].Anim);
		}
		else
		{
			WeapNode = AnimNodeSequence(SkelMesh.Animations);
		}

		WeapNode.SetAnim(Sequence);
		WeapNode.PlayAnim(bLoop, DefaultAnimSpeed);
	}
	}
}
/*
simulated function bool ShouldRefire()
{
	// if doesn't have ammo to keep on firing, then stop
	if( !HasAmmo( CurrentFireMode ) )
	{
		return false;
	}

	if(bOverload)
	{
	    return false;
	}

	// refire if owner is still willing to fire
	return StillFiring( CurrentFireMode );
}
*/
simulated function FireAmmunition()
{
	if(!bOverload)
	{
     	super.FireAmmunition();
	}
}

simulated state Active
{
	simulated function BeginFire(byte FireModeNum)
	{
		if(!bOverload)
		{
		 	super.BeginFire(FireModeNum);
		}

	}


}

// HD End
