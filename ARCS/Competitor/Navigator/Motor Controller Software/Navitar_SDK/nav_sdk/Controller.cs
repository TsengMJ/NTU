using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Navitar
{
    /// <summary>
    /// Base class for all controller types.  Includes register definitions for all controller 
    /// types and methods that are common to all controller types.
    /// </summary>
    public class Controller : IDisposable
    {
        /// <summary>
        /// Register number offset for Motor2 registers, relative to Motor 1 registers.
        /// </summary>
        public const uint regOffsetMotor2 = 0x10;

        /// <summary>
        /// The controller Product ID code register
        /// </summary>
        public const uint regProductId = 0x01;

        /// <summary>
        /// Controller Hardware Version Number register
        /// </summary>
        public const uint regVersionHW = 0x02;

        /// <summary>
        /// Controller Version Date register
        /// </summary>
        public const uint regVersionDate = 0x03;

        /// <summary>
        /// Controller Firmware Version number register
        /// </summary>
        public const uint regVersionSW = 0x04;

        /// <summary>
        /// Controller product ID subclass register
        /// </summary>
        public const uint regProductIdSubclass = 0x05;

        /// <summary>
        /// Controller serial number register.  This is unimplemented on legacy controllers.
        /// </summary>
        public const uint regProductSerialNum = 0x06;

        /// <summary>
        /// Target position register for Motor 1.
        /// </summary>
        public const uint regTarget_1 = 0x010;

        /// <summary>
        /// Target position register for Motor 2.
        /// </summary>
        public const uint regTarget_2 = regTarget_1 + regOffsetMotor2;

        /// <summary>
        /// Position delta from current position for Motor 1
        /// </summary>
        public const uint regIncrement_1 = 0x11;

        /// <summary>
        /// Position delta from current position for Motor 2
        /// </summary>
        public const uint regIncrement_2 = regIncrement_1 + regOffsetMotor2;

        /// <summary>
        /// Motor 1 current position
        /// </summary>
        public const uint regCurrent_1 = 0x12;

        /// <summary>
        /// Motor 2 current position
        /// </summary>
        public const uint regCurrent_2 = regCurrent_1 + regOffsetMotor2;

        /// <summary>
        /// Limit seek request for motor 1
        /// </summary>
        public const uint regLimit_1 = 0x13;

        /// <summary>
        /// Limit seek request for motor 2
        /// </summary>
        public const uint regLimit_2 = regLimit_1 + regOffsetMotor2;

        /// <summary>
        /// Motor 1 status
        /// </summary>
        public const uint regStatus_1 = 0x14;

        /// <summary>
        /// Motor 2 status
        /// </summary>
        public const uint regStatus_2 = regStatus_1 + regOffsetMotor2;

        /// <summary>
        /// Motor 1 acceleration setup
        /// </summary>
        public const uint regSetupAcceleration_1 = 0x15;

        /// <summary>
        /// Motor 2 acceleration setup
        /// </summary>
        public const uint regSetupAcceleration_2 = regSetupAcceleration_1 + regOffsetMotor2;

        /// <summary>
        /// Motor 1 initial velocity setup
        /// </summary>
        public const uint regSetupInitialVelocity_1 = 0x16;

        /// <summary>
        /// Motor 2 initial velocity setup
        /// </summary>
        public const uint regSetupInitialVelocity_2 = regSetupInitialVelocity_1 + regOffsetMotor2;

        /// <summary>
        /// Motor 1 maximum velocity setup
        /// </summary>
        public const uint regSetupMaxVelocity_1 = 0x17;

        /// <summary>
        /// Motor 2 maximum velocity setup
        /// </summary>
        public const uint regSetupMaxVelocity_2 = regSetupMaxVelocity_1 + regOffsetMotor2;

        /// <summary>
        /// Motor 1 reverse backlash setup
        /// </summary>
        public const uint regSetupReverseBacklash_1 = 0x18;

        /// <summary>
        /// Motor 2 reverse backlash setup
        /// </summary>
        public const uint regSetupReverseBacklash_2 = regSetupReverseBacklash_1 + regOffsetMotor2;

        /// <summary>
        /// Motor 1 forward backlash setup
        /// </summary>
        public const uint regSetupForwardBacklash_1 = 0x19;

        /// <summary>
        /// Motor 2 forward backlash setup
        /// </summary>
        public const uint regSetupForwardBacklash_2 = regSetupForwardBacklash_1 + regOffsetMotor2;

        /// <summary>
        /// Motor 1 sensor configuration setup
        /// </summary>
        public const uint regSetupConfig_1 = 0x1b;

        /// <summary>
        /// Motor 2 sensor configuration setup
        /// </summary>
        public const uint regSetupConfig_2 = regSetupConfig_1 + regOffsetMotor2;

        /// <summary>
        /// Motor 1 limit position value (read only)
        /// </summary>
        public const uint regSetupLimit_1 = 0x1c;

        /// <summary>
        /// Motor 2 limit position value (read only)
        /// </summary>
        public const uint regSetupLimit_2 = regSetupLimit_1 + regOffsetMotor2;

        /// <summary>
        /// Current PWM setpoint for LED controller
        /// </summary>
        public const uint regPwmAbsolute = 0x40;

        /// <summary>
        /// Increment to PWM setpoint for LED controller
        /// </summary>
        public const uint regPwmIncrement = 0x41;

        /// <summary>
        /// Default setup PWM setpoint for LED controller
        /// </summary>
        public const uint regSetupPwmDefault = 0x42;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="portName">Name of COM or USB virtual COM port to which controller is connected.</param>
        public Controller(string portName) { PortName = portName; }

        /// <summary>
        /// Connect to the controller.
        /// </summary>
        public virtual void Connect() { }

        /// <summary>
        /// True if a connection has been established via a successful call to Connect(),
        /// false otherwise and after a call to Disconnect().
        /// </summary>
        public virtual bool Connected { get; protected set; }

        /// <summary>
        /// Disconnect from the controller.
        /// </summary>
        public virtual void Disconnect() { }

        /// <summary>
        /// Write a value to a controller register.
        /// </summary>
        /// <param name="register">a valid register address for the connected controller</param>
        /// <param name="value">the value to be written to the register</param>
        public virtual void Write(uint register, int value) { }

        /// <summary>
        /// Read a value from a controller register.
        /// </summary>
        /// <param name="register">a valid register address for the connected controller</param>
        /// <returns>the current register value</returns>
        public virtual int Read(uint register) { return 0; }

        /// <summary>
        /// Stop all motion immediately.
        /// </summary>
        public virtual void Stop() { }

        /// <summary>
        /// Save all setup register values to non-volatile storage on the controller.
        /// </summary>
        public virtual void SaveSetup() { }

        /// <summary>
        /// Load all setup register values with factory default values. Note, this does 
        /// not effect the values in non-volatile storage.
        /// </summary>
        public virtual void LoadDefaultSetup() { }

        /// <summary>
        /// Controller class implements IDisposable.  Inheriting classes should override this method.
        /// </summary>
        public virtual void Dispose() { }

        /// <summary>
        /// Name of COM port or USB virtual COM port to which controller is connected.
        /// </summary>
        public string PortName { get; protected set; }

        /// <summary>
        /// The user-assigned name of the specific controller.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// The read-only Product ID of the specific controller.
        /// </summary>
        public int ProductID { get; protected set; }

        /// <summary>
        /// The read-only Product Subclass of the specific controller.
        /// </summary>
        public int ProductSubclass { get; protected set; }

        /// <summary>
        /// The controller generation (version in the larger sense).
        /// </summary>
        public int Generation { get; protected set; }
    }
}
