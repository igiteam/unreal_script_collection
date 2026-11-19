class EvilGFxHudWrapper extends UTHUD
    transient
    config(Game)
    hidecategories(Navigation);

var EvilGFxHud HudMovie;
var class<EvilGFxHud> HUDClass;
var bool bShowAIDebug;
var bool bShowCursor;
var array<CoverInfo> CachedCoverInfos;
var UTGFxTweenableMoviePlayer MenuBase;
var export editinline array<export editinline EvilActorComponent> PostRenderedComponents;

function RemovePostRenderedComponent(EvilActorComponent C)
{
    local int I;

    I = PostRenderedComponents.Find(C);
    // End:0x48
    if(I != -1)
    {
        PostRenderedComponents.Remove(I, 1);
    }
    //return;    
}

function AddPostRenderedComponent(EvilActorComponent C)
{
    local int I;

    I = PostRenderedComponents.Find(C);
    // End:0x35
    if(I != -1)
    {
        return;
    }
    I = 0;
    J0x40:

    // End:0x9E [Loop If]
    if(I < PostRenderedComponents.Length)
    {
        // End:0x90
        if(PostRenderedComponents[I] == none)
        {
            PostRenderedComponents[I] = C;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x40;
    }
    PostRenderedComponents[PostRenderedComponents.Length] = C;
    //return;    
}

simulated function PostBeginPlay()
{
    local Actor A;
    local editinline EvilCaptionComponent CC;

    super.PostBeginPlay();
    // End:0x6D
    foreach AllActors(Class'Engine.Actor', A)
    {
        // End:0x6B
        foreach A.ComponentList(Class'EvilCaptionComponent', CC)
        {
            AddPostRenderedComponent(CC);            
        }                
    }    
    //return;    
}

function CreateHUDMovie()
{
    local Actor A;
    local editinline EvilCaptionComponent CC;

    // End:0x6F
    foreach AllActors(Class'Engine.Actor', A)
    {
        // End:0x6D
        foreach A.ComponentList(Class'EvilCaptionComponent', CC)
        {
            CC.OnHUDReset();            
        }                
    }    
    //return;    
}

function int GetLocalPlayerOwnerIndex()
{
    return Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
    //return ReturnValue;    
}

function HideHUD(bool PlayCloseAnim)
{
    SetVisible(false);
    //return;    
}

function OpenHUD(bool PlayOpenAnim)
{
    SetVisible(true);
    // End:0x37
    if(PlayOpenAnim)
    {
        HudMovie.PlayOpenAnimation();
    }
    //return;    
}

function DisplayHit(Vector HitDir, int Damage, class<DamageType> DamageType)
{
    //return;    
}

event PostRender()
{
    super.PostRender();
    // End:0x30
    if(bShowHUD && bEnableActorOverlays)
    {
        DrawHUD();
    }
    // End:0x47
    if(bShowMobileHud)
    {
        DrawInputZoneOverlays();
    }
    PlayerOwner.DrawDebugTextList(Canvas, RenderDelta);
    //return;    
}

event DrawHUD()
{
    local Vector ViewPoint;
    local Rotator ViewRotation;
    local float XL, YL, YPos;
    local editinline EvilActorComponent C;

    // End:0xAC
    if((UTGRI != none) && !UTGRI.bMatchIsOver)
    {
        Canvas.Font = GetFontSizeIndex(0);
        PlayerOwner.GetPlayerViewPoint(ViewPoint, ViewRotation);
        DrawActorOverlays(ViewPoint, ViewRotation);
    }
    // End:0x20D
    if(bShowDebugInfo)
    {
        Canvas.Font = GetFontSizeIndex(0);
        Canvas.DrawColor = ConsoleColor;
        Canvas.StrLen("X", XL, YL);
        YPos = 0.0000000;
        PlayerOwner.ViewTarget.DisplayDebug(self, YL, YPos);
        // End:0x20B
        if((ShouldDisplayDebug('AI')) && Pawn(PlayerOwner.ViewTarget) != none)
        {
            DrawRoute(Pawn(PlayerOwner.ViewTarget));
        }
        return;
    }
    // End:0x224
    if(bShowAIDebug)
    {
        DrawAIOverlays();
    }
    // End:0x2A0
    foreach PostRenderedComponents(C)
    {
        // End:0x29F
        if(C != none)
        {
            // End:0x29F
            if(!C.Disabled)
            {
                C.PostRenderFor(PlayerOwner, Canvas);
            }
        }        
    }    
    //return;    
}

function LocalizedMessage(class<LocalMessage> InMessageClass, PlayerReplicationInfo RelatedPRI_1, PlayerReplicationInfo RelatedPRI_2, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor, optional Object OptionalObject)
{
    //return;    
}

function AddConsoleMessage(string M, class<LocalMessage> InMessageClass, PlayerReplicationInfo PRI, optional float Lifetime)
{
    //return;    
}

function ClearMessages()
{
    //return;    
}

function TogglePauseMenu()
{
    //return;    
}

exec function ToggleInventory()
{
    //return;    
}

function CompleteCloseInventory()
{
    //return;    
}

exec function ShowAIDebug()
{
    bShowAIDebug = !bShowAIDebug;
    //return;    
}

function DrawCovers()
{
    local CoverInfo covinf;
    local Color Col;

    // End:0x53A
    foreach CachedCoverInfos(covinf)
    {
        // End:0x465
        if(covinf.Link.IsEnabled())
        {
            // End:0x113
            if(covinf.Link.Slots[covinf.SlotIdx].SlotOwner != none)
            {
                Col.R = 0;
                Col.G = 0;
                Col.B = 255;                
            }
            else
            {
                Col.R = 0;
                Col.G = 255;
                Col.B = 0;
            }
            DrawDebugBox(covinf.Link.GetSlotLocation(covinf.SlotIdx), vect(5.0000000, 5.0000000, 5.0000000), Col.R, Col.G, Col.B);
            DrawDebugBox(covinf.Link.GetSlotViewPoint(covinf.SlotIdx,, 7), vect(2.0000000, 2.0000000, 2.0000000), Col.R, Col.G, Col.B);
            DrawDebugBox(covinf.Link.GetSlotViewPoint(covinf.SlotIdx,, 8), vect(2.0000000, 2.0000000, 2.0000000), Col.R, Col.G, Col.B);
            DrawDebugBox(covinf.Link.GetSlotViewPoint(covinf.SlotIdx,, 9), vect(2.0000000, 2.0000000, 2.0000000), Col.R, Col.G, Col.B);            
        }
        else
        {
            Col.R = 255;
            DrawDebugSphere(covinf.Link.GetSlotLocation(covinf.SlotIdx), 20.0000000, 20, Col.R, Col.G, Col.B);
        }        
    }    
    //return;    
}

function DrawAIOverlays()
{
    local AIController B;
    local Vector pos;
    local float XL, YL;
    local string Text;

    Canvas.Font = GetFontSizeIndex(0);
    // End:0x4D4
    foreach WorldInfo.AllControllers(Class'Engine.AIController', B)
    {
        // End:0x4D3
        if(B.Pawn != none)
        {
            DrawRoute(B.Pawn);
            // End:0x4D3
            if((Vector(PlayerOwner.Rotation) Dot (B.Pawn.Location - PlayerOwner.ViewTarget.Location)) > 0.0000000)
            {
                pos = Canvas.Project(B.Pawn.Location + (B.Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.1000000)));
                Text = ((B.IsA('EvilAIController')) ? EvilAIController(B).GetDebugString() : ((B.IsA('EvilAI_Creature')) ? EvilAI_Creature(B).GetDebugString() : ""));
                Canvas.StrLen(Text, XL, YL);
                pos.X = FClamp(pos.X, 0.0000000, Canvas.ClipX - XL);
                pos.Y = FClamp(pos.Y, 0.0000000, Canvas.ClipY - YL);
                Canvas.SetPos(pos.X, pos.Y);
                Canvas.DrawColor = ConsoleColor;
                Canvas.DrawColor.A = ((LocalPlayer(PlayerOwner.Player).GetActorVisibility(B.Pawn)) ? 255 : 128);
                Canvas.DrawText(Text);
            }
        }        
    }    
    //return;    
}

function DrawRoute(Pawn Target)
{
    local EvilCreature EC;
    local float Extent;

    EC = EvilCreature(Target);
    Extent = 128.0000000;
    // End:0x2A7
    if(EC == none)
    {
        super(HUD).DrawRoute(Target);
        DrawDebugLine(Target.Location, Target.Location + (Vector(Target.Rotation) * Extent), 255, 255, 0);
        DrawDebugLine(Target.Location, Target.Location + (Vector(Target.DesiredRotation) * Extent), 0, 255, 0);
        DrawDebugLine(Target.Location, Target.Location + (Normal(Target.Velocity) * Extent), 0, 0, 255);
        // End:0x2A4
        if(Target.Mesh != none)
        {
            DrawDebugLine(Target.Location, Target.Location + (Target.Mesh.GetBoneAxis(Target.Mesh.GetBoneName(0), 1) * Extent), 255, 0, 255);
        }        
    }
    else
    {
        // End:0x31A
        if(!IsZero(EC.DesiredLocation))
        {
            DrawDebugLine(EC.Location, EC.DesiredLocation, 0, 0, 255);
        }
        DrawDebugLine(EC.Location, EC.Location + (Vector(EC.Rotation) * Extent), 0, 255, 0);
        DrawDebugLine(EC.Location, EC.Location + (Vector(EC.DesiredRotation) * Extent), 255, 0, 0);
        // End:0x4F0
        if(EC.IsA('EvilCreatureFlying'))
        {
            DrawDebugLine(EC.Location, EC.Location + (((EC.DesiredSpeed * Vector(EC.DesiredRotation)) * EvilCreatureFlying(EC).LookAheadInterval) * 0.5000000), 255, 255, 0);
        }
    }
    //return;    
}

defaultproperties
{
    HUDClass=Class'EvilGFxHud'
    bShowCursor=true
    bEnableActorOverlays=true
}