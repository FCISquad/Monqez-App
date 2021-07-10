module.exports = {
    start(url){
        console.debug("*DEBUG", "++++++++++++++++++++++++++++++++");
        console.info("*INFO", "\t\tStart Request");
        console.info("*INFO", "\t\tURL: " + url + "\n");
    },

    end(){
        console.info("*INFO", "\t\tEnd Request");
        console.log("*DEBUG", "////////////////////////////////");
    },

    track(message){
        console.info("*INFO", "\t\tdebugger track: " + message);
    },

    error(err){
        console.error("*ERROR", "\t\t" + err + "\n");
    }
}