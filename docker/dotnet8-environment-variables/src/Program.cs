using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

var builder = new ConfigurationBuilder()
     .AddJsonFile("appsettings.json")
     .AddUserSecrets<Program>()
     .AddEnvironmentVariables();

var configuration = builder.Build();

using var loggerFactory = LoggerFactory
    .Create(builder =>
    {
        builder.AddConfiguration(configuration.GetSection("Logging"));
        builder.AddConsole();
    });

var table = configuration.GetSection("Table").Get<Table>();

ArgumentNullException.ThrowIfNull(table);

Console.WriteLine($"Table name is: {table.TableName}.");

foreach (var foreignKeyTable in table.ForeignKeyTables)
{
    Console.WriteLine($"Foreign Key Table for {table.TableName}: {foreignKeyTable.TableName}.");
}

Console.WriteLine();

var sqlServerConnectionString = configuration.GetConnectionString("SqlServerConnectionString");
var appInsightsConnectionString = configuration.GetConnectionString("AppInsightsConnectionString");
var cosmosConnectionString = configuration.GetConnectionString("CosmosConnectionString");

Console.WriteLine($"SqlServerConnectionString: {sqlServerConnectionString}.");
Console.WriteLine($"AppInsightsConnectionString: {appInsightsConnectionString}.");
Console.WriteLine($"CosmosConnectionString: {cosmosConnectionString}.");

var howLongToSleepFor = configuration.GetValue<int>("HowLongToSleepForInSeconds");

var logger = loggerFactory.CreateLogger<Program>();

logger.LogDebug("This is a Debug message.");
logger.LogInformation("This is a Information message.");
logger.LogWarning("This is a Warning message.");
logger.LogError("This is a Error message.");
logger.LogCritical("This is a Critical message.");

Console.WriteLine($"Sleep for {howLongToSleepFor} seconds.");

Thread.Sleep(howLongToSleepFor * 1000);

Console.WriteLine($"Application is now ending.");

return;

public record struct ForeignKeyTable
{
    public required string TableName { get; set; }
}

public record struct Table
{
    public required string TableName { get; set; }
    public required List<ForeignKeyTable> ForeignKeyTables { get; set; }

}