class EvilComboAction_Sound extends EvilComboAction_Base
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Action,Sound);

var(Sound) SoundCue Cue;
var(Sound) bool bPlayOnInstigator;
var(Sound) bool bIsLocal;

function float Run(EvilPawn Instigator, out ComboActionState S)
{
    // End:0x46
    if(bPlayOnInstigator)
    {
        Instigator.PlaySound(Cue, false, false, false,, bIsLocal);        
    }
    else
    {
        S.FirstOther.PlaySound(Cue, false, false, false,, bIsLocal);
    }
    return 0.0000000;
    //return ReturnValue;    
}

defaultproperties
{
    bPlayOnInstigator=true
}