package  {
	
	//PrintTable
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.display.MovieClip;
	//Rest of the script
	import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
	import com.adobe.serialization.json.JSONEncoder;
	
    public class StatsCollection {
		public var gameAPI:Object;
		public var globals:Object;
		
		var sock:Socket;
		var json:String;
		
		var SERVER_ADDRESS:String = "176.31.182.87";
		var SERVER_PORT:Number = 4444;
		
        public function StatsCollection(gameAPI, globals) {
			this.gameAPI = gameAPI;
			this.globals = globals;
			trace("Setting event");
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
			trace("Received data from server");
			PrintTable(args);
			if (globals.Players.GetLocalPlayer() == args.pid) {
				trace("Correct player");
				delete args.pid;
				delete args.splitscreenplayer;
				json = new JSONEncoder( args ).getString();
				
				sock = new Socket();
			    // Setup socket event handlers
				sock.addEventListener(Event.CONNECT, socketConnect);
				
				try {
					// Connect
					sock.connect(SERVER_ADDRESS, SERVER_PORT);
				} catch (e:Error) {
					// Oh shit, there was an error
					trace("Failed to connect!");
	
					// Return failure
					return false;
				}
				//var msg:String = "";
				//for(var key in args) {
				//	msg = msg + ";;" + key + "||" + args[key];
				//}
				//request.method = URLRequestMethod.POST;
			}
		}
		
		// Shamelessly stolen from Frota
        public function strRep(str, count) {
            var output = "";
            for(var i=0; i<count; i++) {
                output = output + str;
            }

            return output;
        }

        public function isPrintable(t) {
        	if(t == null || t is Number || t is String || t is Boolean || t is Function || t is Array) {
        		return true;
        	}
        	// Check for vectors
        	if(getQualifiedClassName(t).indexOf('__AS3__.vec::Vector') == 0) return true;

        	return false;
        }

        public function PrintTable(t, indent=0, done=null) {
        	var i:int, key, key1, v:*;

        	// Validate input
        	if(isPrintable(t)) {
        		trace("PrintTable called with incorrect arguments!");
        		return;
        	}

        	if(indent == 0) {
        		trace(t.name+" "+t+": {")
        	}

        	// Stop loops
        	done ||= new Dictionary(true);
        	if(done[t]) {
        		trace(strRep("\t", indent)+"<loop object> "+t);
        		return;
        	}
        	done[t] = true;

        	// Grab this class
        	var thisClass = getQualifiedClassName(t);

        	// Print methods
			for each(key1 in describeType(t)..method) {
				// Check if this is part of our class
				if(key1.@declaredBy == thisClass) {
					// Yes, log it
					trace(strRep("\t", indent+1)+key1.@name+"()");
				}
			}

			// Check for text
			if("text" in t) {
				trace(strRep("\t", indent+1)+"text: "+t.text);
			}

			// Print variables
			for each(key1 in describeType(t)..variable) {
				key = key1.@name;
				v = t[key];

				// Check if we can print it in one line
				if(isPrintable(v)) {
					trace(strRep("\t", indent+1)+key+": "+v);
				} else {
					// Open bracket
					trace(strRep("\t", indent+1)+key+": {");

					// Recurse!
					PrintTable(v, indent+1, done)

					// Close bracket
					trace(strRep("\t", indent+1)+"}");
				}
			}

			// Find other keys
			for(key in t) {
				v = t[key];

				// Check if we can print it in one line
				if(isPrintable(v)) {
					trace(strRep("\t", indent+1)+key+": "+v);
				} else {
					// Open bracket
					trace(strRep("\t", indent+1)+key+": {");

					// Recurse!
					PrintTable(v, indent+1, done)

					// Close bracket
					trace(strRep("\t", indent+1)+"}");
				}
        	}

        	// Get children
        	if(t is MovieClip) {
        		// Loop over children
	        	for(i = 0; i < t.numChildren; i++) {
	        		// Open bracket
					trace(strRep("\t", indent+1)+t.name+" "+t+": {");

					// Recurse!
	        		PrintTable(t.getChildAt(i), indent+1, done);

	        		// Close bracket
					trace(strRep("\t", indent+1)+"}");
	        	}
        	}

        	// Close bracket
        	if(indent == 0) {
        		trace("}");
        	}
        }
    }
}