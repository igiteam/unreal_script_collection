class MOHAGameEngine extends GameEngine
    transient
    native
    config(Engine);

// Export UMOHAGameEngine::execIsDemo(FFrame&, void* const)
native static function bool IsDemo();
