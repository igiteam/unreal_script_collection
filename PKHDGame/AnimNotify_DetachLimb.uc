class AnimNotify_DetachLimb extends AnimNotify_Scripted
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() EvilTypes.EBodyParts BodyPart;
var() class<EvilDmgType_Base> EvilDamageType;
var() Vector Momentum;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local EvilPawn P;
    local Rotator Rot;
    local Vector finalMomentum;

    P = EvilPawn(Owner);
    Rot = QuatToRotator(P.Mesh.GetBoneQuaternion('Head', 0));
    finalMomentum = Normal(Vector(Rot)) * Momentum;
    // End:0xFD
    if(EvilPawn(Owner) != none)
    {
        EvilPawn(Owner).DetachLimb(100, EvilDamageType, vect(0.0000000, 0.0000000, 0.0000000), finalMomentum, int(BodyPart));
    }
    //return;    
}

defaultproperties
{
    EvilDamageType=Class'EvilDmgType_Base'
}