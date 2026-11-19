//=============================================================================
// SASWeaponScope.uc
//
// Abstract base class of scope attachment modules for weapons.
//=============================================================================

class SASWeaponScope extends SASWeaponModule
	native
	abstract;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member variables

//var float		mZoomedFoV;		// FoV when using scope
var(Scope) Texture		mOverlay;
var(Scope) Texture		mCrosshair;
var(Scope) float		mCrosshairScale;



//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DisplayDebug
//
simulated function DisplayDebug(
	Canvas		aCanvas, 
	out float	aYL, 
	out float	aYPos)
{
	aCanvas.DrawText ( "SCOPE; mOverlay =" @mOverlay @", mCrosshair =" @mCrosshair );
	aYPos += aYL;
	aCanvas.SetPos(32,aYPos);
}

///////////////////////////////////////////////////////////////////////////////
// RenderOverlays
//
// Called when scope is active to render scope textures.
simulated function RenderOverlays (
	Canvas	aCanvas )
{
	local float		centreX,
					centreY;
	local float		cstartY,
					cwidthY;

	//if ( Owner == None )
	//{
	//	return;
	//}

	centreX = aCanvas.ClipX / 2;
	centreY = aCanvas.ClipY / 2;
	cstartY = centreY * mCrosshairScale;
	cwidthY = aCanvas.ClipY * mCrosshairScale;
	
	aCanvas.Style = ERenderStyle.STY_Alpha;
	aCanvas.SetDrawColor ( 255, 255, 255, 255 );
	
	// get it out behind the rest of the HUD
	aCanvas.Z = 0.01;

	// first draw scope tube/vignette thing
	if ( mOverlay != None )
	{
		// stretched over entire screen
		aCanvas.SetPos ( 0, 0 );
		aCanvas.DrawTile ( mOverlay, aCanvas.ClipX, aCanvas.ClipY, 0, 0, mOverlay.USize, mOverlay.VSize );
	}

	// ensure the crosshair is drawn on-top of the scope tube *and* post-render effects such as nightvision
	aCanvas.Z = 0;

	// next draw crosshair
	if ( mCrosshair != None )
	{	
		// drawn square on in the centre
		aCanvas.SetPos ( centreX - cstartY, centreY - cstartY );
		aCanvas.DrawTile ( mCrosshair, cwidthY, cwidthY, 0, 0, mCrosshair.USize, mCrosshair.VSize );
	}
	
	// restore HUD z
	aCanvas.Z = 0.0;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCrosshairScale=1.0000000
}