class PickupInteraction extends SFRMInteraction; 

var Pickup	PickupFocus; 
var bool	DrawPickupDesc; 

function PostRender( canvas C)
{
	local float XL, YL; 
	//local font CanvasFont; 

	if ( DrawPickupDesc )
	{	
		C.DrawColor = class'Canvas'.Static.MakeColor(255,255,255);

		C.StrLen(PickupFocus$":     ", XL, YL);
		C.SetPos((C.ClipX / 2) - XL - 6, (C.ClipY / 2));
		C.DrawText(PickupFocus$":     ", False);

	}

	super.PostRender(C); 
}

auto state LookingAtPickup
{
Begin:
	PickupFocus=None; 
}
