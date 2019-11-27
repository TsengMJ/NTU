using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.IO.Ports;

namespace Navitar
{
    /// <summary>
    /// 2nd Generation Controller base class.  In general, this class adds capabilities
    /// that are not available in 1st generation controllers.
    /// </summary>
    public class ControllerGen2 : Controller
    {
        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="portName">Name of COM or USB virtual COM port to which controller is connected.</param>
        public ControllerGen2(string portName)
            : base(portName)
        {
            Generation = 2;
            Disposed = false;
        }

        /// <summary>
        /// Connect to the controller.
        /// </summary>
        public override void Connect()
        {
            if (Port != null)
            {
                return;
            }

            lock (this)
            {
                try
                {
                    // Create and open the port.
                    Port = new SerialPort(PortName, 38400);
                    Port.Open();

                    // Default read timeout of .5 sec.  We may need to modify for certain commands.
                    Port.ReadTimeout = 500;
                    Port.WriteTimeout = 500;

                    byte[] ctrlCbuf = new byte[1];
                    ctrlCbuf[0] = 3;
                    Port.Write(ctrlCbuf, 0, 1);

                    System.Threading.Thread.Sleep(100);
                    string response = Port.ReadExisting();
                }
                catch (Exception)
                {
                    if (Port != null)
                    {
                        Port.Close();
                        Port.Dispose();
                        Port = null;
                    }
                    throw;
                }
            }

            ProductID = Read(Controller.regProductId);
            ProductSubclass = Read(Controller.regProductIdSubclass);

            if (ProductID == 0x5001)
            {
                switch (ProductSubclass)
                {
                    case 1:
                        Name = "2-Phase";
                        break;
                    case 2:
                        Name = "5-Phase";
                        break;
                    case 3:
                        Name = "Encoded";
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
                lock (this)
                {
                    try
                    {
                        // Close and destroy the port
                        Port.Close();
                        Port.Dispose();
                    }
                    catch (Exception ex)
                    {
                    }
                }
                Port = null;
            }
        }

        /// <summary>
        /// Write a value to a controller register.
        /// </summary>
        /// <param name="register">a valid register address for the connected controller</param>
        /// <param name="value">the value to be written to the register</param>
        public override void Write(uint register, int value)
        {
            //Debug.WriteLine("write " + register.ToString() + " " + value.ToString());
            string response;
            ExecuteCommand("write " + register.ToString() + " " + value.ToString(), out response);

            // response should be just the register value
            if (int.Parse(response) != value)
            {
                throw new Exception("write failed.");
            }
        }

        /// <summary>
        /// Read a value from a controller register.
        /// </summary>
        /// <param name="register">a valid register address for the connected controller</param>
        /// <returns>the current register value</returns>
        public override int Read(uint register)
        {
            string response;
            ExecuteCommand("read " + register.ToString(), out response);

            // response should be just the register value
            int value;
            try
            {
                value = Convert.ToInt32(response);
            }
            catch (System.FormatException)
            {
                try
                {
                    value = Convert.ToInt32(response, 16);
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }

            return value;
        }

        /// <summary>
        /// Stop all motion immediately.
        /// </summary>
        public override void Stop()
        {
            ExecuteCommand("stopall");
        }

        /// <summary>
        /// Save all setup register values to non-volatile storage on the controller.
        /// </summary>
        public override void SaveSetup()
        {
            ExecuteCommand("savesetup", 5000);
        }

        /// <summary>
        /// Load all setup register values with factory default values. Note, this does 
        /// not effect the values in non-volatile storage.
        /// </summary>
        public override void LoadDefaultSetup()
        {
            ExecuteCommand("defaultsetup");
        }

        /// <summary>
        /// Causes the controller to stop all motion, disconnect and immediately
        /// enter the bootloader (e.g. to await a firmware upgrade).  Note, communicating
        /// to the controller when in the Bootloader requires a separate protocol and is 
        /// outside the scope and capability of this API.
        /// </summary>
        public virtual void EnterBootloader() 
        {
            // Ensure motion is stopped
            Stop();
            System.Threading.Thread.Sleep(500);

            lock (this)
            {
                // Send the command string
                // We do this manually, because there will be not response to the command.
                Port.WriteLine("programfirmware");
                Port.BaseStream.Flush();
            }

            // Automatically disconnect
            Disconnect();
        }

        /// <summary>
        /// Controller class implements IDisposable.  Inheriting classes should override this method.
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
        /// Send a single command line to the controller.
        /// </summary>
        /// <param name="cmd">the command string to execute</param>
        /// <param name="delayAfterCmd">milliseconds to delay after command is sent.</param>
        private void ExecuteCommand(string cmd, int delayAfterCmd = 0)
        {
            lock (this)
            {
                // Send the command string
                Port.WriteLine(cmd);

                if (delayAfterCmd != 0)
                {
                    System.Threading.Thread.Sleep(delayAfterCmd);
                }

                // Controller will echo back the command (for convenience when using terminal).
                Port.ReadLine();

                // Read the prompt.
                ReadPrompt();
            }
        }

        /// <summary>
        /// Read a command prompt, "$ ", from the controller.
        /// </summary>
        private void ReadPrompt()
        {
            System.Threading.Thread.Sleep(1);
            byte[] prompt = new byte[2];
            int bytesRead = 0;
            while (bytesRead < 2)
            {
                bytesRead += Port.Read(prompt, bytesRead, 2 - bytesRead);
            }
            if (prompt[0] != 36 || prompt[1] != 32)
            {
                Port.ReadExisting();
                throw new Exception("Prompt not received.");
            }
        }

        /// <summary>
        /// Send a single command line to the controller and receive the response.
        /// </summary>
        /// <param name="cmd">the command string to execute</param>
        /// <param name="response">[OUT] the controller response string.</param>
        private void ExecuteCommand(string cmd, out string response)
        {
            lock (this)
            {
                // Send the command string
                Port.WriteLine(cmd);

                // Controller will echo back the command (for convenience when using terminal).
                Port.ReadLine();

                // Now fetch the response
                response = Port.ReadLine();

                // Read the prompt.
                ReadPrompt();
            }
        }

        /// <summary>
        /// The actual serial port object for the connection.
        /// </summary>
        private SerialPort Port { get; set; }
    }
}
