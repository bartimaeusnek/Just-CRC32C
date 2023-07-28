#if NETSTANDARD
namespace JustCRC32C;
using System.Runtime.InteropServices;
public static partial class Crc32C
{
    internal unsafe static uint CalculateHardwareX64(Span<byte> data)
    {
        fixed (byte* ptr = &data.GetPinnableReference())
            return (uint)CRC32_SSE42_Native_x64(ptr, data.Length);
    }
    internal unsafe static uint CalculateHardware(Span<byte> data)
    {
        fixed (byte* ptr = &data.GetPinnableReference())
            return CRC32_SSE42_Native_x86(ptr, data.Length);
    }
    
    static Crc32C()
    {
        bool isAnyWindows = (Environment.OSVersion.Platform == PlatformID.Win32NT || Environment.OSVersion.Platform == PlatformID.Win32Windows || Environment.OSVersion.Platform == PlatformID.WinCE);
        ToUse = RuntimeInformation.ProcessArchitecture switch
        {
            Architecture.X64 when !isAnyWindows || !HasSSE42_x64() => CalculateSoftware,
            Architecture.X64 => CalculateHardwareX64,
            Architecture.X86 when !isAnyWindows || !HasSSE42_x86() => CalculateSoftware,
            Architecture.X86 => CalculateHardware,
            _ => CalculateSoftware
        };
    }
    
    [DllImport("JustCRC32C_Native_x86.dll", CallingConvention = CallingConvention.StdCall)]
    internal extern static bool HasSSE42_x86();
    
    [DllImport("JustCRC32C_Native_x64.dll", CallingConvention = CallingConvention.StdCall)]
    internal extern static bool HasSSE42_x64();
    
    [DllImport("JustCRC32C_Native_x64.dll", CallingConvention = CallingConvention.StdCall)]
    internal extern unsafe static ulong CRC32_SSE42_Native_x64(byte* ptr, int ptr_length);

    [DllImport("JustCRC32C_Native_x86.dll", CallingConvention = CallingConvention.StdCall)]
    internal extern unsafe static uint CRC32_SSE42_Native_x86(byte* ptr, int ptr_length);
}
#endif