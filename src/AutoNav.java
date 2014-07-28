import java.util.Scanner;

import lejos.nxt.*;
import lejos.nxt.Sound;
import lejos.robotics.navigation.*;

import com.mathworks.toolbox.javabuilder.*;
import blahblah.OpticalFlow;

public class AutoNav {
	OpticalFlow test;
	MWStructArray vid;
	DifferentialPilot pilot = new DifferentialPilot(6.0f, 16.0f, Motor.A, Motor.B, true);

	public AutoNav() throws MWException {
		test = new OpticalFlow();
	}
	
	public static void main(String[] args) throws MWException {
		AutoNav nav = new AutoNav();
		nav.startVideo();
		Scanner input = new Scanner(System.in);
		System.out.println("Press 1 to start program: "); 
		while (true) {
			if (input.nextInt() == 1)
				break;
		}
		nav.pilot.setTravelSpeed(1.0d);
		nav.pilot.forward();
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		nav.pilot.setTravelSpeed(3.0d);
		nav.pilot.forward();
		while (true) {
			Object[] ttc = nav.getTTC();
			int[] ttcVals = new int[ttc.length];
			
			for (int i = 0; i < ttc.length; i++) {
				String temp = ttc[i].toString();
				if (temp.equals("Inf")) {
					temp = "1000";
				}
				ttcVals[i] = (int) Math.round(Double.parseDouble(temp));
			}

			if (ttcVals[0] < 100) {
				Sound.beep();
				nav.pilot.stop();
				nav.runCompensation((double) ttcVals[0] * nav.pilot.getTravelSpeed(), ttcVals[1]);
				nav.pilot.forward();
			}
			try {
				Thread.sleep(1500);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
	
	public void startVideo() throws MWException {
		Object[] temp = test.createVid(1);
		vid = (MWStructArray) temp[0];
		System.out.println("Video Input Ready");
	}
	
	public void stopVideo() throws MWException {
		test.stopVid();
	}

	public Object[] getTTC() throws MWException {
		Object[] output = test.main(2, vid);
		System.out.println("TTC: " + output[0]);
		System.out.println("Column Number: " + output[1]);
		return output;
	}

	public void runCompensation(double dist, int mainColumn) {
		int newDist = (int) Math.round(dist / 100); // Assumes between 0-5;
		int multiplier = (mainColumn >= 3) ? 1 : -1;
		switch (newDist) {
		case 0:
			pilot.rotate(multiplier * 50);
			System.out.printf("Heading Angle Change: 50\n");
			break;
		case 1:
			pilot.rotate(multiplier * 40);
			System.out.printf("Heading Angle Change: 40\n");
			break;
		case 2:
			pilot.rotate(multiplier * 30);
			System.out.printf("Heading Angle Change: 30\n");
			break;
		case 3:
			pilot.rotate(multiplier * 20);
			System.out.printf("Heading Angle Change: 20\n");

			break;
		case 4:
			pilot.rotate(multiplier * 10);
			System.out.printf("Heading Angle Change: 10\n");
			break;
		case 5:
			pilot.rotate(multiplier * 5);
			System.out.printf("Heading Angle Change: 5\n");
			break;
		default:
			break;
		}
	}
}
