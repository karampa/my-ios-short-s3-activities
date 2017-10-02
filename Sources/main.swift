import Kitura
import LoggerAPI
import HeliumLogger
import Foundation
//import ActivitiesService
import MySQL

// Disable stdout buffering (so log will appear)
setbuf(stdout, nil)

//init logger
HeliumLogger.use(.info)

// Create connection string (Use env variables, if exists)
let env = ProcessInfo.processInfo.environment
var connectionString = MySQLConnectionString(host: "172.17.0.2")
connectionString.port = 3306
connectionString.user = "root"
connectionString.password = "password"
connectionString.database = "game_night"

// Create connection pool
var pool = MySQLConnectionPool(connectionString: connectionString, poolSize: 10, defaultCharset: "utf8mb4")

do {
    try pool.getConnection() { (connection: MySQLConnectionProtocol) in
        
        /*let result1 = try connection.execute(query: " SELECT * FROM activities")
        while case let row? = result1.nextResult() {
            print(row)
        }*/
        
        let result = try connection.execute(query: "INSERT INTO activities (name, genre, description, emoji, min_participants, max_participants) VALUES ('New Activity', 'Puzzle', 'A simple dummy game.', '🎲', '2', '4');")
        if result.affectedRows > 0 {
            Log.info("Activity inserted")
        } else {
            Log.info("Activity not inserted")
        }
    }
}
catch {
	Log.error(error.localizedDescription)
}

//add an HTTP server and connect to router
Kitura.addHTTPServer(onPort: 8080, with: Router())

// Start the kitura run loop 
Kitura.run()
