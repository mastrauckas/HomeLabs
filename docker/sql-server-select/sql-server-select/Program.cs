using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

var builder = new ConfigurationBuilder()
     .AddJsonFile("appsettings.json")
     .AddUserSecrets<Program>()
     .AddEnvironmentVariables();

var configuration = builder.Build();

var connectionString = configuration.GetConnectionString("SqlConnectionString");
ArgumentNullException.ThrowIfNull(connectionString);

Console.WriteLine("About to query database.");

await using SqlConnection connection = new();
connection.ConnectionString = connectionString;
await connection.OpenAsync();
var message = $"This message is from {Environment.MachineName} by user {Environment.UserDomainName} & {Environment.UserName}";
var sqlCommand = "SELECT TOP 1 * FROM Logs ORDER BY Id DESC;";
SqlCommand command = new(sqlCommand, connection);
var reader = await command.ExecuteReaderAsync();

if (reader.Read())
{
    var id = reader.GetInt32(reader.GetOrdinal("Id"));
    var name = reader.GetString(reader.GetOrdinal("Message"));

    Console.WriteLine($"The most recent row is Id {id} and message {message}");

}

await connection.CloseAsync();

