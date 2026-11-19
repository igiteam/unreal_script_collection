class OLGameplayMarker extends Actor
	native
	placeable;

var() bool bEnabled;
var transient bool bInitiallyEnabled; // keep whether it was enabled on load, to support reloading checkpoints

cpptext
{
	virtual UBOOL IsValid() const { return bEnabled; }

	virtual void PostLoad()
	{
		Super::PostLoad();
		
		if (GIsGame)
		{
			bInitiallyEnabled = bEnabled;
		}
	}

	virtual void Reset()
	{
		bEnabled = bInitiallyEnabled;
	}
}

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bEnabled = true;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bEnabled = false;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bEnabled = !bEnabled;
	}
}

defaultproperties
{
	bEnabled=true

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorMaterials.Anchor'
		Scale=0.25
		SpriteCategoryName="OutlastGameplay"
		HiddenGame=true
		HiddenEditor=false
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	Components.Add(Sprite)
	bEdShouldSnap=True
}
