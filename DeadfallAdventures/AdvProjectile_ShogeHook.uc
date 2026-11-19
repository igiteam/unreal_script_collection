class AdvProjectile_ShogeHook extends EvilProjectile_Base
    hidecategories(Navigation);

var() name BeamSocket;
var export editinline ParticleSystemComponent BeamEmitter;
var ParticleSystem BeamTemplate;
var name EndPointParamName;
var Actor LinkedTo;
var name VictimBoneName;
var export editinline PrimitiveComponent LinkedComponent;
var AdvWeap_ShogeHook_Base ShogeWeapon;

simulated function AddBeamEmitter(SkeletalMeshComponent Mesh)
{
    // End:0x186
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x166
        if(BeamEmitter == none)
        {
            // End:0x163
            if(BeamTemplate != none)
            {
                BeamEmitter = new (Outer) Class'EvilGame.UTParticleSystemComponent';
                BeamEmitter.SetDepthPriorityGroup(2);
                BeamEmitter.SetTemplate(BeamTemplate);
                BeamEmitter.SetHidden(false);
                BeamEmitter.SetTickGroup(3);
                BeamEmitter.bUpdateComponentInTick = true;
                BeamEmitter.SetIgnoreOwnerHidden(true);
                Mesh.AttachComponentToSocket(BeamEmitter, BeamSocket);
            }            
        }
        else
        {
            BeamEmitter.ActivateSystem();
        }
    }
    //return;    
}

function InteractWithLinkedToActor()
{
    local Vector TossDir;

    // End:0x11
    if(LinkedTo == none)
    {
        return;
    }
    TossDir = Normal(-Velocity);
    // End:0x1BC
    if(EvilPawn(LinkedTo) != none)
    {
        // End:0xA8
        if(EvilPawnClothBreakable(LinkedComponent) != none)
        {
            EvilPawnClothBreakable(LinkedComponent).TryDropOnZeroHealth(Class'AdvDmgType_ShogeHook', Location, TossDir * float(100000));            
        }
        else
        {
            // End:0x16E
            if((int(EvilPawn(LinkedTo).GetBodyPartByBone(VictimBoneName)) == int(5)) && EvilPawn(LinkedTo).Weapon != none)
            {
                EvilPawn(LinkedTo).TossInventory(EvilPawn(LinkedTo).Weapon, TossDir);                
            }
            else
            {
                EvilPawn(LinkedTo).Knockdown(TossDir * float(500), vect(0.0000000, 0.0000000, 0.0000000));
            }
        }        
    }
    else
    {
        // End:0x230
        if(KActor(LinkedTo) != none)
        {
            LinkedComponent.WakeRigidBody();
            LinkedComponent.AddImpulse(TossDir * float(2000), Location);
        }
    }
    LinkedTo = none;
    LinkedComponent = none;
    ShutDown();
    //return;    
}

singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local int Idx;
    local SeqEvent_TakeDamage dmgEvent;

    // End:0x11
    if(LinkedTo != none)
    {
        return;
    }
    // End:0xE3
    if(Wall != none)
    {
        Idx = 0;
        J0x2B:

        // End:0xE3 [Loop If]
        if(Idx < Wall.GeneratedEvents.Length)
        {
            dmgEvent = SeqEvent_TakeDamage(Wall.GeneratedEvents[Idx]);
            // End:0xD5
            if(dmgEvent != none)
            {
                dmgEvent.HandleDamage(Wall, none, Class'AdvDmgType_ShogeHook', 0);
            }
            Idx++;
            // [Loop Continue]
            goto J0x2B;
        }
    }
    ShogeWeapon.HookHit();
    LinkedTo = Wall;
    LinkedComponent = WallComp;
    VictimBoneName = 'None';
    //return;    
}

simulated function ShutDown()
{
    BeamEmitter.DetachFromAny();
    super.ShutDown();
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local TraceHitInfo THitInfo;

    // End:0x11
    if(LinkedTo != none)
    {
        return;
    }
    ShogeWeapon.HookHit();
    LinkedTo = Trace(HitLocation, HitNormal, HitLocation + Velocity, HitLocation, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
    LinkedComponent = THitInfo.HitComponent;
    VictimBoneName = THitInfo.BoneName;
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    BeamEmitter.SetVectorParameter(EndPointParamName, Location);
    //return;    
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    ShogeWeapon.HookHit();
    ShutDown();
    //return;    
}

simulated function Destroyed()
{
    ShogeWeapon.HookHit();
    super.Destroyed();
    //return;    
}

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
    //return;    
}

defaultproperties
{
    BeamSocket="MuzzleFlashSocket"
    BeamTemplate=ParticleSystem'wp_shogehook_01.Effects.P_WP_Linkgun_Altbeam'
    EndPointParamName="LinkBeamEnd"
    TimeToExplode=0.5000000
    Speed=50000.0000000
    MaxSpeed=50000.0000000
    // Reference: CylinderComponent'Default__AdvProjectile_ShogeHook.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}