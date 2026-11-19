class UseButton extends Trigger
						native
						placeable;

var (UseButton) SoundCue ClickSound;
var (Visual) string UseText;
var (Visual) StaticMesh StaticMesh;
var(Lighting) const editconst LightEnvironmentComponent LightEnvironment;
var(Lighting) StaticMeshComponent StaticMeshComponent;
var AudioComponent ClickAudioComponent;
var bool bUseButtonHidden;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated function PostBeginPlay()
{
	if (ClickSound != none)
	{
		ClickAudioComponent.SoundCue = ClickSound;
		AttachComponent(ClickAudioComponent);
	}
}

function OnHideUseButton(SeqAct_HideUseButton action)
{
    if(action.InputLinks[0].bHasImpulse)
        bUseButtonHidden=true;

    if (action.InputLinks[1].bHasImpulse)
        bUseButtonHidden=false;

    if (action.InputLinks[2].bHasImpulse)
        bUseButtonHidden = !bUseButtonHidden;

    if (bUseButtonHidden)
        SetDrawScale(0.01f);
    else
        SetDrawScale(1.0f);


}

function bool UsedBy(Pawn User)
{
	super.UsedBy(User);
	ClickAudioComponent.Play();

	return true;
}

