namespace JustCRC32C.TestNF
{
    using System;
    using System.Runtime.InteropServices;
    using JustCRC32C;
    using NUnit.Framework;

    [TestFixture]
    public class Tests
    {
        [Test]
        public unsafe void TestCorrectValueBig()
        {
            byte[] ba = new byte[1024];
            new Random().NextBytes(ba);
            uint c = Crc32C.CalculateSoftware(ba);
            switch (RuntimeInformation.ProcessArchitecture)
            {
                case Architecture.X64 when !Crc32C.HasSSE42_x64():
                    Assert.Ignore("SSE42 not supported!");
                    return;
                case Architecture.X64:
                {
                    uint a;
                    fixed (byte* ptrA = &ba[0])
                    {
                        a = (uint)Crc32C.CRC32_SSE42_Native_x64(ptrA, ba.Length);
                    }
              
                    Assert.That(a == c);
                    break;
                }
                case Architecture.X86 when !Crc32C.HasSSE42_x86():
                    Assert.Ignore("SSE42 not supported!");
                    return;
                case Architecture.X86:
                {
                    uint b;
                    fixed (byte* ptrA = &ba[0])
                    {
                        b = Crc32C.CRC32_SSE42_Native_x86(ptrA, ba.Length);
                    }
                    Assert.That(b == c);
                    break;
                }
                case Architecture.Arm:
                case Architecture.Arm64:
                default:
                    Assert.Ignore("CPU Architecture not supported!");
                    return;
            }
        }

        [Test]
        public unsafe void TestCorrectValueSmall()
        {
            const uint result = 3808858755;
            var aArray = new byte[] { 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39 };
            var bArray = new byte[] { 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39 };
            uint a;
            uint b;
            uint c = Crc32C.CalculateSoftware(new byte[] { 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39 });
            Assert.That(c == result);
            switch (RuntimeInformation.ProcessArchitecture)
            {
                case Architecture.X64 when !Crc32C.HasSSE42_x64():
                    Assert.Ignore("SSE42 not supported!");
                    return;
                case Architecture.X64:
                {
                    fixed (byte* ptrA = &aArray[0])
                        a = (uint)Crc32C.CRC32_SSE42_Native_x64(ptrA, aArray.Length);
                    Assert.That(a == c);
                    break;
                }
                case Architecture.X86 when !Crc32C.HasSSE42_x86():
                    Assert.Ignore("SSE42 not supported!");
                    return;
                case Architecture.X86:
                {
                    fixed (byte* ptrB = &bArray[0])
                        b = Crc32C.CRC32_SSE42_Native_x86(ptrB, aArray.Length);
                    Assert.That(b == c);
                    break;
                }
                case Architecture.Arm:
                case Architecture.Arm64:
                default:
                    Assert.Ignore("CPU Architecture not supported!");
                    return;
            }
        }
    }
}