package buildings {
	
	import flash.display.MovieClip;
	import scaleform.clik.events.SliderEvent;
	
    import flash.utils.getDefinitionByName;
	
	public class TownHall extends MovieClip {
		
		private var  left16by9X = 780;
		private var right16by9X = 780;
		
		private var  left16by10X = 780;
		private var right16by10X = 780;
		
		private var  left4by3X = 780;
		private var right4by3X = 780;
		
		private var  res16by9Y = 952;
		private var res16by10Y = 952;
		private var   res4by3Y = 952;
		
		public var slidingBar;
		public var buyText;
		public var sellText;
		public var sliderValue;
		
		public function TownHall() {
			this.x = 10;
			this.y = 10;
			
			var newSlider = hookAndReplace(slidingBar, "Slider_New", SliderEvent.VALUE_CHANGE, onSliderChanged);
			newSlider.maximum = 1000;
			newSlider.minimum = 1;
			newSlider.value = 10;
			newSlider.snapInterval = 1;
		}
		public function onSliderChanged(sliderInfo:SliderEvent): void {
			sliderValue.text = int(sliderInfo.value);
		}
		public function onScreenResize(scale:int, left:Boolean) : void {
			trace("##LumberOverlay getting ready to resize");
			switch(scale) {
				case 0:
					//16by9
					trace("##LumberOverlay setting position for 16by9 resolutions");
					if (left) {
						this.x = left16by9X; //I have no actual idea where this should be.
					} else {
						this.x = right16by9X;
					}
					this.y = res16by9Y;
					break;
				case 1:
					//16by10
					trace("##LumberOverlay setting position for 16by10 resolutions");
					if (left) {
						this.x = left16by10X; //I have no actual idea where this should be.
					} else {
						this.x = right16by10X;
					}
					this.y = res16by10Y;
					break;
				case 2:
					//4by3
					trace("##LumberOverlay setting position for 16by9 resolutions");
					if (left) {
						this.x = left4by3X; //I have no actual idea where this should be.
					} else {
						this.x = right4by3X;
					}
					this.y = res4by3Y;
					break;
			}
		}
		
		public function hookAndReplace(btn:MovieClip, type:String, eventType:String, func:Function) : MovieClip {
			var parent = btn.parent;
			var oldx = btn.x;
			var oldy = btn.y;
			var oldwidth = btn.width;
			var oldheight = btn.height;
			
			var newObjectClass = getDefinitionByName(type);
			var newObject = new newObjectClass();
			newObject.x = oldx;
			newObject.y = oldy;
			newObject.width = oldwidth;
			newObject.height = oldheight;
			
			parent.removeChild(btn);
			parent.addChild(newObject);
			
			newObject.addEventListener(eventType, func);
			
			return newObject;
		}
	}
	
}
