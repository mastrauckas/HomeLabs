using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

var builder = new ConfigurationBuilder()
     .AddJsonFile("appsettings.json")
     .AddUserSecrets<Program>()
     .AddEnvironmentVariables();

var configuration = builder.Build();

var connectionString = configuration.GetConnectionString("SqlConnectionString");
ArgumentNullException.ThrowIfNull(connectionString);

Console.WriteLine("Inserting a row into the database.");

await using SqlConnection connection = new();
connection.ConnectionString = connectionString;
await connection.OpenAsync();
var message = $"This message is from {Environment.MachineName} by user {Environment.UserDomainName} & {Environment.UserName}";
var sqlCommand = $"INSERT INTO Logs(Message) VALUES('{message}');";
SqlCommand command = new(sqlCommand, connection);
var reader = await command.ExecuteNonQueryAsync();

Console.WriteLine("Inserting the row was successful.");

await connection.CloseAsync();

