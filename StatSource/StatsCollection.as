package  {
	
	import flash.display.MovieClip;
	import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
	
    public class StatsCollection extends MovieClip {
        public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		
		var sock:Socket;
		var json:String;
		
		var SERVER_ADDRESS:String = "176.31.182.87";
		var SERVER_PORT:Number = 4444;
		
        public function onLoaded() : void {
			trace("##Loading StatsCollection by SinZ");
			gameAPI.SubscribeToGameEvent("stat_collection", this.statCollect);
        }
		public function socketConnect(e:Event) {
			// We have connected successfully!
            trace('Connected to the server!');

            // Hook the data connection
            //sock.addEventListener(ProgressEvent.SOCKET_DATA, socketData);
			var buff:ByteArray = new ByteArray();
			writeString(buff, json + "\n");
			sock.writeBytes(buff, 0, buff.length);
            sock.flush();
		}
		private static function writeString(buff:ByteArray, write:String){
			trace("Message: "+write);
			trace("Length: "+write.length);
            buff.writeUTF(write);
            for(var i = 0; i < write.length; i++){
                buff.writeByte(0);
            }
        }
		public function statCollect(args:Object) {
			trace("##STATS Received data from server");
			delete args.splitscreenplayer;
			json = args.json;
			
			sock = new Socket();
			sock.timeout = 10000; //10 seconds is fair..
			// Setup socket event handlers
			sock.addEventListener(Event.CONNECT, socketConnect);
			
			try {
				// Connect
				sock.connect(SERVER_ADDRESS, SERVER_PORT);
			} catch (e:Error) {
				// Oh shit, there was an error
				trace("##STATS Failed to connect!");

				// Return failure
				return false;
			}
		}
    }
}