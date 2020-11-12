module.exports = {
    RequestToJson(request , callback){
        let body = ''
        request.on('data' , function (data){
            body += data
            if (body.length > 1e6){
                request.connection.destroy()
                callback(null)
            }
        })
        request.on('end' , ()=>{
            callback(JSON.parse(body))
        })
    }
}