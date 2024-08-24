using Godot;
using System;
using System.IO.Ports;
using System.Text;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;

public partial class controller : Node
{
	private SerialPort serialPort;
	private StringBuilder buffer = new StringBuilder();

	public override void _Ready()
	{
		serialPort = new SerialPort();
		string[] ports = SerialPort.GetPortNames();

		foreach (string port in ports)
		{
			GD.Print(port);
		}

	

		//// bad solution, it won't work if there is any other serial comm device connected to the computer
		if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
		{
			serialPort.PortName = ports[1];
		}
		else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
		{
			serialPort.PortName = ports[0];
		}
		serialPort.BaudRate = 115200;
		//serialPort.PortName = "COM5";
		serialPort.DtrEnable = true; // Enable Data Terminal Ready (DTR)
		serialPort.RtsEnable = true; // Enable Request to Send (RTS)
		serialPort.Open();
	}

	public override void _Process(double delta)
	{
			if (!serialPort.IsOpen) return; // Check if the serial port is open, if not, do nothing

		try
		{
			//(String(sensorData.X) + ',' + String(sensorData.Y) + ',' + String(sensorData.Z)+ ',' +String(sensorData.shot) + ',' +  String(sensorData.actions) + ',' +String(sensorData.magId) +',' +String(sensorData.gunId) + ',' + String(sensorData.shootingMode) +','+String(sensorData.unlock));// 
			GD.Print(serialPort.ReadLine());
		}
		catch (Exception ex)
		{
			GD.PrintErr($"An error occurred while reading from the serial port: {ex.Message}");
		}
	}
}
