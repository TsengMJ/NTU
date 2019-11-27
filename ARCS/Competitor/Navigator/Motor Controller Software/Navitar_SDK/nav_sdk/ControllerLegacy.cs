using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.IO.Ports;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.InteropServices;

namespace Navitar
{
    /// <summary>
    /// Legacy (1st generation) controller design, using binary communications.
    /// This controller class support the 1st generation 5-phase, 2-phase, servo
    /// and LED controllers.
    /// </summary>
    public class ControllerLegacy : Controller
    {
        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="portName">Name of COM or USB virtual COM port to which controller is connected.</param>
        public ControllerLegacy(string portName)
            : base(portName)
        {
            Generation = 1;
            Disposed = false;
        }

        /// <summary>
        /// Connect to the controller.
        /// </summary>
        public override void Connect() 
        {
            // Create and open the port
            Port = new SerialPort(PortName, 38400);
            Port.Open();

            ProductID = Read(Controller.regProductId);
            ProductSubclass = Read(Controller.regProductIdSubclass);

            if (ProductID == 0x4000)
            {
                Name = "LED";
            }
            else if (ProductID == 0x4001)
            {
                switch (ProductSubclass)
                {
                    case 1:
                    case (unchecked ((int)0xffffffd9)):
                        Name = "2-Phase";
                        break;
                    case 2:
                        Name = "5-Phase";
                        break;
                    case 3:
                        Name = "Servo";
                        break;
                    default:
                        throw new Exception("Unrecognized product subclass");
                }
            }
            else
            {
                throw new Exception("Unrecognized product ID");
            }
        }

        /// <summary>
        /// True if a connection has been established via a successful call to Connect(),
        /// false otherwise, and false after a call to Disconnect().
        /// </summary>
        public override bool Connected 
        {
            get { return (Port != null && Port.IsOpen) ? true : false; }
            protected set { }
        }

        /// <summary>
        /// Disconnect from the controller.
        /// </summary>
        public override void Disconnect() 
        {
            if (Port != null)
            {
                // Close and destroy the port
                Port.Close();
                Port.Dispose();
                Port = null;
            }
        }

        /// <summary>
        /// Override from Controller class.  Disconnects the controller, freeing the
        /// COM port for use by other programs.
        /// </summary>
        public override void Dispose()
        {
            if (!Disposed)
            {
                Disconnect();
                Disposed = true;
            }
        }

        /// <summary>
        /// Keep track of whether Dispose() method has been called.
        /// </summary>
        private bool Disposed { get; set; }

        /// <summary>
        /// The message Packet structure.  All legacy communicaton consists of messages
        /// of this structure.
        /// </summary>
        [Serializable]
        private class Packet
        {
            [MarshalAs(UnmanagedType.U1)]
            public Byte flag;
            [MarshalAs(UnmanagedType.U1)]
            public Byte regNumber;
            [MarshalAs(UnmanagedType.I4)]
            public Int32 value;
            [MarshalAs(UnmanagedType.U1)]
            public Byte checksum;
        }

        /// <summary>
        /// This method first completes the Packet by computing and appending the checksum
        /// to the Packet.  Then, the complete Packet is serialized and returned.
        /// </summary>
        /// <param name="packet">Packet to be serialized</param>
        /// <returns>Array of Bytes containing the serialized Packet</returns>
        private Byte[] SerializePacket(Packet packet)
        {
            Byte[] buffer = new Byte[7];
            buffer[0] = packet.flag;
            buffer[1] = packet.regNumber;
            buffer[5] = (Byte)((packet.value >> 24) & 0xFF);
            buffer[4] = (Byte)((packet.value >> 16) & 0xFF);
            buffer[3] = (Byte)((packet.value >> 8) & 0xFF);
            buffer[2] = (Byte)(packet.value & 0xFF);

            int sum = 0;
            for (int index = 0; index < 7; ++index)
            {
                sum += buffer[index];
            }
            packet.checksum = Convert.ToByte(-sum & 0xff);

            buffer[6] = packet.checksum;

            return buffer;
        }

        /// <summary>
        /// Deserializes the Bytes in the supplied buffer and returns a Packet.
        /// </summary>
        /// <param name="buffer">Array of Bytes containing the serialized Packet</param>
        /// <returns>The deserialized Packet</returns>
        private Packet DeserializePacket(Byte[] buffer)
        {
            Packet packet = new Packet();
            packet.flag = buffer[0];
            packet.regNumber = buffer[1];

            packet.value = buffer[5];
            packet.value *= 256;
            packet.value += buffer[4];
            packet.value *= 256;
            packet.value += buffer[3];
            packet.value *= 256;
            packet.value += buffer[2];

            packet.checksum = buffer[6];

            // Verify received checksum.
            int sum = 0;
            for (int index = 0; index < 6; ++index)
            {
                sum += buffer[index];
            }
            if (packet.checksum != Convert.ToByte(-sum & 0xff))
            {
                throw new Exception("checksum error in received Byte stream");
            }

            return packet;
        }

        /// <summary>
        /// Read a a Byte stream of the specified length from the connection.
        /// This method will eventually throw if it cannot read the requested
        /// number of bytes after a reasonable effort.
        /// </summary>
        /// <param name="length">Number of Bytes to read</param>
        /// <returns>Array containing the received bytes</returns>
        private Byte[] ReadPacketStream(int length)
        {
            int received = 0;
            int attempts = 0;
            Byte[] buffer = new Byte[length];
            while (attempts < 50)
            {
                attempts++;
                int bytesToRead = Math.Min(length - received, Port.BytesToRead);
                if (bytesToRead > 0)
                {
                    received += Port.Read(buffer, received, bytesToRead);
                }

                if (received == length)
                {
                    // Success.  Return what we received.
                    return buffer;
                }
                else
                {
                    // Allow some time for controller to catch up
                    System.Threading.Thread.Sleep(20);
                }
            }

            // We tried our best, now, sadly, we give up.
            Disconnect();
            throw new Exception("Failed to read response!");
        }

        /// <summary>
        /// Read and discard all pending received Bytes on the connection.
        /// </summary>
        private void FlushConnection()
        {
            int byteCount;
            while ((byteCount = Port.BytesToRead) > 0)
            {
                Byte[] buffer = new Byte[byteCount];
                Port.Read(buffer, 0, byteCount);
            }
        }

        /// <summary>
        /// Write a value to a controller register.
        /// </summary>
        /// <param name="register">a valid register address for the connected controller</param>
        /// <param name="value">the value to be written to the register</param>
        public override void Write(uint register, int value) 
        {
            lock (Port)
            {
                // Sanity check the register address.  There is no checking of the value.
                if (register > 0xff)
                {
                    throw new Exception("Illegal register value for legacy binary controller.");
                }

                // Create write command Packet
                Packet outPacket = new Packet();
                outPacket.flag = 0xff;
                //outPacket.regNumber = Convert.ToByte(register);
                outPacket.regNumber = (Byte)(register & 0xFF);
                outPacket.regNumber |= 0x80;
                outPacket.value = value;

                // Serialize Packet to Byte stream
                Byte[] outBuffer = SerializePacket(outPacket);

                // Send the message
                Port.Write(outBuffer, 0, outBuffer.Length);

                try
                {
                    // Fetch (but discard) the response.
                    ReadPacketStream(7);
                }
                catch (Exception ex)
                {
                    FlushConnection();
                    throw ex;
                }
            }
        }

        /// <summary>
        /// Read a value from a controller register.
        /// </summary>
        /// <param name="register">a valid register address for the connected controller</param>
        /// <returns>the current register value</returns>
        public override int Read(uint register) 
        {
            lock (Port)
            {
                // Sanity check the register address
                if (register > 0xff)
                {
                    throw new Exception("Illegal register value for legacy binary controller.");
                }

                // Create read request Packet
                Packet outPacket = new Packet();
                outPacket.flag = 0xff;
                //outPacket.regNumber = Convert.ToByte(register);
                outPacket.regNumber = (Byte)(register & 0xFF);
                outPacket.value = 0;

                // Serialize Packet to Byte stream
                Byte[] outBuffer = SerializePacket(outPacket);

                // Send the message
                Port.Write(outBuffer, 0, outBuffer.Length);

                try
                {
                    // Read the response
                    Byte[] inBuffer = ReadPacketStream(7);

                    // Deserialize byte stream to a Packet
                    Packet inPacket = DeserializePacket(inBuffer);

                    // return only actual register value
                    return inPacket.value;
                }
                catch (Exception ex)
                {
                    FlushConnection();
                    throw ex;
                }
            }
        }

        /// <summary>
        /// Stop all motion immediately.
        /// </summary>
        public override void Stop() 
        {
            if (ProductSubclass != 4)
            {
                Write(Controller.regLimit_1, 2);
                Write(Controller.regLimit_2, 2);
            }
        }

        /// <summary>
        /// Save all setup register values to non-volatile storage on the controller.
        /// </summary>
        public override void SaveSetup() 
        {
            int status1 = Read(Controller.regStatus_1);
            int status2 = Read(Controller.regStatus_2);
            if (((status1 | status2) & 0x0ff) != 0)
            {
                throw new Exception("Motion must be stopped before setup parameters may be saved");
            }

            const uint regSetupWrite = 0x0E;
            Write(regSetupWrite, 1);
        }

        /// <summary>
        /// Load all setup register values with factory default values. Note, this does 
        /// not effect the values in non-volatile storage.
        /// </summary>
        public override void LoadDefaultSetup() 
        {
            if (ProductID == 0x4001)
            {
                switch (ProductSubclass)
                {
                    case 1:
                    case (unchecked ((int)0xffffffd9)):
                        // 2-phase default setup
                        // Zoom:
                        Write(Controller.regSetupAcceleration_1, 10);
                        Write(Controller.regSetupInitialVelocity_1, 200);
                        Write(Controller.regSetupMaxVelocity_1, 8000);
                        Write(Controller.regSetupReverseBacklash_1, 0);
                        Write(Controller.regSetupForwardBacklash_1, 0);
                        Write(Controller.regSetupConfig_1, 0x02);

                        // Focus:
                        Write(Controller.regSetupAcceleration_2, 10);
                        Write(Controller.regSetupInitialVelocity_2, 100);
                        Write(Controller.regSetupMaxVelocity_2, 2000);
                        Write(Controller.regSetupReverseBacklash_2, 0);
                        Write(Controller.regSetupForwardBacklash_2, 0);
                        Write(Controller.regSetupConfig_2, 0x02);
                        break;
                    case 2:
                        // 5-phase default setup
                        // Zoom:
                        Write(Controller.regSetupAcceleration_1, 10);
                        Write(Controller.regSetupInitialVelocity_1, 400);
                        Write(Controller.regSetupMaxVelocity_1, 2000);
                        Write(Controller.regSetupReverseBacklash_1, 0);
                        Write(Controller.regSetupForwardBacklash_1, 0);
                        Write(Controller.regSetupConfig_1, 0x02);

                        // Focus:
                        Write(Controller.regSetupAcceleration_2, 10);
                        Write(Controller.regSetupInitialVelocity_2, 400);
                        Write(Controller.regSetupMaxVelocity_2, 5000);
                        Write(Controller.regSetupReverseBacklash_2, 0);
                        Write(Controller.regSetupForwardBacklash_2, 0);
                        Write(Controller.regSetupConfig_2, 0x02);
                        break;
                    case 3:
                        // Servo/DC-encoded default setup
                        // Zoom:
                        Write(Controller.regSetupAcceleration_1, 150);
                        Write(Controller.regSetupInitialVelocity_1, 200);
                        Write(Controller.regSetupMaxVelocity_1, 100);
                        Write(Controller.regSetupReverseBacklash_1, 0);
                        Write(Controller.regSetupForwardBacklash_1, 0);
                        Write(Controller.regSetupConfig_1, 0x02);

                        // Focus:
                        Write(Controller.regSetupAcceleration_2, 150);
                        Write(Controller.regSetupInitialVelocity_2, 200);
                        Write(Controller.regSetupMaxVelocity_2, 100);
                        Write(Controller.regSetupReverseBacklash_2, 0);
                        Write(Controller.regSetupForwardBacklash_2, 0);
                        Write(Controller.regSetupConfig_2, 0x02);
                        break;
                    default:
                        throw new Exception("Unrecognized product subclass");
                }
            }
        }

        /// <summary>
        /// The actual serial port object for the connection.
        /// </summary>
        private SerialPort Port { get; set; }
    }
}
