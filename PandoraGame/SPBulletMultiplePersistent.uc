class SPBulletMultiplePersistent extends SPBulletPersistent
    native;

var float m_timeIntervalBetweenShots;
var int m_numShots;
var int m_repeatCount;
var Actor m_HitActor;
var ImpactInfo m_impact;
var SPPhysicalMaterial m_SPPhysMat;
var bool m_bHit;
var bool m_bTouch;
var bool m_hitEffectStarted;
var Vector m_firstVectorInPlane;
var Vector m_secondVectorInPlane;
var float m_maxSpread;
var Vector m_spawnLocation;

// Export USPBulletMultiplePersistent::execBulletHitEffects(FFrame&, void* const)
native simulated function BulletHitEffects(Actor HitActor, ImpactInfo Impact, SPPhysicalMaterial SPPhysMat);

simulated function StartMultiBulletHitEffect()
{
    //return;    
}

simulated function StartMultiBulletTouchEffect()
{
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

simulated event ShowTracer(bool bShow)
{
    Mesh.SetHidden(!bShow);
    //return;    
}

final simulated function MultiBulletHitEffect()
{
    // End:0x20
    if(m_repeatCount > 0)
    {
        HandleBulletHitSomething();
        m_repeatCount -= 1;        
    }
    else
    {
        m_repeatCount = 0;
        ClearTimer('MultiBulletHitEffect');
    }
    //return;    
}

final simulated function MultiBulletTouchEffect()
{
    // End:0x50
    if(m_repeatCount > 0)
    {
        BulletHitEffects(bulletTouchInfo.HitActor, bulletTouchInfo.Impact, bulletTouchInfo.SPPhysMat);
        m_repeatCount -= 1;        
    }
    else
    {
        m_bTouch = false;
        m_repeatCount = 0;
        ClearTimer('MultiBulletTouchEffect');
    }
    //return;    
}

simulated event BulletHitSomething(Vector HitNormal, Actor HitActor, Vector HitLocation, optional TraceHitInfo HitInfo)
{
    local SPPawn theShooter, theTarget;

    // End:0x0C
    if(m_bHit)
    {
        return;
    }
    theShooter = SPPawn(Instigator);
    theTarget = SPPawn(HitActor);
    // End:0x59
    if((theShooter != none) && theTarget != none)
    {
        theShooter.HitTarget(theTarget);
    }
    m_repeatCount = m_numShots;
    // End:0x78
    if(m_repeatCount > 4)
    {
        m_repeatCount = 4;
    }
    // End:0x97
    if(m_repeatCount > 0)
    {
        Damage = Damage / float(m_repeatCount);
    }
    SetupHandlingOfBulletHitSomething(HitNormal, HitActor, HitLocation, HitInfo);
    bReflectBullet = false;
    StartMultiBulletHitEffect();
    //return;    
}

simulated event BulletTouchedSomething(Vector HitNormal, Actor HitActor, Vector HitLocation, optional TraceHitInfo HitInfo)
{
    // End:0x0C
    if(m_bTouch)
    {
        return;
    }
    // End:0x17
    if(m_bHit)
    {
        return;
    }
    m_repeatCount = m_numShots;
    // End:0x36
    if(m_repeatCount > 4)
    {
        m_repeatCount = 4;
    }
    SetupHandlingOfBulletHitSomething(HitNormal, HitActor, HitLocation, HitInfo);
    bulletTouchInfo = bulletHitInfo;
    StartMultiBulletTouchEffect();
    //return;    
}

auto simulated state BulletActive
{
    simulated function StartMultiBulletHitEffect()
    {
        m_bHit = true;
        ShowTracer(false);
        SetHidden(true);
        MultiBulletHitEffect();
        // End:0x75
        if((PlayerPawn(bulletHitInfo.HitActor) == none) && m_repeatCount > 0)
        {
            // End:0x62
            if(m_timeIntervalBetweenShots < 0.0500000)
            {
                m_timeIntervalBetweenShots = 0.0500000;
            }
            SetTimer(m_timeIntervalBetweenShots, true, 'MultiBulletHitEffect');
        }
        //return;        
    }

    simulated function StartMultiBulletTouchEffect()
    {
        m_bTouch = true;
        MultiBulletTouchEffect();
        // End:0x63
        if((PlayerPawn(bulletHitInfo.HitActor) == none) && m_repeatCount > 0)
        {
            // End:0x50
            if(m_timeIntervalBetweenShots < 0.0500000)
            {
                m_timeIntervalBetweenShots = 0.0500000;
            }
            SetTimer(m_timeIntervalBetweenShots, true, 'MultiBulletTouchEffect');
        }
        //return;        
    }
    J0x00:
    // End:0x16 [Loop If]
    if(!m_bHit)
    {
        Sleep(0.0010000);
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x51
    if(IsTimerActive('MultiBulletHitEffect'))
    {
        J0x29:

        // End:0x47 [Loop If]
        if(IsTimerActive('MultiBulletHitEffect'))
        {
            Sleep(0.0010000);
            // [Loop Continue]
            goto J0x29;
        }
        ExplodeBullet();
    }
    stop;            
}
