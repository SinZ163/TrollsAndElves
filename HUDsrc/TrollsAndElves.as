package  {
	
	import flash.display.MovieClip;
	
	import ValveLib.Globals;
    import ValveLib.ResizeManager;
	
	public class TrollsAndElves extends MovieClip {
		//Game API stuff
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		
		// These vars determain how much of the stage we can use
        // They are updated as the stage size changes
        public var maxStageWidth:Number = 1920;
        public var maxStageHeight:Number = 1080;
		
		public var lumberOverlay:LumberOverlay;
		public var lumberOverlay2:LumberOverlay;
		public var MapSelect:MovieClip;
		
		public function TrollsAndElves() {
			// constructor code
			// Note this DOES run for some reason.
			trace("##TrollsAndElves Hello World from the Constructor.");
		}
		
		public function onLoaded() : void {
			// constructor code
			// Note this doesn't run for some reason...
			trace("##TrollsAndElves Starting TrollsAndElves HUD");
			visible = true;
			
			//Resizing is blitz
			Globals.instance.resizeManager.AddListener(this);
			
			lumberOverlay2 = new LumberOverlay();
			addChild(lumberOverlay2);
			lumberOverlay2.visible = true;
			lumberOverlay2.x = 1703.35;
			lumberOverlay2.y = 919.35;
			lumberOverlay2.setLumber("9876");
			trace("## Set lumber to 9876");
		}
		
		public function onResize(re:ResizeManager) : * {
			// Update the stage width
			trace("### Resizing");
            maxStageWidth = re.ScreenWidth / re.ScreenHeight * 1080;

            // Scale hud up
            this.scaleX = re.ScreenWidth/maxStageWidth;
            this.scaleY = re.ScreenHeight/maxStageHeight;
		}
	}
	
}
