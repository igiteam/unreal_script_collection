class TurokSeqAct_FireProjectile extends SequenceAction
    hidecategories(Object);

var() class<Class> mProjectile;
var() float mSpeed;
var() bool mbExplodeOnSpawn;

event Activated()
{
    local @NULL SpawnedProjectile, FireAxis, Dummy1, Dummy2;
    local array ObjectVars, InstVars;
    local int idx;
    local @NULL Instigator;

    GetObjectVars(InstVars, "Instigator");
    idx = 0;
    J0x1E:

    // End:0x67 [Loop If]
    if(idx < InstVars.Length)
    {
        // End:0x5D
        if(Pawn(InstVars[idx]) != none)
        {
            Instigator = Pawn(InstVars[idx]);
            // [Explicit Break]
            goto J0x67;
        }
        ++idx;
        // [Loop Continue]
        goto J0x1E;
    }
    J0x67:

    GetObjectVars(ObjectVars, "Target");
    idx = 0;
    J0x81:

    // End:0x1BD [Loop If]
    if(idx < ObjectVars.Length)
    {
        // End:0x1B3
        if(Actor(ObjectVars[idx]) != none)
        {
            SpawnedProjectile = Actor(ObjectVars[idx]).__NFUN_278__(mProjectile);
            // End:0x15A
            if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
            {
                GetAxes(Actor(ObjectVars[idx]).Rotation, FireAxis, Dummy1, Dummy2);
                SpawnedProjectile.Speed = mSpeed;
                SpawnedProjectile.Instigator = Instigator;
                SpawnedProjectile.Init(FireAxis);
            }
            // End:0x1B3
            if(mbExplodeOnSpawn && TurokProjectile(SpawnedProjectile) != none)
            {
                TurokProjectile(SpawnedProjectile).Explode(Actor(ObjectVars[idx]).Location, vect(0.0000000, 0.0000000, 1.0000000));
            }
        }
        ++idx;
        // [Loop Continue]
        goto J0x81;
    }
    //return;    
}

defaultproperties
{
    mProjectile=Class'TurokProjTimedGrenadeNative'
    mSpeed=2000.0000000
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjClassVersion=3
    ObjName="Fire Projectile"
    ObjCategory="Turok Gameplay"
}