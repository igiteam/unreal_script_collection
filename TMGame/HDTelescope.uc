//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDTelescope extends Object;

var HDWeapon        Owner;
var Texture2D       HudTexture;
var Texture2D       HudPadMaterial;
var MaterialInstanceConstant        HudMaterial;

enum EWeaponStableState
{
     EWSS_Stable,
     EWSS_Normal,
     EWSS_Tremble,
};
var transient       EWeaponStableState    ZoomStable;
var float           StableTime;
var float           TrembleTime;
var transient       float           LastStableTime;
var transient       float           LastTrembleTime;

var float           GotoStableTime;
var float           GotoNormalTime;
var float           GotoTrembleTime;
var vector          Zoom_Amplitude_Stable;
var vector          Zoom_Amplitude_Normal;
var vector          Zoom_Amplitude_Tremble;

var const float     FOVMagicNum;
var const float     FOVMagicDiffNum;
var const float     FOVGunMagicNum;
var const float     FOVWideScreenNum;
var float           DistanceThreshold;
enum EZoomFunction
{
    EZF_HUD,
    EZF_GUN,
};
var const EZoomFunction           ZoomFunction;

var transient bool                bDisplayCrosshair;

var float FOVSpeed;
var float FOVDiff;
var float MaxSceneFOVDiff;

simulated function SetDispalyCrosshair( bool flag )
{
	bDisplayCrosshair = flag;
}

simulated function DrawWeaponCrosshair( Hud HUD )
{
    if ( ZoomFunction == EZF_GUN ) return;

	if ( Owner.ZoomState != ZST_NotZoomed && bDisplayCrosshair )
	{
		if ( Owner.ZoomState > ZST_ZoomingOut )
		{
            DrawZoomedOverlay(HUD);
		}
	}
}

simulated function DrawZoomedOverlay( HUD H )
{
	local float ScaleValue, StartValue;
	local float OldOrgX, OldOrgY, OldClipX, OldClipY;

	// the sniper overlay is a special case that we want to ignore the safe region
	OldOrgX = H.Canvas.OrgX;
	OldOrgY = H.Canvas.OrgY;
	OldClipX = H.Canvas.ClipX;
	OldClipY = H.Canvas.ClipY;
	H.Canvas.OrgX = 0.0;
	H.Canvas.OrgY = 0.0;
	H.Canvas.ClipX = H.Canvas.SizeX;
	H.Canvas.ClipY = H.Canvas.SizeY;


	ScaleValue = (H.Canvas.ClipX >= H.Canvas.ClipY)? H.Canvas.ClipY/1024.0 : H.Canvas.ClipX/1024.0;
    StartValue = (H.Canvas.ClipX >= H.Canvas.ClipY)? 0.5*H.Canvas.ClipX - 512.0*ScaleValue : 0.5*H.Canvas.ClipY - 512.0*ScaleValue;

	H.Canvas.SetDrawColor(255,255,255);


	// Draw the crosshair
	// Draw the 4 corners
	if ( HudTexture != None )
	{
    	if ( HudPadMaterial == None )
    	{
    	   H.Canvas.SetPos(0,0);
    	   H.Canvas.DrawTile(HudTexture, H.Canvas.ClipX, H.Canvas.ClipY, 0,0,1024,1024);
    	}

    	else
    	{
            if (H.Canvas.ClipX >= H.Canvas.ClipY)
        	{
        		H.Canvas.SetPos(StartValue, 0.0);
        		H.Canvas.DrawTile(HudTexture, 1024.0 * ScaleValue, 1024.0 * ScaleValue, 0, 0, 1024.0, 1024.0);
        		if ( StartValue > 0 )
        		{
        			// Draw the Horizontal Borders
        			H.Canvas.SetPos(0.0, 0.0);
        			H.Canvas.DrawTile(HudPadMaterial, StartValue, H.Canvas.ClipY, 0, 0, StartValue, H.Canvas.ClipY);

        			H.Canvas.SetPos(H.Canvas.ClipX - StartValue, 0.0);
        			H.Canvas.DrawTile(HudPadMaterial, StartValue, H.Canvas.ClipY, 0, 0, StartValue, H.Canvas.ClipY);
        		}
        	}
        	else
        	{
        		H.Canvas.SetPos(0.0, StartValue);
        		H.Canvas.DrawTile(HudTexture, 1024.0 * ScaleValue, 1024.0 * ScaleValue, 0, 0, 1024.0, 1024.0);
        		if ( StartValue > 0 )
        		{
        			// Draw the Horizontal Borders
        			H.Canvas.SetPos(0.0, 0.0);
        			H.Canvas.DrawTile(HudPadMaterial, H.Canvas.ClipX, StartValue, 0, 0, H.Canvas.ClipX, StartValue);

        			H.Canvas.SetPos(0.0, H.Canvas.ClipY - StartValue);
        			H.Canvas.DrawTile(HudPadMaterial, H.Canvas.ClipX, StartValue , 0, 0, H.Canvas.ClipX, StartValue );
        		}
        	}
        }
    }

    else if ( HudMaterial != None )
    {
    	if ( HudPadMaterial == None )
    	{
    	   H.Canvas.SetPos(0,0);
    	   H.Canvas.DrawMaterialTile(HudMaterial, H.Canvas.ClipX, H.Canvas.ClipY, 0,0,1.0,1.0);
    	}

    	else
    	{
            if (H.Canvas.ClipX >= H.Canvas.ClipY)
        	{
        		H.Canvas.SetPos(StartValue, 0.0);
        		H.Canvas.DrawMaterialTile(HudMaterial, 1024.0 * ScaleValue, 1024.0 * ScaleValue, 0, 0, 1.0, 1.0);
        		if ( StartValue > 0 )
        		{
        			// Draw the Horizontal Borders
        			H.Canvas.SetPos(0.0, 0.0);
        			H.Canvas.DrawTile(HudPadMaterial, StartValue, H.Canvas.ClipY, 0, 0, StartValue, H.Canvas.ClipY);

        			H.Canvas.SetPos(H.Canvas.ClipX - StartValue, 0.0);
        			H.Canvas.DrawTile(HudPadMaterial, StartValue, H.Canvas.ClipY, 0, 0, StartValue, H.Canvas.ClipY);
        		}
        	}
        	else
        	{
        		H.Canvas.SetPos(0.0, StartValue);
        		H.Canvas.DrawMaterialTile(HudMaterial, 1024.0 * ScaleValue, 1024.0 * ScaleValue, 0, 0, 1.0, 1.0);
        		if ( StartValue > 0 )
        		{
        			// Draw the Horizontal Borders
        			H.Canvas.SetPos(0.0, 0.0);
        			H.Canvas.DrawTile(HudPadMaterial, H.Canvas.ClipX, StartValue, 0, 0, H.Canvas.ClipX, StartValue);

        			H.Canvas.SetPos(0.0, H.Canvas.ClipY - StartValue);
        			H.Canvas.DrawTile(HudPadMaterial, H.Canvas.ClipX, StartValue , 0, 0, H.Canvas.ClipX, StartValue );
        		}
        	}
        }
    }

	// restore the canvas parameters
	H.Canvas.OrgX = OldOrgX;
	H.Canvas.OrgY = OldOrgY;
	H.Canvas.ClipX = OldClipX;
	H.Canvas.ClipY = OldClipY;
}

simulated function PreloadTextures(bool bForcePreload)
{
	if (HudTexture != None)
	{
		HudTexture.bForceMiplevelsToBeResident = bForcePreload;
	}
}

simulated function UpdateCameraBreath( out rotator out_CamRot, optional float cof = 1.0f )
{
	if ( ZoomStable == EWSS_Stable )
	{
		Owner.Amplitude_Zoom = VInterpTo( Owner.Amplitude_Zoom, Zoom_Amplitude_Stable, Owner.WorldInfo.DeltaSeconds, VSize(Owner.default.Amplitude_Zoom)/GotoStableTime);
		if ( Owner.WorldInfo.TimeSeconds - LastStableTime > StableTime )
		{
			SetZoomStable(EWSS_Tremble);
		}
	}
	else if ( ZoomStable == EWSS_Normal )
	{
		Owner.Amplitude_Zoom = VInterpTo( Owner.Amplitude_Zoom, Owner.default.Amplitude_Zoom * cof, Owner.WorldInfo.DeltaSeconds, VSize(Owner.default.Amplitude_Zoom)/GotoNormalTime);
	}
	else if ( ZoomStable == EWSS_Tremble )
	{
		Owner.Amplitude_Zoom = VInterpTo( Owner.Amplitude_Zoom, Zoom_Amplitude_Tremble, Owner.WorldInfo.DeltaSeconds, VSize(Owner.default.Amplitude_Zoom)/GotoTrembleTime);
		if ( Owner.WorldInfo.TimeSeconds - LastTrembleTime > TrembleTime )
		{
			SetZoomStable(EWSS_Normal);
		}
	}
	out_CamRot.Pitch += Owner.Amplitude_Zoom.x * Sin(Owner.WorldInfo.TimeSeconds * Owner.Omiga_Zoom.x + Owner.Phi_Zoom.x) / 360.0 * 65535.0;
	out_CamRot.Yaw += Owner.Amplitude_Zoom.y * Sin(Owner.WorldInfo.TimeSeconds * Owner.Omiga_Zoom.y + Owner.Phi_Zoom.y) / 360.0 * 65535.0;
}

simulated function SetZoomStable( EWeaponStableState value )
{
   if ( ZoomStable != value && Owner.ZoomState == ZST_Zoomed )
   {
      ZoomStable = value;
      if ( ZoomStable == EWSS_Stable )
      {
         LastStableTime = Owner.WorldInfo.TimeSeconds;
      }
      if ( ZoomStable == EWSS_Tremble )
      {
         LastTrembleTime =  Owner.WorldInfo.TimeSeconds;
      }
   }
}

simulated function TelescopeZoomStable( bool Flag )
{
    if ( ZoomStable != EWSS_Tremble )
    {
        SetZoomStable( flag ? EWSS_Stable : EWSS_Normal );
    }
}

simulated function Rotator CalculateZoomTrace( rotator BaseRot )
{
    local rotator r;
    local rotator ret;
    local float distance;
    local float index;
    local float FOVGunDiff;
    local float ShootPitch;
    local float PitchDiff;

    FOVGunDiff = (ZoomFunction==EZF_GUN)?FOVGunMagicNum : (Owner.bWideScreen)? FOVWideScreenNum : 1.0f;
    ShootPitch = FOVMagicNum * Owner.CurrentSceneFOV;
    PitchDiff = FOVMagicDiffNum * Owner.CurrentSceneFOV;

    distance = VSize(Owner.HitLoc - Owner.Instigator.Location);
	index = (distance-DistanceThreshold) / DistanceThreshold;
	index = FClamp( index, 0.0, 3.0 );

	r.pitch = (ShootPitch - index * PitchDiff)/FOVGunDiff;
	ret = BaseRot + r;
    return ret;
}

simulated function ChangeZoomScale ( TMPlayerController PC, bool bExpand )
{
     local float value;

     if ( bExpand )
        Owner.SceneFOVDiff += FOVDiff;
     else
        Owner.SceneFOVDiff -= FOVDiff;

     Owner.SceneFOVDiff = FClamp( Owner.SceneFOVDiff, Owner.default.SceneFOVDiff, default.MaxSceneFOVDiff);
     if ( ZoomFunction == EZF_HUD)
     {
        value = PC.DefaultFOV - Owner.SceneFOVDiff;
        Owner.SyncSetCurrentSceneFOV(value);
        PC.StartZoomNonlinear( Owner.CurrentSceneFOV, FOVSpeed );
     }
}

