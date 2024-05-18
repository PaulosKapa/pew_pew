using Godot;
using System;
using System.IO.Ports;
using System.Text.RegularExpressions;
using System.Runtime.InteropServices;

public partial class ArduinoTest : Node2D
{
	SerialPort serialPort;
	RichTextLabel text;
	bool hasHeardFromArduino = false;
	float timer;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		serialPort = new SerialPort();

		string[] ports = SerialPort.GetPortNames();

		foreach (string port in ports)
		{
			GD.Print(port);
		}

		text = GetNode<RichTextLabel>("RichTextLabel");

		// bad solution, it won't work if there is any other serial comm device connected to the computer
		if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
		{
			serialPort.PortName = ports[1];
		}
		else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
		{
			serialPort.PortName = ports[0];
		}

		serialPort.BaudRate = 115200; // make sure this is the same in Arduino as it is in Godot
		serialPort.DtrEnable = true; // Enable Data Terminal Ready (DTR)
		serialPort.ReadTimeout = 500; // Set read timeout to 500ms

		try
		{
			serialPort.Open();
			GD.Print("Serial port opened successfully");

			// Wait for the ESP32 to initialize
			System.Threading.Thread.Sleep(2000);
		}
		catch (Exception ex)
		{
			GD.PrintErr($"Failed to open serial port: {ex.Message}");
		}
	}

	public override void _Process(double delta)
	{
		if (!serialPort.IsOpen) return; // checks if serial port is open, if it's not do nothing

		try
		{
			string serialMessage = serialPort.ReadLine();
			GD.Print(serialMessage);
			if (serialMessage != "")
			{
				serialMessage = Regex.Replace(serialMessage, @"[\r\n,]", "");

				char[] serialArray = serialMessage.ToCharArray();
				GD.Print(serialMessage.Length);
			}

			if (serialMessage == "1")
			{
				text.Text = "Hello Arduino, I hear you :)";
				hasHeardFromArduino = true;
				timer = Time.GetTicksMsec();
			}

			if (hasHeardFromArduino && Time.GetTicksMsec() - timer > 3000)
			{
				text.Text += "\n Turning on the Light for you :D";
				serialPort.Write("1");
				hasHeardFromArduino = false;
			}
		}
		catch (TimeoutException)
		{
			GD.PrintErr("Read operation timed out");
		}
		catch (Exception ex)
		{
			GD.PrintErr($"An error occurred while reading from serial port: {ex.Message}");
		}
	}

	public override void _ExitTree()
	{
		if (serialPort.IsOpen)
		{
			serialPort.Close();
		}
		serialPort.Dispose();
	}
}
