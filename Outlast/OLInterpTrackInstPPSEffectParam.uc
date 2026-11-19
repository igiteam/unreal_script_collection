class OLInterpTrackInstPPSEffectParam extends InterpTrackInst
	native;

cpptext
{
	virtual void InitTrackInst(UInterpTrack* Track);
	virtual void TermTrackInst(UInterpTrack* Track);

	virtual void SaveActorState(UInterpTrack* Track);
	virtual void RestoreActorState(UInterpTrack* Track);
}

var float PreviousParamValue;
var bool PreviousEffectShown;
