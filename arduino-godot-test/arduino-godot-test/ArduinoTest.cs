using Godot;
using System;
using System.IO.Ports;
using System.Text;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;

public partial class ArduinoTest : Node2D
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
		
			ReadSerialPort();
			if(Input.IsActionJustPressed("ui_accept")){
				DataInput(1,3);
			}
		
	}

	private void ReadSerialPort()
	{
		if (!serialPort.IsOpen) return; // Check if the serial port is open, if not, do nothing

		try
		{
			string serialMessage = serialPort.ReadExisting();
			if (!string.IsNullOrEmpty(serialMessage))
			{
				buffer.Append(serialMessage);
				ProcessBuffer();
			}
		}
		catch (Exception ex)
		{
			GD.PrintErr($"An error occurred while reading from the serial port: {ex.Message}");
		}
	}

	private void ProcessBuffer()
	{
		string data = buffer.ToString();
		int newLineIndex;

		while ((newLineIndex = data.IndexOf('\n')) != -1)
		{
			string line = data.Substring(0, newLineIndex).Trim();
			if (!string.IsNullOrEmpty(line))
			{
				//line = Regex.Replace(line, @"[\r\n,]", "");
				string[] values = line.Split(',');
				//char[] serialArray = line.ToCharArray();
				GD.Print(values[0]+", "+values[1]+", "+values[2]);
				//ProcessLine(line);
			}

			data = data.Substring(newLineIndex + 1);
		}

		buffer.Clear();
		buffer.Append(data);
	}

	private void DataInput(int Message, int position){
		if (!serialPort.IsOpen) return;
		try
		{
			//GD.Print(Message.ToString() + "," + position.ToString());
			serialPort.WriteLine(Message.ToString() + "," + position.ToString());
			
		}
		catch (Exception ex)
		{
			GD.PrintErr($"An error occurred while reading from the serial port: {ex.Message}");
		}
	}
}
