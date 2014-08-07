package buildings {
	
	import flash.display.MovieClip;
	
	
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
		
		public function TownHall() {
			this.x = 10;
			this.y = 10;
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
	}
	
}
