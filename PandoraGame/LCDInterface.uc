class LCDInterface extends Object
    native;

//var delegate<OnSoftKeyPressed> __OnSoftKeyPressed__Delegate;

delegate OnSoftKeyPressed(int Id)
{
    //return;    
}

// Export ULCDInterface::execGetSoftKeyPressedDelegate(FFrame&, void* const)
private native static final function GetSoftKeyPressedDelegate(out delegate<OnSoftKeyPressed> SoftKeyPressed);

// Export ULCDInterface::execAddOnSoftKeyPressedDelegate(FFrame&, void* const)
native static function AddOnSoftKeyPressedDelegate(delegate<OnSoftKeyPressed> SoftKeyPressed);

// Export ULCDInterface::execInitLCD(FFrame&, void* const)
native static function bool InitLCD(string AppName);

// Export ULCDInterface::execShutdownLCD(FFrame&, void* const)
native static function ShutdownLCD();

// Export ULCDInterface::execLoadLCDResource(FFrame&, void* const)
native static function int LoadLCDResource(string Filename);

// Export ULCDInterface::execFreeLCDResource(FFrame&, void* const)
native static function FreeLCDResource(int Id);

// Export ULCDInterface::execBlt(FFrame&, void* const)
native static function Blt(int SrcId, int X, int Y);

// Export ULCDInterface::execBltScale(FFrame&, void* const)
native static function BltScale(int SrcId, int SrcX, int SrcY, int SrcX2, int SrcY2, int DestX, int DestY, int DestX2, int DestY2);

// Export ULCDInterface::execAllocUserLCDBuffer(FFrame&, void* const)
native static function int AllocUserLCDBuffer(int Width, int Height);

// Export ULCDInterface::execUsrBltScale(FFrame&, void* const)
native static function UsrBltScale(int SrcId, int SrcX, int SrcY, int SrcX2, int SrcY2, int DestId, int DestX, int DestY, int DestX2, int DestY2);

// Export ULCDInterface::execRegisterFont(FFrame&, void* const)
native static function int RegisterFont(int Id, int GlyphWidth, int GlyphHeight);

// Export ULCDInterface::execSetFontScale(FFrame&, void* const)
native static function SetFontScale(int Width, int Height);

// Export ULCDInterface::execRenderText(FFrame&, void* const)
native static function RenderText(int FontId, int X, int Y, string Text);

// Export ULCDInterface::execUsrRenderText(FFrame&, void* const)
native static function UsrRenderText(int FontId, int ResId, int X, int Y, string Text);

// Export ULCDInterface::execLCDUpdate(FFrame&, void* const)
native static function LCDUpdate();

// Export ULCDInterface::execLCDClear(FFrame&, void* const)
native static function LCDClear();

// Export ULCDInterface::execUsrLCDClear(FFrame&, void* const)
native static function UsrLCDClear(int ResId);

// Export ULCDInterface::execLCDFlushResources(FFrame&, void* const)
native static function LCDFlushResources();

// Export ULCDInterface::execLCDForceForeground(FFrame&, void* const)
native static function LCDForceForeground();

// Export ULCDInterface::execLCDUseBltTransparency(FFrame&, void* const)
native static function LCDUseBltTransparency(bool bEnabled);

event SoftKeyPressed(int Id)
{
    local delegate<OnSoftKeyPressed> KeyPressedDelegate;

    GetSoftKeyPressedDelegate(KeyPressedDelegate);
    // End:0x2A
    if(KeyPressedDelegate != none)
    {
        OnSoftKeyPressed(Id);
    }
    //return;    
}
