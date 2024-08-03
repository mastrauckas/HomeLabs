using Microsoft.Extensions.Configuration;

var builder = new ConfigurationBuilder()
     .AddJsonFile("appsettings.json")
     .AddUserSecrets<Program>()
     .AddEnvironmentVariables();

var configuration = builder.Build();

var table = configuration.GetSection("Table").Get<Table>();

ArgumentNullException.ThrowIfNull(table);

Console.WriteLine($"Table name is: {table.TableName}.");

foreach (var foreignKeyTable in table.ForeignKeyTables)
{
    Console.WriteLine($"Foreign Key Table for {table.TableName}: {foreignKeyTable.TableName}.");
}

Console.WriteLine();

var virtueScriptConnectionString = configuration.GetConnectionString("VirtueScriptConnectionString");
var virtueScriptImportConnectionString = configuration.GetConnectionString("VirtueScriptImportConnectionString");
var appInsightsConnectionString = configuration.GetConnectionString("AppInsightsConnectionString");
var cosmosConnectionString = configuration.GetConnectionString("CosmosConnectionString");

Console.WriteLine($"VirtueScriptConnectionString: {virtueScriptConnectionString}.");
Console.WriteLine($"VirtueScriptImportConnectionString: {virtueScriptImportConnectionString}.");
Console.WriteLine($"AppInsightsConnectionString: {appInsightsConnectionString}.");
Console.WriteLine($"CosmosConnectionString: {cosmosConnectionString}.");

var howLongToSleepFor = configuration.GetValue<int>("HowLongToSleepForInSeconds");

Console.WriteLine($"Sleep for {howLongToSleepFor} seconds.");

Thread.Sleep(howLongToSleepFor * 1000);

Console.WriteLine($"Application is now ending.");

return;

public class ForeignKeyTable
{
    public required string TableName { get; set; }
}

public class Table
{
    public required string TableName { get; set; }
    public required List<ForeignKeyTable> ForeignKeyTables { get; set; }

}