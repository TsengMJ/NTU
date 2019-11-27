using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO.Ports;

namespace Navitar
{
    /// <summary>
    /// The ControllerHub acts as a factory for Controller instances. It is responsible for
    /// discovering and enumerating all controllers physically connected to the system over
    /// either serial or USB connections.  Discovery and enumeration will occur automatically
    /// when the application starts, but can also be repeated on demand by calling the
    /// DiscoverControllers method to detect controllers that are connected after program
    /// startup.
    /// </summary>
    public static class ControllerHub
    {
        /// <summary>
        /// At construction time, the hub will internally call DiscoverControllers()
        /// to discover and enumerate all connected controllers.
        /// </summary>
        static ControllerHub()
        {
            _controllers = new List<Controller>();

            DiscoverControllers();
        }

        /// <summary>
        /// Returns the collection of all controller instances known to the hub.
        /// </summary>
        /// <returns>A collection of all connected controllers.</returns>
        public static ICollection<Controller> GetAll()
        {
            return _controllers;
        }

        /// <summary>
        /// Discover and enumerate all physically connected controllers.  This method
        /// is called automatically at construction of the hub, so the application need
        /// only call it if controllers need to be discovered after program startup.
        /// A Controller instance will be created for each newly discovered controller.
        /// Likewise, Controllers will be dropped for controllers no longer present.
        /// Since discovery requires communicating with the controller, the hub will
        /// perform the equivalent of a Disconnect() call on each existing Controller 
        /// instance before or during the disovery process.
        /// </summary>
        public static void DiscoverControllers()
        {
            // Empty the list of currently known controllers first.
            foreach (Controller controller in _controllers)
            {
                controller.Disconnect();
                controller.Dispose();
            }
            _controllers.Clear();

            try
            {
                // First get list of COM port names
                string[] ports = SerialPort.GetPortNames();

                Trace.WriteLine("The following serial ports were found:");
                foreach (string port in ports)
                {
                    Trace.Write(port + " ");
                }
                Trace.Write("\n");

                // Display each port name to the console. 
                foreach (string port in ports)
                {
                    Controller controller = null;

                    // Try to create a legacy controller
                    try
                    {
                        controller = new ControllerLegacy(port);
                        controller.Connect();
                    }
                    catch (Exception ex)
                    {
                        if (controller != null)
                        {
                            controller.Disconnect();
                            controller = null;
                        }
                        Debug.WriteLine(port + " is not a legacy controller.");
                        Debug.Write(ex.ToString());
                    }

                    // If not a legacy controller, try a 2nd generation controller
                    if (controller == null)
                    {
                        try
                        {
                            controller = new ControllerGen2(port);
                            controller.Connect();
                        }
                        catch (Exception ex)
                        {
                            if (controller != null)
                            {
                                controller.Disconnect();
                                controller = null;
                            }
                            Debug.WriteLine(port + " is not a gen-2 controller.");
                            Debug.Write(ex.ToString());
                        }
                    }

                    // If we successfully created any controller, add it to our list
                    if (controller != null)
                    {
                        _controllers.Add(controller);
                    }
                }
            }
            catch (Exception)
            {
                return;
            }
        }

        /// <summary>
        /// Remove a controller instance from the collection of controllers known to the hub,
        /// thus making the connection available to some other program.
        /// This method is most useful when performing a firmware upgrade on a controller that
        /// is connected via USB, since the Device Firmware Upgrade protocol operates over USB.
        /// </summary>
        /// <param name="controller">the controller instance to be removed</param>
        public static void RemoveController(Controller controller)
        {
            if (_controllers.Contains(controller))
            {
                _controllers.Remove(controller);
                controller.Disconnect();
                controller.Dispose();
            }
        }

        /// <summary>
        /// Controller instances for all controllers found during the most recent
        /// discovery attempt.
        /// </summary>
        private static List<Controller> _controllers;

    }
}
