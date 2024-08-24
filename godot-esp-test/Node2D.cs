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

		string[] ports = SerialPort.GetPortNames();
		
		foreach (string port in ports){
			GD.Print(port);
		}

		text = GetNode<RichTextLabel>("RichTextLabel");
		serialPort = new SerialPort();
		//bad solution, it won't work if there is any other serial comm device connected to the computer
		if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
		{
			serialPort.PortName = ports[1];
		}	
		else if(RuntimeInformation.IsOSPlatform(OSPlatform.Windows)){
			serialPort.PortName = ports[0];
		}
		serialPort.BaudRate = 9600; //make sure this is the same in Arduino as it is in Godot.
		
		serialPort.Open();
		
	}

	public override void _Process(double delta)
	{
		if(!serialPort.IsOpen) return; //checks if serial port is open, if it's not do nothing.
//		
	
		string serialMessage = serialPort.ReadLine();
		if(serialMessage!=""){
	serialMessage = Regex.Replace(serialMessage, @"[\r\n,]", "");
//			serialMessage = Regex.Replace(serialMessage, @",", "");
		//	GD.Print(serialMessage);
			char[] serialArray = serialMessage.ToCharArray();
			//GD.Print(serialArray[1]);
			GD.Print(serialMessage.Length);
			//foreach (char letter in serialMessage)
			//{
			///// Print each letter
		//	GD.Print(letter);
			//}
			//GD.Print(serialMessage == "1");
			//GD.Print("1".Length);
			//foreach (char letter in "1")
			//{
			////// Print each letter
			//GD.Print(letter);
			//}
		}
		
//
		if(serialMessage == "1"){
			text.Text = "Hello Arduino, I hear you :)";
			hasHeardFromArduino = true;
			timer = Time.GetTicksMsec();
		}
//
		if(hasHeardFromArduino && Time.GetTicksMsec() - timer > 3000){
			text.Text += "\n Turning on the Light for you :D";
			serialPort.Write("1");
			hasHeardFromArduino = false;
		}
	}
}
