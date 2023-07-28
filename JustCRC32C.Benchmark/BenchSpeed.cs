namespace Just_CRC32.Benchmark;

using BenchmarkDotNet.Attributes;
using BenchmarkDotNet.Engines;
using BenchmarkDotNet.Jobs;
using Force.Crc32;
using JustCRC32C;

public class ListWrapper
{
    public List<byte[]> Arrays { get; }
    private string _name;
    public ListWrapper(List<byte[]> arrays, string name)
    {
        Arrays = arrays;
        _name = name;
    }
    public override string ToString()
    {
        return _name;
    }
}

[SimpleJob(RunStrategy.Throughput, RuntimeMoniker.Net481)]
// [SimpleJob(RunStrategy.Throughput, RuntimeMoniker.Net80)]
public class BenchSpeed
{
    [ParamsSource(nameof(ValuesForA))]
    public ListWrapper Arrays = null!;

    public static IEnumerable<ListWrapper> ValuesForA()
    {
        var r = new Random();
        // var tinyArrays = new ListWrapper(new List<byte[]>(), "tiny arrays (4 - 250 bytes)");
        // for (int i = 4; i < 250; i++)
        // {
        //     tinyArrays.Arrays.Add(new byte[i]);
        //     r.NextBytes(tinyArrays.Arrays[i - 4]);
        // }
        // yield return tinyArrays;
        //
        // var smallish = new ListWrapper(new List<byte[]>(), "smallish arrays (1,000 - 25,000 bytes)");
        // for (int i = 1_000; i < 25_000; i+= 1_000)
        // {
        //     smallish.Arrays.Add(new byte[i]);
        //     r.NextBytes(smallish.Arrays[i / 1_000 - 1]);
        // }
        // yield return smallish;
        //
        // var smallArrays = new ListWrapper(new List<byte[]>(), "small arrays (10,000 - 250,000 bytes)");
        // for (int i = 10_000; i < 250_000; i+= 10_000)
        // {
        //     smallArrays.Arrays.Add(new byte[i]);
        //     r.NextBytes(smallArrays.Arrays[i / 10_000 - 1]);
        // }
        // yield return smallArrays;
        //
        // var smallmediumArrays = new ListWrapper(new List<byte[]>(), "smaller medium arrays (100,000 - 2,500,000 bytes)");
        // for (int i = 100_000; i < 2_500_000; i+= 100_000)
        // {
        //     smallmediumArrays.Arrays.Add(new byte[i]);
        //     r.NextBytes(smallmediumArrays.Arrays[i / 100_000 - 1]);
        // }
        // yield return smallmediumArrays;
        //
        // var mediumArrays = new ListWrapper(new List<byte[]>(), "medium arrays (1,000,000 - 25,000,000 bytes)");
        // for (int i = 1_000_000; i < 25_000_000; i+= 1_000_000)
        // {
        //     mediumArrays.Arrays.Add(new byte[i]);
        //     r.NextBytes(mediumArrays.Arrays[i / 1_000_000 - 1]);
        // }
        // yield return mediumArrays;
        
        var bigArrays = new List<byte[]>
        {
            new byte[0X7FFFFFC7 / 4],
            new byte[0X7FFFFFC7 / 2],
            new byte[0X7FFFFFC7    ]
        };
        r.NextBytes(bigArrays[0]);
        r.NextBytes(bigArrays[1]);
        r.NextBytes(bigArrays[2]);
        yield return new ListWrapper(bigArrays, "big arrays ("+0X7FFFFFC7 / 4 +" - "+0X7FFFFFC7+" bytes)");;
    }

    [Benchmark(Baseline = true)]
    public void JustCrc32C_HardwareX64()
    {
        foreach (byte[] bytes in Arrays.Arrays)
        {   
            Crc32C.CalculateHardwareX64(bytes);
        }
    }
    
    // [Benchmark]
    // public void JustCrc32C_Hardware()
    // {
    //     foreach (byte[] bytes in Arrays.Arrays)
    //     {   
    //         Crc32C.CalculateHardware(bytes);
    //     }
    // }
    //
    // [Benchmark]
    // public void JustCrc32C_Software()
    // {
    //     foreach (byte[] bytes in Arrays.Arrays)
    //     {   
    //         Crc32C.CalculateSoftware(bytes);
    //     }
    // }
    //
    // [Benchmark]
    // public void Crc32_dot_NET()
    // {
    //     foreach (byte[] bytes in Arrays.Arrays)
    //     {   
    //         Crc32CAlgorithm.Compute(bytes);
    //     }
    // }
}