# Connection Variables 
$user = 'b8816efb667a29' 
$pass = '41a0369b' 
$database = 'ad_ad9b6d4852ef174' 
$MySQLHost = 'us-cdbr-iron-east-04.cleardb.net' 

$conn = Connect-MySQL $user $pass $MySQLHost $database

function Connect-MySQL([string]$user,[string]$pass,[string]$MySQLHost,[string]$database) { 
  # Load MySQL .NET Connector Objects 
  [void][system.reflection.Assembly]::LoadWithPartialName("MySql.Data") 
 
  # Open Connection 
  $connStr = "server=" + $MySQLHost + ";port=3306;uid=" + $user + ";pwd=" + $pass + ";database="+$database+";Pooling=FALSE" 
  $conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connStr) 
  $conn.Open() 
  return $conn 
} 
 
function Disconnect-MySQL($conn) {
  $conn.Close()
}

function Execute-MySQLNonQuery($conn, [string]$query) { 
  $command = $conn.CreateCommand()                  # Create command object
  $command.CommandText = $query                     # Load query into object
  $RowsInserted = $command.ExecuteNonQuery()        # Execute command
  $command.Dispose()                                # Dispose of command object
  if ($RowsInserted) { 
    return $RowInserted 
  } else { 
    return $false 
  } 
} 
 
# So, to insert records into a table 
$query = "INSERT INTO computers (name) VALUES ('Hello')" 
$Rows = Execute-MySQLNonQuery $conn $query 
Write-Host $Rows " inserted into database"