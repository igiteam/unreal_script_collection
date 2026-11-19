class AnimNotify_SpawnExplosion extends AnimNotify_Scripted
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() EvilExplosion ExplosionFX;
var EvilExplosion ExplosionTemplate;
var() name SocketName;
var() name BoneName;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local EvilExplosionActor ExplosionActor;
    local EvilExplosion ExplosionObject;
    local Vector pos;
    local Rotator Rot;

    // End:0x275
    if(ExplosionFX != none)
    {
        pos = Owner.Location;
        // End:0xF3
        if(((SocketName != 'None') && EvilPawn(Owner) != none) && EvilPawn(Owner).Mesh != none)
        {
            EvilPawn(Owner).Mesh.GetSocketWorldLocationAndRotation(SocketName, pos, Rot);            
        }
        else
        {
            // End:0x1A4
            if(((BoneName != 'None') && EvilPawn(Owner) != none) && EvilPawn(Owner).Mesh != none)
            {
                pos = EvilPawn(Owner).Mesh.GetBoneLocation(BoneName);
            }
        }
        ExplosionObject = new ExplosionFX.Class (ExplosionFX);
        ExplosionActor = Owner.Spawn(Class'EvilExplosionActor', Owner,, pos);
        ExplosionObject.HitNormal = vect(0.0000000, 0.0000000, 1.0000000);
        ExplosionActor.Explode(ExplosionObject);
    }
    //return;    
}
