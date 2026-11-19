class AdvInventoryItem_Notepad extends AdvInventoryItem_Base
    config(Weapon)
    hidecategories(Navigation);

var() MaterialInstanceConstant MapMIC;
var() MapNote CurrentMapNote;
var() MapNote NextMapNote;
var() EvilPlayerController EvilPC;
var() EvilPawn EvilP;
var transient bool bQuickHideForMapSwitch;

simulated function SetCurrentMapNote(AdvMapNotes.EMapNote Id, optional bool bVerbose = false)
{
    local MapNote NewMapNote;
    local EvilPlayer_interface EPI;
    local AdvMapInfo MapInfo;

    MapInfo = AdvMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
    // End:0x30A
    if(MapInfo != none)
    {
        NewMapNote = Class'AdvMapNotes'.static.FindMapNote(Id, MapInfo.MapNotes);
        // End:0x145
        if(((Instigator.WeaponLeft == self) && int(NewMapNote.MapNoteID) != int(CurrentMapNote.MapNoteID)) && DoQuickHide())
        {
            bQuickHideForMapSwitch = true;
            NextMapNote = NewMapNote;            
        }
        else
        {
            // End:0x30A
            if(int(NewMapNote.MapNoteID) != int(CurrentMapNote.MapNoteID))
            {
                CurrentMapNote = NewMapNote;
                EPI = EvilPlayer_interface(Instigator);
                // End:0x300
                if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)) && !bVerbose)
                {
                    AdvGFxHud(EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie).ShowGameplayIndicator(1);
                    AdvGFxHud(EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie).LastGameplayIndicatorShowTime = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
                }
                UpdateTexture();
            }
        }
    }
    //return;    
}

simulated function AddNewNote(AdvMapNotes.EMapNote Id)
{
    local MapNote NewMapNote;
    local EvilPlayer_interface EPI;
    local AdvMapInfo MapInfo;
    local int I;

    MapInfo = AdvMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
    // End:0x46C
    if(MapInfo != none)
    {
        I = 0;
        J0x62:

        // End:0x1BE [Loop If]
        if(I < MapInfo.MapNotes.Length)
        {
            // End:0x1B0
            if(int(MapInfo.MapNotes[I].MapNoteID) == int(Id))
            {
                MapInfo.MapNotes[I].bMapNoteAvailable = true;
                MapInfo.MapNotes.InsertItem(MapInfo.MapNotes.Length, MapInfo.MapNotes[I]);                
                MapInfo.MapNotes.Remove(I, 0);                
                // [Explicit Break]
                goto J0x1BE;
            }
            I++;
            // [Loop Continue]
            goto J0x62;
        }
        J0x1BE:

        NewMapNote = MapInfo.MapNotes[MapInfo.MapNotes.Length - 1];
        // End:0x46C
        if(IsMapNoteAvailable(NewMapNote))
        {
            // End:0x2B8
            if(((Instigator.WeaponLeft == self) && int(NewMapNote.MapNoteID) != int(CurrentMapNote.MapNoteID)) && DoQuickHide())
            {
                bQuickHideForMapSwitch = true;
                NextMapNote = NewMapNote;                
            }
            else
            {
                // End:0x46C
                if(int(NewMapNote.MapNoteID) != int(CurrentMapNote.MapNoteID))
                {
                    CurrentMapNote = NewMapNote;
                    EPI = EvilPlayer_interface(Instigator);
                    // End:0x462
                    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
                    {
                        AdvGFxHud(EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie).ShowGameplayIndicator(1);
                        AdvGFxHud(EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie).LastGameplayIndicatorShowTime = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
                    }
                    UpdateTexture();
                }
            }
        }
    }
    //return;    
}

private final simulated function UpdateTexture()
{
    MapMIC = Mesh.CreateAndSetMaterialInstanceConstant(2);
    // End:0xCE
    if(int(ADVGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).GetDifficultyIdx()) == 2)
    {
        MapMIC.SetTextureParameterValue('Map', CurrentMapNote.HardMapNoteTexture);        
    }
    else
    {
        MapMIC.SetTextureParameterValue('Map', CurrentMapNote.NormalMapNoteTexture);
    }
    //return;    
}

private final simulated function bool IsMapNoteAvailable(MapNote Note)
{
    // End:0xD4
    if(Note.bMapNoteAvailable)
    {
        // End:0xA8
        if(int(ADVGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).GetDifficultyIdx()) == 2)
        {
            // End:0xA3
            if(Note.HardMapNoteTexture != none)
            {
                return true;                
            }
            else
            {
                return false;
            }            
        }
        else
        {
            // End:0xCF
            if(Note.NormalMapNoteTexture != none)
            {
                return true;                
            }
            else
            {
                return false;
            }
        }        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function TurnPage(AdvTypes.EInventoryItem ChangePageDirection)
{
    local MapNote NewMapNote;
    local int I;
    local AdvMapInfo MapInfo;

    MapInfo = AdvMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
    // End:0x373
    if((MapInfo != none) && MapInfo.MapNotes.Length > 0)
    {
        NewMapNote = CurrentMapNote;
        // End:0x19B
        if(int(ChangePageDirection) == int(4))
        {
            I = MapInfo.MapNotes.Length - 1;
            J0xD1:

            // End:0x198 [Loop If]
            if(I >= 0)
            {
                // End:0x123
                if(MapInfo.MapNotes[I] == CurrentMapNote)
                {
                    // [Explicit Break]
                    goto J0x198;                    
                }
                else
                {
                    // End:0x18A
                    if(IsMapNoteAvailable(MapInfo.MapNotes[I]))
                    {
                        NewMapNote = MapInfo.MapNotes[I];
                    }
                }
                --I;
                // [Loop Continue]
                goto J0xD1;
            }
            J0x198:
            
        }
        else
        {
            // End:0x29F
            if(int(ChangePageDirection) == int(3))
            {
                I = 0;
                J0x1BA:

                // End:0x29F [Loop If]
                if(I < MapInfo.MapNotes.Length)
                {
                    // End:0x22A
                    if(MapInfo.MapNotes[I] == CurrentMapNote)
                    {
                        // [Explicit Break]
                        goto J0x29F;                        
                    }
                    else
                    {
                        // End:0x291
                        if(IsMapNoteAvailable(MapInfo.MapNotes[I]))
                        {
                            NewMapNote = MapInfo.MapNotes[I];
                        }
                    }
                    ++I;
                    // [Loop Continue]
                    goto J0x1BA;
                }
            }
        }
        J0x29F:

        // End:0x373
        if(NewMapNote != CurrentMapNote)
        {
            // End:0x356
            if(((Instigator.WeaponLeft == self) && int(NewMapNote.MapNoteID) != int(CurrentMapNote.MapNoteID)) && DoQuickHide())
            {
                bQuickHideForMapSwitch = true;
                NextMapNote = NewMapNote;                
            }
            else
            {
                CurrentMapNote = NewMapNote;
                UpdateTexture();
            }
        }
    }
    //return;    
}

function CreateCheckpointRecord(out InventoryRecord Record)
{
    super(EvilWeap_Base).CreateCheckpointRecord(Record);
    Record.CustomData = 0;
    // End:0x93
    if(int(CurrentMapNote.MapNoteID) != int(0))
    {
        Record.CustomData = int(CurrentMapNote.MapNoteID);
    }
    //return;    
}

function ApplyCheckpointRecord(const out InventoryRecord Record)
{
    super(EvilWeap_Base).ApplyCheckpointRecord(Record);
    // End:0x5E
    if(Record.CustomData != 0)
    {
        SetCurrentMapNote(byte(Record.CustomData), true);
    }
    //return;    
}

simulated event Destroyed()
{
    local EvilPlayer_interface EPI;

    EPI = EvilPlayer_interface(Instigator);
    // End:0x131
    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        // End:0x131
        if((EPI.GetPC() != none) && EPI.GetPC().myHUD != none)
        {
            EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie.ShowNotepadHints(false, ((CurrentMapNote.MapNoteHintLocKey != "") ? true : false));
        }
    }
    super(EvilWeap_Base).Destroyed();
    //return;    
}

simulated state QuickHide
{
    ignores TurnPage;

    simulated function DoneQuickHide()
    {
        super.DoneQuickHide();
        // End:0x5F
        if(bQuickHideForMapSwitch)
        {
            CurrentMapNote = NextMapNote;
            UpdateTexture();
            ClearTimer('DoneQuickHide');
            bQuickHideForMapSwitch = false;
            EndQuickHide();
        }
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    ignores TurnPage;

    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayer_interface EPI;
        local string MapHintText;

        super.BeginState(PreviousStateName);
        UpdateTexture();
        EPI = EvilPlayer_interface(Instigator);
        // End:0x137
        if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
        {
            // End:0xC3
            if(CurrentMapNote.MapNoteHintLocKey != "")
            {
                MapHintText = Localize("NotepadHints", CurrentMapNote.MapNoteHintLocKey, "ADVGame");
            }
            EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie.ShowNotepadHints(true,, MapHintText);
        }
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    ignores TurnPage;

    simulated function EndState(name NextStateName)
    {
        local EvilPlayer_interface EPI;

        EPI = EvilPlayer_interface(Instigator);
        // End:0xCE
        if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
        {
            EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie.ShowNotepadHints(false, ((CurrentMapNote.MapNoteHintLocKey != "") ? true : false));
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    ControlDOFWhenOffhand=true
    ZoomedCrosshair=true
    UsesOffhand=true
    OffHandDoesNotFire=true
    // Reference: ForceFeedbackWaveform'Default__AdvInventoryItem_Notepad.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=68
    ZoomedMeshTranslation=(X=-9.0000000,Y=12.0000000,Z=2.0000000)
    ZoomedMeshScale=1.3000000
    DOF_FocusDistance=30.0000000
    ZoomedWeaponIdleAnims=/* Array type was not detected. */
    ZoomedWeaponFireAnim=/* Array type was not detected. */
    ZoomedArmIdleAnims=/* Array type was not detected. */
    ZoomedArmFireAnim=/* Array type was not detected. */
    ZoomedMovementSpeedModifier=0.6000000
    ArmsAnimSet=AnimSet'wp_notepad_01.Anim.as_wp_notepad_hands'
    // Reference: AudioComponent'Default__AdvInventoryItem_Notepad.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    WeaponCrouchStartAnim="WeaponCrouchStart"
    ArmCrouchStartAnim="WeaponCrouchStart"
    WeaponCrouchEndAnim="WeaponStandStart"
    ArmCrouchEndAnim="WeaponStandStart"
    WeaponJumpStartAnim="WeaponJumpStart"
    ArmJumpStartAnim="WeaponJumpStart"
    WeaponJumpFlyAnim="WeaponJumpFall"
    ArmJumpFlyAnim="WeaponJumpFall"
    WeaponJumpLandAnim="WeaponJumpLanding"
    ArmJumpLandAnim="WeaponJumpLanding"
    CrouchStartCameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CrouchStart'
    CrouchEndCameraAnim=CameraAnim'an_CameraAnims.Anim.CA_StandStart'
    WeaponPutDownSnd=SoundCue'a_Notes.cues.a_NotesHide'
    WeaponEquipSnd=SoundCue'a_Notes.cues.a_NotesDrag'
    WeaponQuickEquipSnd=SoundCue'a_Notes.cues.a_NotesDrag'
    // Reference: DynamicLightEnvironmentComponent'Default__AdvInventoryItem_Notepad.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Notes"
    PlayerViewOffset=(X=20.0000000,Y=3.0000000,Z=-10.0000000)
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvInventoryItem_Notepad.FirstPersonMesh'
    begin object name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'wp_notepad_01.Mesh.sk_wp_notepad_01'
        AnimTreeTemplate=AnimTree'wp_notepad_01.Anim.at_wp_notepad_01'
        AnimSets[0]=AnimSet'wp_notepad_01.Anim.as_wp_notepad_01'
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    ItemName="Notes"
    // Reference: SkeletalMeshComponent'Default__AdvInventoryItem_Notepad.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}